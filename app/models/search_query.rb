class SearchQuery < ActiveRecord::Base
  validates :title, presence: true
  validates :author, presence: true
  validates :pub_year, presence: true
end
