class AddTopicAndOwner < ActiveRecord::Migration
  def self.up
    add_column :questions, :topic_id, :integer
    add_column :questions, :user_id, :integer
    add_column :exams, :easy_questions_setup, :integer
    add_column :exams, :hard_questions_setup, :integer
    add_column :exams, :user_id, :integer
    add_column :exams, :heading_text, :text
    add_column :exams, :version_text, :string
    add_column :exams, :signature_text, :text
    add_column :exams, :description_text, :text
  end

  def self.down
    remove_column :questions, :topic_id
    remove_column :questions, :user_id
    remove_column :exams, :easy_questions_count
    remove_column :exams, :hard_questions_count
    remove_column :exams, :user_id
    remove_column :exams, :heading_text
    remove_column :exams, :version_text
    remove_column :exams, :signature_text
    remove_column :exams, :description_text
  end
end
