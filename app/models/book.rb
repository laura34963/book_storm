class Book < ApplicationRecord
  belongs_to :store
  has_many :purchase_histories

  scope :expensive, -> {order(price: :desc)}
  scope :alphabetical, -> {order(:name)}

  class << self

    def price_between(min_price, max_price)
      where('price >= ? and price < ?', min_price, max_price)
    end

    def store_ownen_count_match(filter_type, book_count)
      operator = filter_type_to_operator(filter_type)
      Book.select(:store_id, 'count(*)').group(:store_id).having("count(*) #{operator} #{book_count}").pluck(:store_id)
    end

    def most_relevant(search_terms)
      select_text = format_relevant_select_text('name', search_terms)
      total_text = format_total_text(search_terms)
      books = ActiveRecord::Base.connection.execute("select name, #{total_text} from (#{select_text} from books) as count_table order by total desc").collect
      books.pluck('name')
    end
    

  end

end
