# encoding: UTF-8
require './lib/monkey_patches'

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "main"
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password  
  
  def self.add_header(config)
    config.action_links.add '<img height="10px" src="/images/active_scaffold/default/cross.png"/> Logout', :controller => 'user_sessions/destroy', :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_down.gif"/>Imports', :controller => 'import', :action => "", :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Exams', :controller => 'exams', :action => 'index', :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Questions', :controller => 'questions', :action => 'index', :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Topics', :controller => 'topics', :action => 'index', :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Templates', :controller => 'templates', :action => 'index', :page => true
    config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Courses', :controller => 'courses', :action => 'index', :page => true
    # config.action_links.add '<img src="/images/active_scaffold/default/arrow_up.gif"/>Questionsets', :controller => 'questionsets', :action => 'index', :page => true
  end
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
