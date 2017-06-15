class CreateUsers < ActiveRecord::Migration[5.0]

  def up
    create_table :users do |t|
      t.string :login
      t.string :password

      t.timestamps
    end
    add_index :users, :login, unique: true
  end

  def down

    drop_table :users

  end

end
