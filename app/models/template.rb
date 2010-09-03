class Template < ActiveRecord::Base
  has_and_belongs_to_many :questionsets
  validates_presence_of :name
end
