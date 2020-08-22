class Store < ApplicationRecord
  has_many :books
  has_many :purchase_histories

  class << self

    def open_at(weektime)
      
    end

    def most_relevant(search_terms)
      
    end

    def most_transation
      
    end

    def most_earning
      
    end

    def list_open_hour_per_day(filter_type, hour)
      
    end

    def list_open_hour_per_week(filter_type, hour)
      
    end

    def list_book_count(filter_type, book_count)
      
    end
    
  end

end
