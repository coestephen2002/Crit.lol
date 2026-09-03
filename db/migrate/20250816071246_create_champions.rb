class CreateChampions < ActiveRecord::Migration[7.1]
  def change
    create_table :champions, id: :uuid do |t|
      t.string :name, null: false
      t.string :title
      t.string :icon_url, null: false
      t.string :riot_id, null: false
      t.integer :riot_key, null: false
      t.string :tags, array: true, default: [], null: false

      t.timestamps
    end

    add_index :champions, :riot_id, unique: true
    add_index :champions, :riot_key, unique: true
    add_index :champions, :name
  end
end
