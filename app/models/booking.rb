# == Schema Information
#
# Table name: bookings
#
#  id                      :integer          not null, primary key
#  cid                     :string(255)
#  begin_date              :datetime
#  end_date                :datetime
#  group                   :string(255)
#  description             :text
#  party_responsible       :string(255)
#  party_responsible_phone :string(255)
#  room_id                 :integer
#  created_at              :datetime
#  updated_at              :datetime
#  title                   :string(255)
#  party                   :boolean
#  phone                   :string(255)
#

class Booking < ActiveRecord::Base
  scope :future, -> { where('end_date >= ?', DateTime.now) }
  scope :within, -> (time = 1.month.from_now) { where('begin_date <= ?', time) }

  belongs_to :room

  validates :title, :cid, :description, :room, :begin_date, :end_date, :phone, presence: true
  validates_inclusion_of :party, :in => [true, false]
  # validate :must_be_whitelisted
  validate :must_not_exceed_max_duration
  validate :must_not_collide
  validate :must_have_responsible_if_party
  validate :must_be_party_room_if_party
  validate :must_be_group_in_room

  validates_datetime :begin_date, after: -> { DateTime.now.beginning_of_day }
  validates_datetime :end_date, after: :begin_date


private

  def must_have_responsible_if_party
    if party
      errors.add(:party_responsible, 'Bokning måste ha festansvarig') if party_responsible.empty?
      errors.add(:party_responsible_phone, 'Festansvarigs telefonnummer måste anges') if party_responsible_phone.empty?
    end
  end

  def must_be_party_room_if_party
    if party
      errors.add(:room, 'Festbokning ej tillåten i detta rum') unless room.allow_party
    end
  end

  def must_be_group_in_room
    if group.nil? || group.empty?
      errors.add(:room, 'Du kan ej boka detta rum som privatperson') if room.only_group
    end
  end

  def must_not_collide
    Booking.future.each do |b|
      unless b == self
        # Algorithm source: http://makandracards.com/makandra/984-test-if-two-date-ranges-overlap-in-ruby-or-rails
        if (begin_date - b.end_date) * (b.begin_date - end_date) >= 0
          errors.add(:begin_date, 'Din bokning kolliderar med annan bokning.')
          return
        end
      end
    end
  end

  def must_be_whitelisted
    whitelisted = false
    puts 'range:', begin_date..end_date
  	WhitelistItem.active.each do |item|
  		range = item.range(begin_date)
      if range.cover?(begin_date) && range.cover?(end_date)
        whitelisted = true
        break
      end
    end
    unless whitelisted
     errors.add :begin_date, "ligger inte inom whitelistad period"
    end
  end

  def must_not_exceed_max_duration
    unless begin_date.nil? || end_date.nil?
      days = (end_date - begin_date).to_i / 1.day
      errors.add(:end_date, "Bokningen får ej vara längre än en vecka, (är #{days} dagar)") if days > 7
    end
  end
end
