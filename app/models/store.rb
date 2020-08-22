class Store < ApplicationRecord
  has_many :books
  has_many :purchase_histories
  has_many :business_hours

  class << self

    def open_at(weektime)
      large_weektime = weektime + BusinessHour::LARGE_TIME_INT
      joins(:business_hours).where('(business_hours.opentime < ? and business_hours.closetime >= ?) or (business_hours.opentime < ? and business_hours.closetime >= ?)', weektime, weektime, large_weektime, large_weektime)
    end

    def most_relevant(search_terms)
      
    end

    def most_transation
      sort_store_ids = PurchaseHistory.select(:store_id, 'count(*)').group(:store_id).order('count(*) desc').pluck(:store_id)
      Store.where(id: sort_store_ids).sort_by{|store| sort_store_ids.index(store.id)}
    end

    def most_earning
      sort_store_ids = PurchaseHistory.select(:store_id, 'sum(amount)').group(:store_id).order('sum(amount) desc').pluck(:store_id)
      Store.where(id: sort_store_ids).sort_by{|store| sort_store_ids.index(store.id)}
    end

    def list_open_hour_per_day(filter_type, hour)
      operator = filter_type_to_operator(filter_type)
    end

    def list_open_hour_per_week(filter_type, hour)
      operator = filter_type_to_operator(filter_type)
    end

    def list_book_count(filter_type, book_count)
      store_ids = Book.store_ownen_count_match(filter_type, book_count)
      Store.where(id: store_ids)
    end
    
  end

  def display_info
    info = as_json
    info[:business_hours] = business_hours.map(&:display_info)
    info
  end

  private
  
  def format_relevant_sql(col_name, search_terms)
    
  end
  
end
