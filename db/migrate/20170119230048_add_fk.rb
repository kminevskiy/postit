class AddFk < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :users, index: true, foreign_key: true
  end
end
