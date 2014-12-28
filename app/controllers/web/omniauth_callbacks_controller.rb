class Web::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]
    authentication = Authentication.from_omniauth(auth)
    @current_user = authentication.user || User.create(auth.slice(:email, :first_name, :last_name, :gender), authentications: [authentication])
    
    if @current_user.persisted?
      sign_in_and_redirect @current_user 
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end