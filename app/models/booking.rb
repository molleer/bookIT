# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  cid          :string(255)
#  begin_date   :datetime
#  end_date     :datetime
#  group        :string(255)
#  description  :text
#  festansvarig :string(255)
#  festnumber   :string(255)
#  room_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  title        :string(255)
#

class Booking < ActiveRecord::Base
  scope :future, -> { where('end_date >= ?', DateTime.now) }
  belongs_to :room

  validates :title, :cid, :group, :description, :room, :begin_date, :end_date, presence: true
  validate :must_be_whitelisted
  validate :must_not_exceed_max_duration
  validate :must_not_collide

  validates_datetime :begin_date, after: -> { Time.zone.now }, before: :end_date
  validates_datetime :end_date, after: -> { Time.zone.now }


  def fest
    !(festansvarig.nil? && festnumber.nil?)
  end

  def fest=(fest)
    unless fest
      self.festansvarig = nil
      self.festnumber = nil
    end
  end


private

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
  	WhitelistItem.active.each do |item|
  		range = item.range

      if range.cover?(begin_date) and range.cover?(end_date)
        whitelisted = true
        break
      end
    end
    unless whitelisted
     errors.add :begin_date, "ligger inte inom whitelistad period"
     errors.add :end_date, "ligger inte inom whitelistad period"
    end
  end

  def must_not_exceed_max_duration
    unless begin_date.nil? || end_date.nil?
      days = (end_date - begin_date).to_i / 1.day
      errors.add(:end_date, "Bokningen får ej vara längre än en vecka, (är #{days} dagar)") if days > 7
    end
  end
end
