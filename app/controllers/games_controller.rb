
# figure out this with heroku

# HOMEWORK
# codeship.com creat account
# hook up repo
# test
class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_player! #, only: [:show, :edit, :update, :destroy]
  respond_to :html
  def index
    @games = Game.where( player_id: current_player.id )
    respond_with(@games)
  end

  def show
    @game = Game.find(params[:id])
    respond_with(@game)
  end

  def new
  end

  def edit
    @game = Game.find(params[:id])
    # @game.save
    # respond_with(@game)
  end

  def create
    @game = current_player.games.create(game_params)
    @game.player_id = current_player.id
    @row = (0..6)
    @col = (0..6)
    @row.each do |current_row|
      @col.each do |current_col|
        p = Piece.create(:player_id => current_player.id, :game_id => @game.id, :y => current_row , :x => current_col, :identity => 0)
      end
    end
    @game.save
    respond_with(@game)
  end

  def update
    @game = Game.find(params[:id])
    # why the fuck doesn game_params work?
    @game.update_attributes(game_params)
    @game.save

    respond_with(@game)
  end

  def destroy
    @game.destroy
    respond_with(@game)
  end

  private


    

    

    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:player_id, :name)
    end

    
end
