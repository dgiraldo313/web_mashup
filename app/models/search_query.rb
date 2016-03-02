class SearchQuery < ActiveRecord::Base
  validates :title, presence: true
  validates :author, presence: true
  validates :end_pub_year, presence: true
end
