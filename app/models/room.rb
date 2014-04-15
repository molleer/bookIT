# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  allow_party :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  only_group  :boolean
#

class Room < ActiveRecord::Base
	has_many :bookings

	validates :name, presence: true
	validates_inclusion_of :allow_party, :in => [true, false]
	validates_inclusion_of :only_group, :in => [true, false]
end
