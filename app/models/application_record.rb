class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def filter_type_to_operator(filter_type)
      filter_type == 'more' ? '>=' : '<'
    end
  
    private
    
    def format_relevant_select_text(col_name, search_terms)
      select_query = search_terms.map do |term|
        "(length(#{col_name}) - length(regexp_replace(#{col_name}, '#{term}', 'g'))) / length('#{term}') as #{term}_count"
      end.join(', ')
      "select #{col_name}, #{select_query}"
    end

    def format_total_text(search_terms)
      total_text = search_terms.map do |term|
        "#{term}_count"
      end.join('+')
      "(#{total_text}) as total"
    end
  end
  
end
