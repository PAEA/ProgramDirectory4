class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token

      t.timestamps
    end
    add_index :users, :login, unique: true

    add_adea_user = User.create(
      login: 'adea',
      crypted_password: '400$8$39$55fe8bf9eea42920$3d8584d6074014a33fce7308d0e1aa10c3838fcc5134890e42039144cb2dcdb9',
      password_salt: '3MPLG2xOER1hFJFtSHqg',
      persistence_token: 'c7f7dca3491152b8fc14cf5b750224081a3bec50fd07bbc10b7c91f2501bae43ebb785c5ea278fddc271196e5dd1cfaefb1b6122907105c0bb528739fb29494c'
    )
  end
end
