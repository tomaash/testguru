class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :code
      t.text :value
      t.boolean :multiple
      t.integer :points

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
