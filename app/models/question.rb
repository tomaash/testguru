class Question < ActiveRecord::Base
  validates_presence_of :value, :points, :topic
  validates_numericality_of :points
  has_many :answers, :order => 'choice ASC', :dependent => :destroy
  has_and_belongs_to_many :exams
  belongs_to :user
  belongs_to :topic
  def to_label
    utfval = "[#{self.topic && self.topic.name}] #{self.code}. (#{self.points}b) " + self.value.mb_chars
    if utfval.size > 200
     return utfval.mb_chars[0..200]+"..."
   else
     return utfval
   end
  end
  
  def is_multiple
    numtrue = self.answers.map{|x| x.correct}.select{|x| x==true}.size
    if numtrue == 1 #and self.points <= 3
      return false
    else
      return true
    end
  end
end

