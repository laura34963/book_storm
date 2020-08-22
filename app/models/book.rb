class Book < ApplicationRecord

  scope :expensive, -> {order(price: :desc)}
  scope :alphabetical, -> {order(:name)}

  class << self

    def price_between(min_price, max_price)
      
    end

  end

end
