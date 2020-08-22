class Api::V1::StoreController < Api::ApplicationController

  def popular_rank
    
  end

  def search
    
  end

  def search_open
    weektime = Time.parse(params[:weektime]).strftime('%w%H%M').to_i
    store_infos = Store.open_at(weektime).includes(:business_hours).map(&:display_info)
    success_response(store_infos)
  end
  
  def search_hour
    
  end

  def search_book_count
    
  end
  
end
