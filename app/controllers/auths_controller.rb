class AuthsController < ApplicationController
	
	def add_user(params)
		if params[:password] == params[:confirm_password]
			user = User.new
			user.name = params[:name] if params[:name].present?
			user.email = params[:email]
			user.password = params[:password]
			if user.save
				render json:{message: 'User Created',email: params[:email]},status: :ok 
			else
				render json:{message: 'Invalid data'},status: :ok
			end
	    else
	    	render json:{message: 'Password and Confirm_password should be same'},status: :ok
	    end
	end

	def signup
		if params_signup[:email].present? && params_signup[:password].present? && params_signup[:confirm_password].present?
			add_user(params_signup)
		elsif params_signup[:email].blank?
			render json:{message: 'Email is not available'},status: :ok
		elsif params_signup[:password].blank? || params_signup[:confirm_password].blank?
			render json:{message: 'Password and Confirm_password is not available'},status: :ok
		end
	end

	def login_user(params)
		user = User.find_by_email(params[:email])
		if user.password == params[:password]
			user.sessions.destroy_all 
			session_id = Base64.encode64(DateTime.now.strftime('%Q')).strip
			user.sessions.create(:session_id => session_id)
			render json:{session_id: session_id},status: :ok
		else
			render json:{message: 'Wrong Password'}, status: :ok
		end
	end

	def login
		if params_login[:name].present? && params_login[:email].present? && params_login[:password].present?
			login_user(params_login)
		else
			render json:{message: 'Invalid Parameters'},status: :ok
		end

	end

	private
	def params_signup
		params.permit(:name, :email, :password, :confirm_password)
	end

	def params_login
		params.permit(:name, :email, :password)
	end
end
