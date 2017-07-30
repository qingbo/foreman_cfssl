module ForemanCfssl
  class Cert < ActiveRecord::Base
    # quick hack to ease form submission
    attr_accessor :common_name, :hosts

    def subject_info
      JSON.parse(subject)
    end

    def issuer_info
      JSON.parse(issuer)
    end

    def sans_info
      JSON.parse(sans)
    end

    def source_type
      imported_at ? "Imported" : "Generated"
    end

    def expired?
      not_after < Time.now
    end

    def expiring?
      not_after < Time.now + 30.days && ! expired?
    end
  end
end
