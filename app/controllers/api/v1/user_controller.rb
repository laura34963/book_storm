class Api::V1::UserController < Api::ApplicationController
  before_action :set_user, only: [:update]
  before_action :check_filter_type, only: [:search_cost]
  before_action :format_date_range, only: [:search_cost]

  def create
    if user = User.create(user_params)
      success_response(user.display_info)
    else
      error_response(:create_user_failed)
    end
  end

  def update
    if @user.update(user_params)
      success_response(@user.display_info)
    else
      error_response(:update_user_failed)
    end
  end

  def login
    info = User.login(params[:name], params[:password])

    if info.present?
      success_response(info)
    else
      error_response(:login_failed)
    end
  end

  def purchase_rank
    users = User.spend_most

    success_response(users.pluck(:name))
  end

  private

  def user_params
    params.permit(:name, :password)
  end 
  
end
