namespace :bookit do
	desc "Send reminder by email"
	task remind: :environment do
		@reports = PartyReport.not_denied.unsent.in_future.within(48.hours.from_now)
		AdminMailer.remind_vo(@reports).deliver if @reports.any?
	end
end
