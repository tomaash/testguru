class ExamsController < ApplicationController
  
  DEFAULT_HEADING = "Písemný test"
  DEFAULT_VERSION = "Skupina A"
  DEFAULT_SIGNATURE = "Jméno (číslo skupiny):"
  DEFAULT_DESCRIPTION = ""
  
  before_filter :require_user
  prawnto :prawn => { :page_size => 'A4' }
  
  active_scaffold :exam do |config|
    config.list.columns.exclude :created_at, :updated_at
    config.list.columns = [:name, :questions, :points ]
    
    config.update.columns = [:name, :questions, 
                             :heading_text, :version_text, :signature_text, :description_text]
    config.create.columns = [:name, :template, :heading_text, :version_text, :signature_text, :description_text, :questions]
    
    config.action_links.add 'export', :action => 'export', :label => 'Export PDF', :type => :record, :popup => true, :parameters => {:format => 'pdf'}
    config.action_links.add 'solution', :action => 'solution', :label => 'Solution PDF', :type => :record, :popup => true, :parameters => {:format => 'pdf'}
    config.action_links.add 'solution_list', :action => 'solution_list', :label => 'Solution List', :type => :record, :popup => true
    
    ApplicationController.add_header(config)
    
    config.columns[:template].form_ui = :select
  end


  def export
    @exam = Exam.find(params[:id])
    redirect_to :action => :nice_export, :id => @exam.name, :format => 'pdf'
  end
  
  def nice_export
    @exam = Exam.find_by_name(params[:id])
    render :action => :export
  end

  def solution
    @exam = Exam.find(params[:id])
  end

  def solution_list
    @exam = Exam.find(params[:id])
  end

  def before_create_save(record)
    record.heading_text ||=  DEFAULT_HEADING
    record.description_text ||= DEFAULT_DESCRIPTION
    record.signature_text ||= DEFAULT_SIGNATURE
    record.version_text ||= DEFAULT_VERSION    
    if record.template
      record.template.questionsets.each do |qset|
        pool = Question.find_all_by_points_and_topic_id(qset.points,qset.topic_id)
        record.questions << pool.sort_by{rand(1000)}[0..(qset.count-1)]
      end
    end
  end
end
