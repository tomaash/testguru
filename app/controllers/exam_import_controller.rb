class ExamImportController < ApplicationController
  before_filter :require_user
  layout "application"

  DEFAULT_HEADING = "Písemný test"
  DEFAULT_VERSION = "Skupina A"
  DEFAULT_SIGNATURE = "Jméno (číslo skupiny):"
  DEFAULT_DESCRIPTION = ""

  def index
  end

  def result
    begin
      data = YAML.load(params[:import][:uploaded_data])
      # p Dir.getwd
      # data = YAML.load(File.new('exams.yaml','r').read)
      error = false
      validate_data(data.dup)
      load_data(data)
      # rescue
      #   error = $!.to_s
    end
    if error
      flash[:notice] = error
      redirect_to :action => :index
    end
  end

  private

  def validate_data(data)
    data.each_with_index do |exam,i|
      questions = exam['questions'].split(" ")
      raise "Exam no. #{i} is empty" if questions.empty?
      questions.each_with_index do |question,j|
        existing_question = Question.find_by_code(question)
        raise "Exam no. #{i}, question no. #{j} does not exist" if not existing_question
      end
    end
  end

  def load_data(data)
    @imported_exams = []
    data.each do |exam|
      name = exam['name']
      heading = exam['heading']
      version = exam['version']
      signature = exam['signature']
      description = exam['description']
      questions = exam['questions'].split(" ")
      existing = Exam.find_by_name(name)
      if existing
        e = existing
        e.questions = []
      else
        e = Exam.new
      end
      questions.each do |question|
        existing_question = Question.find_by_code(question)
        e.questions << existing_question
      end
      e.name = name
      e.heading_text = heading || DEFAULT_HEADING
      e.description_text = description || DEFAULT_DESCRIPTION
      e.signature_text = signature || DEFAULT_SIGNATURE
      e.version_text = version || name
      e.save
      @imported_exams << e
    end
  end
end