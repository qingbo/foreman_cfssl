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
  end
end
