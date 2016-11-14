require './lib/ai.rb'
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
    piece = slide_piece_down(params[:x] , params[:y])
    piece.identity = 1

    piece.save
    
    @game.save 


    pieces_in_game = Piece.where( player_id: params[:player_id], game_id: params[:game_id] )
    
    datas = get_data(pieces_in_game, (0..6), (0..6))
    return respond_with(@game) if Ai.if_array_win(datas) < 3

    comp_move = Ai.ComputersTurn(Marshal.load(Marshal.dump(datas)))
    comp_piece = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: comp_move[0], x: comp_move[1])
    comp_piece.identity = 2
    comp_piece.save

    @game.save 
    
    respond_with(@game)
  end

  def destroy
    @game.destroy
    respond_with(@game)
  end

  private


    def slide_piece_down(x,y)
      curr_x = x.to_i
      curr_y = y.to_i
      while curr_y <= 6
         pp = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y, x: curr_x )
         return Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y - 1, x: curr_x ) if pp.identity > 0
         curr_y += 1
      end
      return Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y - 1, x: curr_x )


    end

    def get_data(pieces,col,row)
      data = []
      row.each do |r|
      
        section = []
        col.each do |c|
          section << pieces.find_by(y: r, x: c).identity

        end
        data << section

      end
      
    return data
   end

    

    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:player_id, :name)
    end

    def piece_params
      params.require(:piece).permit(:player_id, :game_id, :x , :y, :identity)
    end
end
