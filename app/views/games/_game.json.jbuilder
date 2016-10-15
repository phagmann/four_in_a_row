json.extract! game, :id, :player_id, :name, :created_at, :updated_at
json.url game_url(game, format: :json)