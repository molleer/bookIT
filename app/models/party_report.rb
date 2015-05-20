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
  scope :sent, -> { with_deleted.where('sent_at IS NOT NULL') }
  scope :unsent, -> { where('sent_at IS NULL') }
  scope :within, -> (time = 1.month.from_now) { where('begin_date <= ?', time) }
  scope :in_future, -> { where('end_date >= ?', DateTime.now) }

  belongs_to :booking

  delegate :title, :group, to: :booking

  acts_as_paranoid

  validates :party_responsible_name, presence: true
  validates :party_responsible_phone, presence: true, length: { minimum: 6 }

  validate :duration_is_inside_booking

  validates_inclusion_of :liquor_license, :in => [true, false]

  before_validation :set_begin_end_date


  def sent?
    self.sent_at.present?
  end

  def has_custom_date?
    begin_date != booking.begin_date || end_date != booking.end_date
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

    def duration_is_inside_booking
      errors.add(:begin_date, :before_booking) unless begin_date >= booking.begin_date
      errors.add(:end_date, :after_booking) unless end_date <= booking.end_date
      errors.add(:end_date, :before_begin_date) unless begin_date < end_date
    end

    def set_begin_end_date
      self.begin_date ||= booking.begin_date
      self.end_date ||= booking.end_date
    end
end
