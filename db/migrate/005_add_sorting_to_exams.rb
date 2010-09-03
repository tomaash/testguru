class AddSortingToExams < ActiveRecord::Migration
  def self.up
    add_column :exams, :sorting, :string
    # add_column :exams, :master, :integer
  end

  def self.down
    remove_column :exams, :sorting
    # remove_column :exams, :master
  end
end
