require 'net/http'
require 'JSON'

class ItAuth
	@@base_url = "https://chalmers.it/auth/userInfo.php"

	%w[cid dn firstname lastname mail nick uidnumber].each do |name|
		define_method name do
			@data[name] unless @data.nil?
		end
	end

	def groups
		return @data && @data['groups'] || Array.new
	end

	def initialize(token)
		unless token.nil?
			uri = URI.parse(@@base_url)
			uri.query = "token=#{token}"
			json = Net::HTTP.get(uri)
			@data = (json[0] == "{" && JSON.parse(json)) || Hash.new
		end
	end
end
