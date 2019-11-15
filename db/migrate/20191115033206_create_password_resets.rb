class CreatePasswordResets < ActiveRecord::Migration[5.2]
  def change
    create_table :password_resets do |t|
      t.string :uuid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
