require 'net/http'
require 'JSON'

class ItAuth
	@@base_url = "https://chalmers.it/auth/userInfo.php"

	%w[cid dn firstname lastname mail nick uidnumber groups].each do |name|
		define_method name do
			@data[name]
		end
	end

	def initialize(token)
		uri = URI.parse(@@base_url)
		uri.query = "token=#{token}"
		json = Net::HTTP.get(uri)
		@data = (json[0] == "{" && JSON.parse(json)) || nil
	end
end