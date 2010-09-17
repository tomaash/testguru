require 'csv'
class ImportController < ApplicationController
  before_filter :require_user
  layout "application"

  def index
  end

  def result
    begin
      error = false
      data = parse_data
      setup_course_and_topic
      validate_data(data.dup)
      load_data(data)
    rescue
      error = $!.to_s
    end
    if error
      flash[:notice] = error
      redirect_to :action => :index
    end
  end

  private

  def parse_data
    file = params[:import][:uploaded_data]
    if file
      @filename, @extension = file.original_filename.split('.')
    else
      raise "No file uploaded"
    end
    #loads data in yaml format, if csv is provided, changes it to yaml
    data = case @extension.downcase
    when 'yaml' then
      YAML.load(file) #YAML.load(File.new('import.yaml','r').read)
    when 'csv' then csv2yaml(file)
    end
    return data
  end

  def setup_course_and_topic
    if not params[:import][:course].blank?
      @course = Course.find(params[:import][:course])
    elsif not params[:import][:course_new].blank?
      if Course.find_by_name(params[:import][:course_new])
        raise "Course with this name already exists"
      end
      @course = Course.create({:name =>params[:import][:course_new]})
    else
      raise "Please specify course"
    end
    topic_name = @course.name+"-"+@filename
    if existing_topic = Topic.find_by_name(topic_name)
      @topic = existing_topic
    else
      @topic = Topic.create(:name => topic_name)
    end
    @topic.course = @course
    @topic.save
  end

  def parse_question(question_data)
    slice_question = question_data.split(/[.()]/)
    code = slice_question[0].strip
    points = slice_question[2].strip
    question = question_data.strip.sub(/^.*\.\s*\(\d+\)\s*/,"")
    return code.strip, points.to_i, question.strip
  end

  def validate_data(data_test)
    cnt = 0
    while true
      cnt += 1
      question_data = data_test.shift.to_s
      answers = data_test.shift
      error_string = "<br>Question no. #{cnt}<br>Question data: #{question_data}"
      if question_data and answers and (question_data.class != String or answers.class != Array)
        raise "Data series mismatch - strings (question) and array (answers) must be interlaced evenly!"+error_string
      end
      if !answers and question_data and !question_data.empty?
        raise "Data series mismatch - question without answers"+error_string
      end
      break if not answers
      answer_classes = answers.map{|x| x.class}.uniq
      if answer_classes.include?(Array) or answer_classes.include?(Hash)
        raise "Data series mismatch - Answers must contain strings only"+error_string
      end
      code, points, question = parse_question(question_data)
      raise "Question must not be empty"+error_string if question.strip.empty?
      raise "Question points must be > 0"+error_string if points < 1
      raise "Question must have a code"+error_string if code.strip.empty?
      one_correct = false
      answers.each do |answer_data|
        correct = false
        answer = answer_data.to_s.sub(/^\s*\*\s*/) {|m| correct = (m.strip=="*");''}
        one_correct = true if correct
      end
      # RELAX - need no correct answer
      # if answers.length==1 and answers[0].strip=="***"
      #   # doplnovaci otazka
      # else
      #   raise "Question must have at least 1 correct answer"+error_string if not one_correct
      # end
    end
  end

  def load_data(data)
    @imported_questions=[]
    @replaced_questions=[]
    while true
      question_data = data.shift.to_s
      answers = data.shift
      break if not answers
      points = 0

      code, points, question = parse_question(question_data)
      full_code = @topic.name+"-"+code
      Question.transaction do
        if not q = Question.find_by_code(full_code)
          q = Question.new
          replace_flag = false
        else
          replace_flag = true
        end
        q.code = full_code
        q.value = question.strip
        q.points = points
        q.topic = @topic
        q.save!
        alphabet = ('a'..'z').to_a
        if answers.length==1 and answers[0].strip=="***"
          # nedelat nic - doplnovaci otazka
        else
          q.answers = []
          answers.each_with_index do |answer_data,i|
            a = Answer.new
            correct = false
            answer = answer_data.to_s.strip.sub(/^[ \t]*\*[ \t]*/) {|m| correct = (m.strip=="*");''}
            a.value = answer
            a.correct = correct
            a.choice = alphabet[i]
            a.save!
            q.answers << a
          end
        end
        q.save!
        if replace_flag
          @replaced_questions << q
        else
          @imported_questions << q
        end
      end
    end
  end

  def csv2yaml(file)
    output = []
    answers = []
    CSV::Reader.parse(file, ',') do |row|
      if (row[0])
        output << answers unless answers.empty?
        output << "#{row[0]}. (#{row[2]}) #{row[1]}"
        answers = []
      else
        if row[2] == 'A'
          answers << "* #{row[1]}"
        else
          answers << "#{row[1]}"
        end
      end
    end
    output << answers unless answers.empty?
    return output
  end

end
