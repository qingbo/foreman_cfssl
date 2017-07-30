module ForemanCfssl
  class Cert < ActiveRecord::Base
    #attr_accessor :owner_email, :imported_at, :profile, :subject,
    #  :issuer, :serial_number, :sans, :not_before, :not_after, :sigalg,
    #  :authority_key_id, :subject_key_id, :pem, :key
    def subject_info
      JSON.parse(subject)
    end

    def issuer_info
      JSON.parse(issuer)
    end

    def sans_info
      JSON.parse(sans)
    end
  end
end
