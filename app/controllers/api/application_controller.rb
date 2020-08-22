class Api::ApplicationController < ApplicationController

  ALLOW_FILTER_TYPES = ['more', 'less'].freeze

  rescue_from Exception do |e|
    error_response(:internal_server_error, "#{e.message} (#{e.backtrace.first})")
  end

  rescue_from ActionController::ParameterMissing do |e|
    error_response(:need_more_infomation, "#{e.message} (#{e.backtrace.first})")
  end

  def success_response(data={})
    render status: 200, json: {data: data}
  end
  
  def error_respnose(error_key, error_message=nil)
    render_content = ErrorResponse.to_api(error_key, error_message)
    render render_content
  end

  private
  
  def check_filter_type
    error_response(:invlalid_filter_type) if ['more', 'less'].exclude?(params[:filter_type])
  end

  def formate_date_range
    @date_range = Time.parse(params.require(:start_date))..Time.parse(params.require(:end_date))
  end

  def set_user
    token = UserToken.find(token: params[:token])
    error_response(:token_not_found) if token.nil?
    @user = token.user
  end

  def set_book
    @book = Book.find_by_id(params[:book_id])
    error_response(:book_not_found) if @book.nil?
  end

  def set_store
    @store = Store.find_by_id(params[:store_id])
    error_response(:store_not_found) if @store.nil?
  end
  
end