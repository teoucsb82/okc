class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :username, null: false
      t.text :data
      t.boolean :visited, default: false
      t.boolean :liked, default: false
      t.boolean :bookmarked, default: false
      t.boolean :messaged, default: false
      t.integer :profile_id, null: false

      t.timestamps null: false
    end
    add_index :leads, :username, unique: true
  end
end
