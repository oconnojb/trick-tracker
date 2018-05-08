class CreateDogTricks < ActiveRecord::Migration[5.2]
  def change
    create_table :dog_tricks do |t|
      t.integer :dog_id
      t.integer :trick_id
    end
  end
end
