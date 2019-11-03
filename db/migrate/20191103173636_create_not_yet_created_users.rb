class CreateNotYetCreatedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :not_yet_created_users do |t|
      t.string :uuid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :role

      t.timestamps
    end
  end
end
