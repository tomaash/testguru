class AddCodeToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :code, :string
  end

  def self.down
    remove_column :courses, :code
  end
end
