require 'csv'
require 'zip/zip'

DEFAULT_POINTS = 3

class ImportController < ApplicationController
  before_filter :require_user
  layout "application"

  def index
  end

  def result
    @imported_questions=[]
    @replaced_questions=[]
    file = params[:import][:uploaded_data]
    error = false
    parse_data(file) do |data|
      begin
        setup_course_and_topic
        validate_data(data.dup)
        load_data(data)
      rescue
        error = $!.to_s
      end
    end
    if error
      flash[:notice] = error
      redirect_to :action => :index
    end
  end

  private

  def parse_data(file)
    if file
      @filename, @extension = file.original_filename.split('.')
    else
      raise "No file uploaded"
    end
    #loads data in yaml format, if csv is provided, changes it to yaml
    case @extension.downcase
    when 'yaml' then
      yield YAML.load(file) #YAML.load(File.new('import.yaml','r').read)
    when 'csv' then yield csv2yaml(file)
    when 'zip' then unpack_zip(file) do |i|
        parse_data(i) {|x| yield x}
      end
    end
  end

  def unpack_zip(file)
    #function parse_data expects rails "magicked" tempfile (includes method
    #original_filename)
    #open zip file
    Zip::ZipInputStream::open(file.path) do |io|
      #iterate over contents of zip file
      while (entry = io.get_next_entry)
        filename = entry.name
        #pack every content into a tempfile
        temp = Tempfile.new(entry.name)
        a = File.open(temp.path, 'w')
        a.write(io.read)
        a.close
        #and add original_filename method to it
        temp.instance_variable_set(:@original_filename, entry.name)
        def temp.original_filename
          return @original_filename
        end
        yield temp
      end
    end
  end

  # def setup_course_and_topic
  #     if not params[:import][:course].blank?
  #      course_name = params[:import][:course].upcase
  #      @course = Course.find(course_name)
  #    elsif not params[:import][:course_new_code].blank?
  #      new_course_code = params[:import][:course_new_code].upcase
  #      new_course_name = params[:import][:course_new_name]
  #      if Course.find_by_code(new_course_code)
  #        raise "Course with this code already exists"
  #      end
  #      @course = Course.create({:code =>new_course_code, :name => new_course_name})
  #    else
  #      raise "Please specify course"
  #    end
  #    topic_name = @course.code+"-"+@filename.upcase
  #    @topic = Topic.find_by_name(topic_name) || Topic.create(:name => topic_name, :course => @course)
  #  end
 
  def setup_course_and_topic
     course_code = @filename[0,3].upcase
     topic_name = @filename[4,255]
     @course = Course.find_by_code(course_code)
     raise "Course #{course_code} does not exist" if not @course
    topic_name_course = @course.code+"-"+topic_name
    @topic = Topic.find_by_name(topic_name_course) || Topic.create(:name => topic_name_course, :course => @course)
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
      # Relax, default points
      # raise "Question points must be > 0"+error_string if points < 1
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
    while true
      question_data = data.shift.to_s
      answers = data.shift
      break if not answers
      points = 0
      code, points, question = parse_question(question_data)
      points = DEFAULT_POINTS if points < 1
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
        points = row[2].to_i
        points = DEFAULT_POINTS if points < 1
        output << "#{row[0]}. (#{points}) #{row[1]}"
        answers = []
      else
        if row[2] =~ /[A-Z]/
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
