class User
	include HTTParty

	base_uri "https://chalmers.it/auth/userInfo.php"

	@@ADMIN_GROUPS = [:digit, :styrit, :prit]
	@@FILTER = [:digit, :styrit, :prit, :nollkit, :sexit, :fanbarerit, :'8bit', :drawit, :armit, :hookit]

	attr_accessor :cid, :firstname, :lastname, :nick, :mail, :groups

	def initialize(cid, firstname, lastname, nick, mail, groups)
		self.cid = cid
		self.firstname = firstname
		self.lastname = lastname
		self.nick = nick
		self.mail = mail
		self.groups = groups & @@FILTER
	end

	def admin?
		!(groups & @@ADMIN_GROUPS).empty?
	end

	def self.find(token)
		resp = get("?token=#{token}")
		if resp.success?
			groups = resp['groups'].uniq.map { |g| g.downcase.to_sym }
			self.new(resp['cid'], resp['firstname'], resp['lastname'],
				resp['nick'], resp['mail'], groups)
		else
			raise resp.response.inspect
		end
	end
end
