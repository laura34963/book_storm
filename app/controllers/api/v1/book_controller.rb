class Api::V1::BookController < Api::ApplicationController
  before_action :set_user, only: [:purchase]
  before_action :set_book, only: [:show, :update, :destroy, :purchase]
  before_action :set_store, only: [:index, :create, :purchase]
  before_action :check_purchase, only: [:purchase]

  def index
    success_response(@store.books.as_json)
  end

  def show
    success_response(@book.as_json)
  end

  def create
    if book = Book.create(book_params)
      success_response(book.as_json)
    else
      error_response(:create_book_failed)
    end
  end

  def update
    if @book.update(book_params)
      success_response(@book.as_json)
    else
      error_response(:update_book_failed)
    end
  end

  def destroy
    if @book.destroy
      success_response(:ok)
    else
      error_response(:delete_book_failed)
    end
  end

  def purchase
    @user.purchase(@store, @book, @book_num)
    success_response(remain_balance: @user.balance)
  rescue => e
    error_response(:purchase_failed)
  end

  def search_price
    order_type = params[:sort_type] == 'price' ? :expensive : :alphabetical
    infos = Book.price_between(params[:min_price], params[:max_price]).send(order_type).as_json

    success_response(infos)
  end

  def search
    book_names = Book.most_relevant(params[:keyword].split(' '))

    success_response(books: book_names)
  end

  private

  def book_params
    params.permit(:store_id, :name, :price)
  end

  def check_purchase
    @book_num = params[:book_num]&.to_i || 1
    error_response(:not_enough_balance) if @user.balance < (@book.price * @book_num)
  end

end
