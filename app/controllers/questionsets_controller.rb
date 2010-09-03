class QuestionsetsController < ApplicationController
  before_filter :require_user
  active_scaffold :questionset do |config|
    ApplicationController.add_header(config)
    config.create.columns.exclude :templates
    config.list.columns.exclude :created_at, :updated_at
  end
end
