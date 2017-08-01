module ForemanCfssl
  require 'date'
  require 'open3'
  require 'json'
  class CertsController < ApplicationController
    def index
      @certs = Cert.all.paginate(:page => params[:page]).order(params[:order])
    end

    def import
      @cert = Cert.new
      @allow_key_import = ['allow', 'true'].include?(SETTINGS[:foreman_cfssl][:private_key_import])
    end

    def import_save
      @cert = Cert.new(params[:foreman_cfssl_cert].permit(:owner_email, :pem, :key))

      allow_key_import = ['allow', 'true'].include?(SETTINGS[:foreman_cfssl][:private_key_import])
      if @cert.key.include?('PRIVATE') && !allow_key_import
        @cert.errors.add(:key, "Don't upload an unencrypted private key. Consider encrypting it.")
        render 'import' and return
      end

      @cert.user = User.current
      @cert.imported_at = Time.now

      self.expand_pem

      if @cert.save
        redirect_to certs_path
      else
        render 'import'
      end
    end

    def new
      @cert = Cert.new

      # profiles for select
      config_path = SETTINGS[:foreman_cfssl][:config]
      config = JSON.parse(File.read(config_path))
      @profiles = config['signing']['profiles'].keys

      # CA information
      ca_pem = File.read(SETTINGS[:foreman_cfssl][:ca])
      @ca_info = JSON.pretty_generate(extract_cert_info(ca_pem))
    end

    def create
      # Added several attr_accessors in model to ease form processing
      @cert = Cert.new(params[:foreman_cfssl_cert].permit(:owner_email, :common_name, :profile, :hosts))

      # Read ini configurations
      configs = SETTINGS[:foreman_cfssl]
      ca = configs[:ca]
      ca_key = configs[:ca_key]
      ca_config = configs[:config]
      csr_template = configs[:csr_template]

      # fill in details to create certificate signing request config
      csr = JSON.parse(File.read(csr_template))
      csr['CN'] = @cert.common_name
      csr['hosts'] = @cert.hosts.strip.split(%r{\s+})

      # generate certificates
      stdin, stdout, stderr = Open3.popen3("cfssl gencert -config=#{ca_config} -ca=#{ca} -ca-key=#{ca_key} -profile=#{@cert.profile} -")
      stdin.puts JSON.dump(csr)
      stdin.close

      result = JSON.parse(stdout.gets(sep=nil))
      @cert.pem = result['cert']
      @cert.key = result['key']
      @cert.user = User.current

      self.expand_pem

      if @cert.save
        redirect_to certs_path
      else
        render 'new'
      end
    end

    def show
      @cert = Cert.find(params[:id])
    end

    def expand_pem
      cert_info = self.extract_cert_info(@cert.pem)

      @cert.subject = JSON.dump(cert_info['subject'])
      @cert.issuer = JSON.dump(cert_info['issuer'])
      @cert.serial_number = cert_info['serial_number']
      @cert.sans = cert_info.has_key?('sans') ? JSON.dump(cert_info['sans']) : '[]'
      @cert.not_before = DateTime.parse(cert_info['not_before'])
      @cert.not_after = DateTime.parse(cert_info['not_after'])
      @cert.sigalg = cert_info['sigalg']
      @cert.authority_key_id = cert_info['authority_key_id']
      @cert.subject_key_id = cert_info['subject_key_id']
    end

    def extract_cert_info(pem)
      stdin, stdout, stderr = Open3.popen3('cfssl certinfo -cert=-')
      stdin.puts pem
      stdin.close

      return JSON.parse(stdout.gets(sep=nil))
    end
  end
end
