require 'ruby-prof'
require './lib/ai.rb'
class PiecesController < ApplicationController
  before_action :authenticate_player! #, only: [:show, :edit, :update, :destroy]
  respond_to :html
  def update 
    # RubyProf.start

    piece = slide_piece_down(params[:x] , params[:y])
    piece.identity = 1

    piece.save
    

    
    datas = get_data
    return redirect_to game_path if Ai.if_array_win(datas) < 3

    comp_move = Ai.ComputersTurn(Marshal.load(Marshal.dump(datas)))
    comp_piece = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: comp_move[0], x: comp_move[1])
    comp_piece.identity = 2
    comp_piece.save

    # result = RubyProf.stop
    # filename = "update"
    # File.open("/home/vagrant/#{filename}.html","w") do |file|
    #   RubyProf::CallStackPrinter.new(result).print(file)
    # end
    respond_with(Game.find_by(player_id: piece.player_id , id: piece.game_id ))

   end

   private

   def slide_piece_down(x,y)
      return Piece.where(player_id: params[:player_id], game_id: params[:game_id], x: x).where("y >= ?",y).order(y: :desc).where(identity: 0).limit(1).first

      # byebug
      # curr_x = x.to_i
      # curr_y = y.to_i
      # #FIX
      # while curr_y <= 6
      #    pp = Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y, x: curr_x )
      #    return Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y - 1, x: curr_x ) if pp.identity > 0
      #    curr_y += 1
      # end
      # return Piece.find_by( player_id: params[:player_id], game_id: params[:game_id], y: curr_y - 1, x: curr_x )


    end

    def get_data
      game_pieces = Piece.where(player_id: params[:player_id], game_id: params[:game_id])
      data = []
      7.times do
        data << [0,0,0,0,0,0,0]
      end
      game_pieces.each do |piece|
        data[piece.y][piece.x] = piece.identity 
      end
      return data



    #   data = []
    #   row.each do |r|
      
    #     section = []
    #     col.each do |c|
    #       section << pieces.find_by(y: r, x: c).identity

    #     end
    #     data << section

    #   end
      
    # return data
   end

   def piece_params
      params.require(:piece).permit(:player_id, :game_id, :x , :y, :identity)
   end
end
