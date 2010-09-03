class ExportController < ApplicationController
  before_filter :require_user
  layout "application"
  
  def index
  end

  def result
    @topic = Topic.find(params[:export][:topic])
    @out = []
    @topic.questions.each do |q|
      question = "#{q.code}. (#{q.points}) #{q.value}"
      @out << question
      answers = q.answers.map{|x| (x.correct ? "* ":"") + x.value} 
      @out << answers
    end
    require 'ya2yaml'
    @print = @out.ya2yaml
    render :text => @print, :content_type => 'text/yaml'
  end

end
