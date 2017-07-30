module ForemanCfssl
  class CertsController < ApplicationController

    def index
      @list = "1, 2, 3"
    end

    def new
      @cert = Cert.new
    end

    def create
    end

    def show
    end
  end
end
