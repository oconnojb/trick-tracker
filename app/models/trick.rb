class Trick < ActiveRecord::Base
  has_many :dog_tricks
  has_many :dogs, through: :dog_tricks
  has_many :users, through: :dogs
end
