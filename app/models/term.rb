# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text(65535)
#  active     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Term < ActiveRecord::Base
	scope :active, -> { where(active: true) }
end
