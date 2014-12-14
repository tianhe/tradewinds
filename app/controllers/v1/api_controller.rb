class V1::ApiController < ApplicationController
  before_filter :authenticate_user_from_token!

  def authenticate_user_from_token!
    @user = User.find_by(email: params[:email])
    unless @user && Devise.secure_compare(@user.authentication_token, params[:authentication_token])
      render_401(['unauthorized access']) and return
    end
  end

  def render_200
    render json: {status: 200}, status: 200
  end

  def render_400 error=''
    @error = error
    @status = 400
    render 'v1/error', status: @status
  end  

  def render_401 error=''
    @error = error
    @status = 401
    render 'v1/error', status: @status
  end  
end