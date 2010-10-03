class QuizController < ApplicationController
  layout "uu"

  def test_me
    @tem = Template.find(params[:id])
    @title = @tem.name + " - Unicorn College"
    @name = @tem.name
    if not @tem.testable
      render :text => "<h1> Sorry, this template is not open for testing </h1>"
    end
    @questions = []
    @tem.questionsets.each do |qset|
      pool = Question.find_all_by_points_and_topic_id(qset.points,qset.topic_id)
      pool = pool.reject{|x| x.answers.size < 2}
      @questions += pool.sort_by{rand(1000)}[0..(qset.count-1)]
    end
    session[:questions] = @questions
    session[:name] = @tem.name
  end

  def test_url
    @course = Course.find_by_code(params[:s])
    @amount = params[:q].to_i
    topic_names = params[:t].split(',').map{|x| @course.code+"-"+x}
    @topics = topic_names.map{|x| Topic.find_by_name(x)}
    @errors = ""
    @errors += "Cannot have less questions than 1\n" if @amount < 1
    @errors += "Course does not exist\n" if not @course
    @errors += "One or more topics does not exist\n" if params[:t].blank? or @topics.include?(nil)
    if @errors == ""
      @name = @course.name
      @title = @name + " - Unicorn College"
      from_topic = @amount/@topics.length
      additional = @amount % @topics.length
      @questions = []
      preffered_topic = rand(@topics.length)
      # rozdelit otazky rovnomerne, preferred topic je to ze kteryho se vybere pokud se na vsechny nedostava rovnomerne
      @topics.each_with_index do |topic,i|
        pool_size = from_topic
        pool_size += additional if i == preffered_topic
        if pool_size > 0
          pool = Question.find_all_by_topic_id(topic.id)
          pool = pool.reject{|x| x.answers.size < 2}
          @questions += pool.sort_by{rand(1000)}[0..(pool_size-1)]
        end
      end
      # pokud po rovnomernem vyberu neni dost otazek, tak se to doplni ze vsech bez ohledu na rovnomernost tak, aby se zadne neopakovaly
      if @questions.length < @amount
        all_questions = []
        @topics.each do |topic|
          all_questions += Question.find_all_by_topic_id(topic.id)
        end
        all_questions.each do |question|
          if @questions.length < @amount and not @questions.include?(question)
            @questions << question
          end
        end
      end
      session[:name] = @course.name
      session[:questions] = @questions
      @max_points = @questions.map{|x| x.points}.inject{|x,y| x+y}
      render :action => 'test_me'
    else
      render :action => 'error'
    end
  end

  def evaluate
    @questions = session[:questions]
    @max_points = @questions.map{|x| x.points}.inject{|x,y| x+y}
    @name = session[:name]
    @title = @name + " - Unicorn College"
    @replies = {}
    @corrections = {}
    @questions.size.times do |i|
      @replies["#{i+1}"]={}
      @corrections["#{i+1}"]={}
    end
    @replies.merge!(params[:answers] || {})
    @score = 0
    @questions.each_with_index do |question,i|
      cnt = i+1
      idx = cnt.to_s
      total = question.points
      question.answers.each do |answer|
        reaction = @replies[idx][answer.choice]
        points = (!!reaction == !!answer.correct )
        if not points
          # tohle vynuluje body pokud jsou spatne vic nez 2 odpovedi
          total = 0 if total < question.points
          total -= 2
          total = 0 if not question.is_multiple
        end
        total = 0 if total < 0
        @corrections[idx][answer.choice]=points
      end
      @score += total
      @corrections[idx]["total"]=total
    end
    @percentage = 100*@score/@max_points
  end

  def create_url
    @courses = Course.find(:all, :order => 'name').map {|c| ["#{c.code} - #{c.name}",c.id]}
  end

  def get_topics
    course = Course.find(params[:s])
    @topics  = Topic.find_all_by_course_id(course.id, :order => 'name').map {|c| [c.nice_name]}
  end

  #changes params to desired format for test_url
  def process_url
    error = false
    unless params.has_key?(:t)
      flash[:error] = 'Není vybráno žádné téma'
      error = true
    end
    if error
      redirect_to :action => 'create_url'
    else
      topics = params[:t].keys.join(',')
      redirect_to :action => 'test_url', :t => topics, :s => Course.find(params[:s]).code,
      # :authenticity_token => params[:authenticity_token], 
      :q => params[:q]
    end

  end
end
