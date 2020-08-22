class User < ApplicationRecord
  has_many :purchase_histories
  has_many :user_tokens
  has_many :books, through: :purchase_histories

  class << self

    def login(name, password)
      user = User.find_by_name(name)
      return unless user.present? || user.password == password
      token = user.user_tokens.create(token: SecureRandom.base64.gsub(/[+=\/]/, '')[0, 8])
      user.display_info.merge(token: token.token)
    end

    def spend_most
      
    end

    def list_cost(filter_type, price, date_range)
      operator = filter_type == 'more' ? '>=' : '<'
      user_ids = PurchaseHistory.purchase_within(date_range).user_ids_by_cost(filter_type, price)
      User.where(user_id: user_ids)
    end
    
  end

  def display_info
    as_json(except: [:password])
  end

  def purchase(store, book, book_num=1)
    ActiveRecord::Base.transaction do
      amount = book.price * book_num
      purchase_histories.create(store_id: store.id, book_id: book.id, date: Time.zone.now, amount: amount)
      decrement!(:balance, amount)
      store.increment!(:balance, amount)
    end
  end
  
end
