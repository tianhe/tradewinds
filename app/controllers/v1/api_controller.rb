class V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :authenticate_user_from_token!

  def authenticate_user_from_token!
    unless @user = User.where(email: params[:email]).first
      render_error(401, ['unknown user']) and return
    end

    unless Devise.secure_compare(@user.authentication_token, params[:authentication_token])
      render_error(401, ['unauthorized access']) and return
    end
  end

  def render_200
    render json: {status: 200}, status: 200
  end

  def render_error status, error=''
    @error = error
    @status = status
    render 'v1/error', status: @status
  end  
end