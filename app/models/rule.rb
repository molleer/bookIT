# == Schema Information
#
# Table name: rules
#
#  id         :integer          not null, primary key
#  day_mask   :integer
#  start_date :datetime
#  stop_date  :datetime
#  start_time :time
#  stop_time  :time
#  allow      :boolean
#  prio       :integer
#  reason     :text
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  room_id    :integer
#

class Rule < ActiveRecord::Base
  scope :in_room, -> (room) { where(rooms: room) }
  scope :in_range, -> (start, stop) {
  	where('start_date <= ? AND stop_date >= ?', start, stop )
  }

  has_and_belongs_to_many :rooms

  validates :day_mask, :start_date, :stop_date, :prio, :reason, :title, presence: true
  validates_inclusion_of :allow, :in => [true, false]

  # Validates non-negative priority
  validates :prio, :numericality => { greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: 20 }


  def days_array=(hash)
    string = hash.values.join
    self.day_mask = string.to_i 2
  end

  def days_array
    day_mask_array = day_mask.to_s(2).rjust(7, '0').split('')
    (0..6).zip(day_mask_array).to_h
  end

  def applies?(day)
  	day -= 1
  	day = 6 if day == -1 #Fucking US

  	day = 2**(6-day) #Converting day to bitmask form 64 -> monday, 1 -> sunday

  	return (day_mask & day) > 0

  end

end
