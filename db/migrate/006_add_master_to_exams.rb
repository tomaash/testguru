class AddMasterToExams < ActiveRecord::Migration
  def self.up
     add_column :exams, :master_id, :integer
  end

  def self.down
     remove_column :exams, :master_id
  end
end
