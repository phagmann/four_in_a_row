class PiecesController < ApplicationController
  before_action :authenticate_player! #, only: [:show, :edit, :update, :destroy]
  respond_to :html
  require './lib/ai.rb'
  def update
    piece = slide_piece_down(params[:x] , params[:y])
    piece.identity = 1

    piece.save
    


    pieces_in_game = Piece.where( player_id: params[:player_id], game_id: params[:game_id] )
    
    datas = get_data(pieces_in_game, (0..6), (0..6))
    return redirect_to game_path if Ai.if_array_win(datas) < 3

    comp_move = Ai.ComputersTurn(Marshal.load(Marshal.dump(datas)))
    comp_piece = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: comp_move[0], x: comp_move[1])
    comp_piece.identity = 2
    comp_piece.save

    
    respond_with(Game.find_by(player_id: piece.player_id , id: piece.game_id ))

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

   def piece_params
      params.require(:piece).permit(:player_id, :game_id, :x , :y, :identity)
   end
end
