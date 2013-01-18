class Project < ActiveRecord::Base
  has_many :tickets
  attr_accessible :description, :name
  validates :name, :presence => true
end
