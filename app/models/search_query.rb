require 'active_model'

class SearchQuery
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :title, :author, :pub_year


end
