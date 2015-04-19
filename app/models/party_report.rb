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

class PartyReport < ActiveRecord::Base
  belongs_to :booking

  acts_as_paranoid

  validates :party_responsible_name, presence: true
  validates :party_responsible_phone, presence: true, length: { minimum: 6 }
  validates_inclusion_of :liquor_license, :in => [true, false]

end
