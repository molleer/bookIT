# == Schema Information
#
# Table name: party_reports
#
#  id                         :integer          not null, primary key
#  booking_id                 :integer
#  party_responsible_name     :string(255)
#  party_responsible_phone    :string(255)
#  party_responsible_mail     :string(255)
#  co_party_responsible_name  :string(255)
#  co_party_responsible_phone :string(255)
#  co_party_responsible_mail  :string(255)
#  liquor_license             :boolean
#  sent                       :boolean
#  accepted                   :boolean
#  begin_date                 :datetime
#  end_date                   :datetime
#  deleted_at                 :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

describe PartyReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
