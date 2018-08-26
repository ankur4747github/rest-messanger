class User < ApplicationRecord
	has_many :messages
	has_many :sessions
end
