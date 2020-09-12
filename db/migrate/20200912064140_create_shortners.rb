class CreateShortners < ActiveRecord::Migration[6.0]
  def change
    create_table :shortners do |t|
      t.string :short_url
      t.string :long_url
      t.integer :visits_count, null: false, default: 0

      t.timestamps
    end
    add_index :shortners, :short_url, unique: true
    add_index :shortners, :long_url, unique: true
  end
end
