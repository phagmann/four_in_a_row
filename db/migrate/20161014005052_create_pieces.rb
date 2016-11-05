class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :x
      t.integer :y
      t.integer :identity
      t.timestamps
    end
  end
end
