require 'net/http'

class User

	attr_accessor :nick, :firstname, :lastname, :mail, :cid, :groups

	def initialize(token)
		res = Net::HTTP.get_response(URI.parse(user_path token))
		user = JSON.parse res.body

		@nick = user['nick']
		@firstname = user['firstname']
		@lastname = user['lastname']
		@mail = user['mail']
		@cid = user['cid']
		@groups = user['groups']
	end

private
	def user_path token
		"https://chalmers.it/auth/userInfo.php?token=#{token}"
	end
end