class StaticPageController < ApplicationController
    before_action :authenticate_player!
    def index
    end
end
