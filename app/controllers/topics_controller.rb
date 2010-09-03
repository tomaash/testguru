class TopicsController < ApplicationController
  active_scaffold :topic do |config|
     ApplicationController.add_header(config)
     config.list.columns.exclude :created_at, :updated_at, :exams, :questions, :questionsets
     config.create.columns.exclude :created_at, :updated_at, :exams, :questions, :questionsets
     config.update.columns.exclude :created_at, :updated_at, :exams, :questions, :questionsets
   end
end
