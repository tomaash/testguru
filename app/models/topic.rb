class Topic < ActiveRecord::Base
  has_and_belongs_to_many :exams
  has_many :questions, :dependent  => :destroy
  has_many :questionsets
  validates_presence_of :name
end
