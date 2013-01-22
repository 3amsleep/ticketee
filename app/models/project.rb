class Project < ActiveRecord::Base
  has_many :tickets, :dependent => :delete_all
  attr_accessible :description, :name
  validates :name, :presence => true
end
