class Exam < ActiveRecord::Base
  has_and_belongs_to_many :questions
  belongs_to :user
  belongs_to :template
  validates_presence_of :name
  
  def points
    self.questions.map{|x| x.points}.inject{|x,y| x+y}
  end

end
