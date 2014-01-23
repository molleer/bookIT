class Booking < ActiveRecord::Base
  belongs_to :room

  validates :title, :cid, :group, :description, :festansvarig, :festnumber, :room, :begin_date, :end_date, presence: true
  validate :time_whitelisted
  validate :time_not_too_long

  

private
  def time_whitelisted
  	WhitelistItem.all.each do |item|
  		range = item.rule_range

  		# if range in whitelist
      unless range.cover?(self.begin_date)
	     errors.add :begin_date, "ligger inte inom whitelistad period"
      end

      unless range.cover?(self.end_date)
	     errors.add :end_date, "ligger inte inom whitelistad period"
      end

      puts range
    end
  end

  def time_not_too_long
    unless self.begin_date.nil? || self.end_date.nil?
      days = (self.end_date - self.begin_date).to_i / 1.day
      errors[:base] << "Bokningen får ej vara längre än en vecka, (är #{days} dagar)" if days > 7
    end
  end
end
