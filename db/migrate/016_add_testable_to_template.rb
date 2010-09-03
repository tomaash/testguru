class AddTestableToTemplate < ActiveRecord::Migration
  def self.up
    add_column :templates, :testable, :boolean
  end

  def self.down
    remove_column :templates, :testable
  end
end
