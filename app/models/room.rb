# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  festrum    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Room < ActiveRecord::Base
	has_many :bookings
end
