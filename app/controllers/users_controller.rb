class UsersController < ApplicationController
  active_scaffold :user do |config|
    ApplicationController.add_header(config)
  end
end
