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
    end

    def import_save
      @cert = Cert.new(params[:foreman_cfssl_cert].permit(:owner_email, :pem, :key))

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
      config_path = SETTINGS[:foreman_cfssl][:config]
      config = JSON.parse(File.read(config_path))
      @profiles = config['signing']['profiles'].keys
    end

    def create
      @cert = Cert.new(params[:foreman_cfssl_cert].permit(:owner_email, :common_name, :profile, :hosts))
      configs = SETTINGS[:foreman_cfssl]
      ca = configs[:ca]
      ca_key = configs[:ca_key]
      ca_config = configs[:config]

      # certificate signing request
      csr = JSON.parse(File.read(configs[:csr_template]))
      csr['CN'] = @cert.common_name
      csr['hosts'] = @cert.hosts.strip.split(%r{\s+})

      stdin, stdout, stderr = Open3.popen3("cfssl gencert -config=#{ca_config} -ca=#{ca} -ca-key=#{ca_key} -profile=#{@cert.profile} -")
      stdin.puts JSON.dump(csr)
      stdin.close

      result = JSON.parse(stdout.gets(sep=nil))
      @cert.pem = result['cert']
      @cert.key = result['key']

      self.expand_pem

      if @cert.save
        redirect_to certs_path
      else
        render 'new'
      end
    end

    def show
    end

    def expand_pem
      cert_info = self.extract_cert_info(@cert.pem)

      @cert.subject = JSON.dump(cert_info['subject'])
      @cert.issuer = JSON.dump(cert_info['issuer'])
      @cert.serial_number = cert_info['serial_number']
      @cert.sans = JSON.dump(cert_info['sans']) # TODO handle empty string
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
