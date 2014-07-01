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
#

class Rule < ActiveRecord::Base
  scope :in_range, -> (start, stop) { 
  	where('start_date <= ? AND stop_date >= ?', start, stop ) 
  }


  def applies?(day)
  	day -= 1
  	day = 6 if day == -1 #Fucking US

  	day = 2**(6-day) #Converting day to bitmask form 64 -> monday, 1 -> sunday

  	return (day_mask & day) > 0
  	
  end

end
