class Api::V1::StoreController < Api::ApplicationController

  def popular_rank
    if params[:popular_type] == 'earning'
      stores = Store.most_earning
    else
      stores = Store.most_transation
    end

    success_response(stores: stores.pluck(:name))
  end

  def search
    store_names = Store.most_relevant(params[:keyword].split(' '))

    success_response(stores: store_names)
  end

  def search_open
    weektime = Time.parse(params[:weektime]).strftime('%w%H%M').to_i
    stores = Store.open_at(weektime).includes(:business_hours)
    success_response(stores.map(&:display_info))
  end
  
  def search_hour
    if params[:interval] == 'day'
      stores = Store.list_open_hour_per_day(params[:filter_type], params[:hour])
    else
      stores = Store.list_open_hour_per_week(params[:filter_type], params[:hour])
    end
    success_response(stores.pluck(:name))
  end

  def search_book_count
    stores = Store.list_book_count(params[:filter_type], params[:book_count], params[:min_price], params[:max_price])

    success_response(stores.pluck(:name))
  end
  
end
