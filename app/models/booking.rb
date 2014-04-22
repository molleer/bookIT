# == Schema Information
#
# Table name: bookings
#
#  id                      :integer          not null, primary key
#  user_id                 :string(255)
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
#  liquor_license          :boolean
#  accepted                :boolean
#

class Booking < ActiveRecord::Base
  scope :by_group_or_user, -> (name) { where('user_id = ? OR `group` = ?', name, name) }
  scope :future, -> { where('end_date >= ?', DateTime.now) }
  scope :within, -> (time = 1.month.from_now) { where('begin_date <= ?', time) }

  belongs_to :room
  belongs_to :user

  before_validation :format_phone # remove any non-numeric characters

  # essential validations
  validates :title, :description, :user, :room, :begin_date, :end_date, presence: true
  validates :phone, presence: true ,length: { minimum: 6 }
  validates_inclusion_of :party, :in => [true, false]

  # validations if party is selected:
  with_options if: :party do |f|
    f.validates :party_responsible_phone, presence: true, length: { minimum: 6 }
    f.validates :party_responsible, presence: true
    f.validates_inclusion_of :liquor_license, :in => [true, false]
    f.validate :must_be_party_room
  end

  # validate :must_be_whitelisted
  validate :must_not_exceed_max_duration, :must_not_collide, :must_be_group_in_room

  validates_datetime :begin_date, after: -> { DateTime.now.beginning_of_day }
  validates_datetime :end_date, after: :begin_date

  def group_sym
    group.to_sym
  end

  def booking_range
    ary = [begin_date.strftime('%d %b %R')]
    if same_day?(begin_date, end_date)
      ary << end_date.strftime('%R')
    else
      ary << end_date.strftime('%d %b %R')
    end
    ary.join ' - '
  end

private

  def same_day?(d1, d2)
    d1.year == d2.year && d1.month == d2.month && d1.day == d2.day
  end

  def format_phone
    [:phone, :party_responsible_phone].each do |s|
      self[s].gsub!(/[^0-9]/, '') if self[s].present?
    end
  end

  def must_be_party_room # called if party
    errors.add(:room, 'Festbokning ej tillåten i detta rum') unless room.allow_party
  end

  def must_be_group_in_room
    unless group.present?
      errors.add(:room, 'kan ej bokas som privatperson') if room.only_group
    else
      errors.add(:group, 'är du ej medlem i') unless user.in? group.to_sym
    end
  end

  def must_not_collide
    Booking.future.each do |b|
      unless b == self
        # Algorithm source: http://makandracards.com/makandra/984-test-if-two-date-ranges-overlap-in-ruby-or-rails
        if (begin_date - b.end_date) * (b.begin_date - end_date) >= 0
          errors[:base] << 'Lokalen är redan bokad under denna perioden'
          return
        end
      end
    end
  end

  # def must_be_whitelisted
  #   whitelisted = false
  #   puts 'range:', begin_date..end_date
  # 	WhitelistItem.active.each do |item|
  # 		range = item.range(begin_date)
  #     if range.cover?(begin_date) && range.cover?(end_date)
  #       whitelisted = true
  #       break
  #     end
  #   end
  #   unless whitelisted
  #    errors.add :begin_date, "ligger inte inom whitelistad period"
  #   end
  # end

  def must_not_exceed_max_duration
    unless begin_date.nil? || end_date.nil?
      days = (end_date - begin_date).to_i / 1.day
      errors.add(:end_date, "Bokningen får ej vara längre än en vecka, (är #{days} dagar)") if days > 7
    end
  end
end
