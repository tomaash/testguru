class AddTemplateToExams < ActiveRecord::Migration
  def self.up
    add_column :exams, :template_id, :integer
    # add_column :exams, :master, :integer
  end

  def self.down
    remove_column :exams, :template_id
    # remove_column :exams, :master
  end

end
