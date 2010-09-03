class AnswersController < ApplicationController
  before_filter :require_user
  active_scaffold :answer do |config|
    config.list.columns.exclude :created_at, :updated_at
    config.list.columns = [:choice, :value, :correct, :question, :question_code]
    config.update.columns = [:choice, :value, :correct]  
    config.create.columns = [:choice, :value, :correct, :question]  
    config.show.columns = [:choice, :value, :correct, :question, :question_code]  
    ApplicationController.add_header(config)
  end
end
