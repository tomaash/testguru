class TemplatesController < ApplicationController
  before_filter :require_user
  active_scaffold :template do |config|
    config.action_links.add 'test_me', :action => 'test_me', :label => 'Test Me!', :type => :record,  :popup => true
    
    ApplicationController.add_header(config)
    config.list.columns.exclude :created_at, :updated_at, :questionsets
  end
  
  def test_me
    redirect_to :controller => 'quiz', :action => 'test_me', :id => params[:id]
  end

end
