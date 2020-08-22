class PurchaseHistory < ApplicationRecord
  belongs_to :store
  belongs_to :book
  belongs_to :user

  class << self

    def purchase_within(daterange)
      where(date: daterange)
    end

    def user_ids_by_cost(filter_type, price)
      operator = filter_type == 'more' ? '>=' : '<'
      self.select(:user_id, 'sum(amount) as total_amount').group(:user_id).having("sum(amount) #{operator} #{price}").pluck(:user_id)
    end

  end
end
