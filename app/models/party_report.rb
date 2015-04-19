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
  scope :waiting, -> { where('accepted IS NULL') }
  scope :accepted, -> { where('accepted = ?', true) }
  scope :not_denied, -> { where('accepted IS NULL or accepted = ?', true) }
  scope :sent, -> { with_deleted.where('sent = ?', true) }
  scope :unsent, -> { where('sent IS NULL OR sent = ?', false) }

  belongs_to :booking

  delegate :title, :group, to: :booking

  acts_as_paranoid

  validates :party_responsible_name, presence: true
  validates :party_responsible_phone, presence: true, length: { minimum: 6 }
  validates_inclusion_of :liquor_license, :in => [true, false]


  before_save :remove_dates

  def submit_begin_date
    self.begin_date || booking.begin_date
  end

  def submit_end_date
    self.end_date || booking.end_date
  end

  def accept!
    self.accepted = true
    save!
  end

  def reject!
    self.accepted = false
    save!
  end

  def accepted?
    self.accepted == true
  end

  def rejected?
    self.accepted == false
  end

  private

    def remove_dates
      if booking.begin_date == self.begin_date
        self.begin_date = nil
      end
      if booking.end_date == self.end_date
        self.end_date = nil
      end
    end
end
