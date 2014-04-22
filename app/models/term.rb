class Term < ActiveRecord::Base
	scope :active, where(active: true)
end
