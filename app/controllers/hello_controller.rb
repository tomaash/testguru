class HelloController < ApplicationController
  before_filter :require_user
  def import_csv
    require 'csv'
    p Dir
    otazky = CSV.read('./lib/otazky.csv')
    odpovedi = CSV.read('./lib/odpovedi.csv')
    Question.all.each{|x| x.destroy}
    Answer.all.each{|x| x.destroy}
    for question in otazky[1..10000] do
      new_question = Question.new
      new_question.code = question[0]
      new_question.value = question[1]
      new_question.multiple = question[2] == 'PRAVDA' ? true : false
      new_question.points = question[3].to_i
      new_question.save!
    end

    for answer in odpovedi[1..10000] do
      new_answer = Answer.new
      new_answer.code = answer[0]
      new_answer.value = answer[1]
      new_answer.correct = answer[2] == 'PRAVDA' ? true : false
      new_answer.question_code = answer[3]
      new_answer.choice = answer[4]
      p new_answer.question_code
      new_answer.question = Question.find_by_code(new_answer.question_code)
      new_answer.save!
    end
  end

  def export
    Prawn::Document.generate "hello-ttf.pdf" do
      fill_color "0000ff"
      font "/Library/Fonts/Arial.ttf"
      text "ěščěščřáýěéíščřžáýěščřá+ěšíéčřážěšíáčýřž87Hello World", :at => [200,720], :size => 32
    end
    @questions = Question.all [0..2]
  end
end
