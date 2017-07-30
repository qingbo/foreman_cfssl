module ForemanCfssl
  require 'date'
  require 'open3'
  require 'json'
  class CertsController < ApplicationController
    def index
      @certs = Cert.all.paginate :page => params[:page]
    end

    def import
      @cert = Cert.new
    end

    def import_save
      @cert = Cert.new(params[:foreman_cfssl_cert].permit(:owner_email, :pem, :key))
      cert_info = self.extract_cert_info(@cert.pem)

      @cert.imported_at = Time.now
      @cert.subject = JSON.dump(cert_info['subject'])
      @cert.issuer = JSON.dump(cert_info['issuer'])
      @cert.serial_number = cert_info['serial_number']
      @cert.sans = JSON.dump(cert_info['sans']) # TODO handle empty string
      @cert.not_before = DateTime.parse(cert_info['not_before'])
      @cert.not_after = DateTime.parse(cert_info['not_after'])
      @cert.sigalg = cert_info['sigalg']
      @cert.authority_key_id = cert_info['authority_key_id']
      @cert.subject_key_id = cert_info['subject_key_id']

      if @cert.save
        redirect_to certs_path
      else
        render 'import'
      end
    end

    def new
    end

    def create
    end

    def show
    end


    def extract_cert_info(pem)
      stdin, stdout, stderr = Open3.popen3('cfssl certinfo -cert=-')
      stdin.puts pem
      stdin.close

      return JSON.parse(stdout.gets(sep=nil))
    end
  end
end
