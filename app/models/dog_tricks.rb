class DogTricks < ActiveRecord::Base
  belongs_to :dog
  belongs_to :trick
end
