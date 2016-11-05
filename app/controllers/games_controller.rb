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
    @game = Game.new(game_params)
    @game.player_id = current_player.id
    @game.track = 0
    @row = (0..4)
    @col = (0..4)
    @row.each do |current_row|
      @col.each do |current_col|
        Piece.create(:player_id => current_player.id, :game_id => @game.id, :y => current_row , :x => current_col, :identity => 0)
      end
    end
    @game.save
    respond_with(@game)
  end

  def update
    #piece = Piece.new
    
    piece = Piece.find_by(y: params[:y] , x: params[:x])
    piece.identity += 1
    piece.save
    puts "pledging"
    puts piece.identity
    @game.track += 1
   

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
      params.require(:game).permit(:player_id, :name, :track)
    end

    def piece_params
      params.require(:piece).permit(:player_id, :game_id, :x , :y, :identity)
    end
end
