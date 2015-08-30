class AddLoggedInToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :logged_in, :boolean
  end
end
