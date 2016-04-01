class SearchQuery < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :author
  validates_presence_of :pub_year

  def validate_fields

  end


end
