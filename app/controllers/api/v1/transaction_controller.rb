class Api::V1::TransactionController < Api::ApplicationController
  before_action :check_filter_type, only: [:user_count_by_cost]
  before_action :format_date_range

  def user_count_by_cost
    count = PurchaseHistory.purchase_within(@date_range).user_ids_by_cost(params.require(:filter_type), params.require(:price)).count
    
    success_response(count)
  end
  
  def sales_situation
    sales_num = PurchaseHistory.purchase_within(@date_range).count
    total_amount = PurchaseHistory.purchase_within(@date_range).sum(:amount)
  
    success_response(sales_num: sales_num, total_amount: total_amount)
  end
  
end
