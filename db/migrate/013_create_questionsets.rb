class CreateQuestionsets < ActiveRecord::Migration
  def self.up
    create_table :questionsets do |t|
      t.integer :topic_id
      t.integer :points
      t.integer :count
      t.timestamps
    end
  end

  def self.down
    drop_table :questionsets
  end
end
