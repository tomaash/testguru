class QuizController < ApplicationController
  layout "uu"

  def test_me
    @tem = Template.find(params[:id])
    @title = @tem.name + " - Unicorn College"
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
    session[:tem] = @tem
  end

  def evaluate
    @questions = session[:questions]
    @tem = session[:tem]
    @title = @tem.name + " - Unicorn College"
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
  end
end
