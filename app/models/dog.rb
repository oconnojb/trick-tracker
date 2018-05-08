class Dog < ActiveRecord::Base
  belongs_to :user
  has_many :dog_tricks
  has_many :tricks, through: :dog_tricks

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
end
