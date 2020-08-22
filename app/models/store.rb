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
      select_text = format_relevant_select_text('name', search_terms)
      total_text = format_total_text(search_terms)
      stores = ActiveRecord::Base.connection.execute("select name, #{total_text} from (#{select_text} from stores) as count_table order by total desc")
      stores.pluck(:name)
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
      store_ids = BusinessHour.where("open_hour #{operator} #{hour}").pluck(:store_id).uniq
      Store.where(id: store_ids)
    end

    def list_open_hour_per_week(filter_type, hour)
      operator = filter_type_to_operator(filter_type)
      store_ids = BusinessHour.select(:store_id, 'sum(open_hour)').group(:store_id).having("sum(open_hour) #{operator} #{hour}").pluck(:store_id).uniq
      Store.where(id: store_ids)
    end

    def list_book_count(filter_type, book_count, min_price=nil, max_price=nil)
      books = min_price.present? && max_price.present? ? Book.price_between(min_price, max_price) : Book
      store_ids = books.store_ownen_count_match(filter_type, book_count)
      Store.where(id: store_ids).sort_by{|store| store_ids.index(store.id)}
    end
    
  end

  def display_info
    info = as_json
    info[:business_hours] = business_hours.map(&:display_info)
    info
  end

  private
  
  def format_relevant_select_text(col_name, search_terms)
    select_query = search_terms.map do |term|
      "(length(#{col_name}) - length(regexp_replace(#{col_name}, '#{term}', 'g'))) / length(#{term}) as #{term}_count"
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
