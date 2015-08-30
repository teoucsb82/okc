class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end
