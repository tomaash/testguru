class AddCourseIdToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :course_id, :integer
  end

  def self.down
    remove_column :topics, :course_id
  end
end
