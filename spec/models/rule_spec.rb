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

require 'spec_helper'

describe Rule do
  pending "add some examples to (or delete) #{__FILE__}"
end
