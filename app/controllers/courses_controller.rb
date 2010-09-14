class CoursesController < ApplicationController
  active_scaffold :course do |config|
     ApplicationController.add_header(config)
     config.list.columns.exclude :created_at, :updated_at
     config.create.columns.exclude :created_at, :updated_at
     config.update.columns.exclude :created_at, :updated_at
     config.columns[:topics].form_ui = :select
   end
end
