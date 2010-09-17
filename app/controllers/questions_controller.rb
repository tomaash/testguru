class QuestionsController < ApplicationController
  before_filter :require_user
  active_scaffold :question do |config|
    # In the List view, we'll combine two fields into one by hiding two "real" fields and adding one "virtual" field.
    config.list.columns.exclude :created_at, :updated_at
    config.list.columns   = [:topic, :code, :value, :points, :answers]
    config.update.columns = [:topic, :code, :value, :points, :answers]
    config.create.columns = [:topic, :code, :value, :points, :answers]
    config.show.columns   = [:topic, :code, :value, :points, :answers]
    config.columns[:topic].form_ui = :select
    ApplicationController.add_header(config)
    # config.list.columns << :first_and_last_name
    # If you want to customize the metadata on the virtual field, you need to add it to the main columns object.
    # config.columns << :first_and_last_name
    # config.columns[:first_and_last_name].label = 'Full Name'
  end

end
