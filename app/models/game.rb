class Game < ActiveRecord::Base
    has_many :pieces
    belongs_to :player
    
end
