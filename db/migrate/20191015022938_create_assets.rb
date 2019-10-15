class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.string :storageURL
      t.references :lesson, foreign_key: true

      t.timestamps
    end
  end
end
