class CreateQuestionsetsTemplates < ActiveRecord::Migration
  def self.up
    create_table :questionsets_templates, :id => false do |t|
      t.integer :questionset_id
      t.integer :template_id
    end
  end

  def self.down
    drop_table :questionsets_templates
  end
end