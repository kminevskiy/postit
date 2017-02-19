class AddPinAndPhoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pin, :string
    add_column :users, :phone, :string
  end
end
