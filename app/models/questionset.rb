class Questionset < ActiveRecord::Base
  has_and_belongs_to_many :templates
  belongs_to :topic
  validates_presence_of :topic
  def to_label
    "#{self.topic && self.topic.name} - #{self.points}b - #{self.count}x"
  end
end
