class Answer < ActiveRecord::Base
  belongs_to :question
  validates_presence_of :value, :choice
  def to_label
    value
  end
end
