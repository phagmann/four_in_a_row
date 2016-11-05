class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_id
      t.string :name
      t.integer :track
      t.timestamps
    end
  end
end
