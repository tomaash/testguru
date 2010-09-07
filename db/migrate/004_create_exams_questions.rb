class CreateExamsQuestions < ActiveRecord::Migration
  def self.up
    create_table :exams_questions, :id => false do |t|
      t.integer :exam_id
      t.integer :question_id
      t.timestamps
    end
  end

  def self.down
    drop_table :exams_questions
  end
end
