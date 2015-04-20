class ChangeSentToDatetimePartyReports < ActiveRecord::Migration
  def change
    add_column :party_reports, :sent_at, :datetime
    remove_column :party_reports, :sent, :boolean
    PartyReport.update_all('sent_at = updated_at')
  end
end
