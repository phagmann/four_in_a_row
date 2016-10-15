class PiecesController < ApplicationController
    before_action :authenticate_player!
end
