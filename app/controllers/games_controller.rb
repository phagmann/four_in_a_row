require '/lib/ai.rb'
# figure out this with heroku

# HOMEWORK
# codeship.com creat account
# hook up repo
# test
class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_player!
  respond_to :html
  # TODO: Play with shit with Pieces and Games
  def index
    @games = Game.all
    respond_with(@games)
  end

  def show
    respond_with(@game)
  end

  def new
    @game = Game.new
    respond_with(@game)
  end

  def edit
  end

  def create
    @game = Game.create(game_params)
    @game.player_id = current_player.id
    @game.track = 0
    @row = (0..4)
    @col = (0..4)
    @row.each do |current_row|
      @col.each do |current_col|
        p = Piece.create(:player_id => current_player.id, :game_id => @game.id, :y => current_row , :x => current_col, :identity => 0)
      end
    end
    @game.save
    respond_with(@game)
  end

  def update
    piece = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: params[:y] , x: params[:x])

    if @game.track % 2 == 0
      piece.identity = 1
    elsif @game.track % 2 == 1
      piece.identity = 2
    end
    @game.track += 1

    piece.save
    # check if win then stop game
    @game.save 

    # computers turn
    # puts ExecJS.eval " computersTurn() "
    ExecJS.eval "test()" #can't load application.js or can't use them
    # check if win then stop game


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
      params.require(:game).permit(:player_id, :name, :track)
    end

    def piece_params
      params.require(:piece).permit(:player_id, :game_id, :x , :y, :identity)
    end
end
