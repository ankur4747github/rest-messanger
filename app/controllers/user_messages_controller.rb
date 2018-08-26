class UserMessagesController < ApplicationController
	

	def index
		if params_signin[:session_id].present?
			session = Session.find_by_session_id(params_signin[:session_id])
			if session
				messages = session.user.messages.all
				render json:{messages: messages},status: :ok
			else
				render json:{message: 'Invalid Session Id'},status: :ok	
			end
		else
			render json:{message: 'Session Id is not available'},status: :ok
		end
	end

	def new
		if params_new[:session_id].present? && params_new[:message].present?
			session = Session.find_by_session_id(params_new[:session_id])
			if session
				message = session.user.messages.new
				message.message = params_new[:message]
				if message.save
					#binding.pry
					#App.room.speak(params_new[:message])
					ActionCable.server.broadcast 'room_channel', message: params_new[:message]
					render json:{message: message},status: :ok	
				else
					render json:{message: 'Invalid Data'},status: :ok	
				end		
			else
				render json:{message: 'Session Id is not available'},status: :ok	
			end
		else
			render json:{message: 'Empty text'},status: :ok if params_new[:message].blank?
		end
	end

	def edit

	end

	private 

	def params_signin
		params.permit(:session_id)
	end

	def params_new
		params.permit(:session_id, :message)
	end

end
