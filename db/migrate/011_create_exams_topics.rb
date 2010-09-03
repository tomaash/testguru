class CreateExamsTopics < ActiveRecord::Migration
  def self.up
    create_table :exams_topics, :id => false do |t|
      t.integer :exam_id
      t.integer :topic_id
    end
  end

  def self.down
    drop_table :exams_topics
  end
end
