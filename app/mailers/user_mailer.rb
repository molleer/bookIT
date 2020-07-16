class UserMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  def reject_party(report, mail_params)
    @report = report
    @params = mail_params
    mail to: @params[:email], subject: "Din bokning \"#{@report.title}\" godkändes ej"
  end

  def reject_booking(report, reason)
    @report = report
    @reason = reason
    mail to: report.user.email, subject: "Din bokning \"#{@report.title}\" avslogs"
  end
end
