class V1::UsersController < V1::ApiController    
  before_filter :find_record, only: [:show, :update]
  skip_before_filter :authenticate_user_from_token!, only: :create
  before_filter :preprocess_params, only: [:create, :update]

  def show
  end

  def update
    @success = @user.update(user_params)
    @success ? render_200 : render_400(['save failed']) 
  end

private

  def preprocess_params
    params[:user][:gender].downcase! if params[:user][:gender]
    params[:user][:drinking_habit].downcase! if params[:user][:drinking_habit]
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :gender, :birthdate, :drinking_habit)
  end

  def find_record
    begin 
      @user = User.find(params[:id])
    rescue
      render_400(['record not found'])
    end
  end
end
