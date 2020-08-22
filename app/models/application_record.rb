class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def filter_type_to_operator(filter_type)
    filter_type == 'more' ? '>=' : '<'
  end
  
end
