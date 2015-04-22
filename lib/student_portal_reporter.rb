require 'capybara'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true, :js_errors => false)
end

class StudentPortalReporter
  include Capybara::DSL

  LOGIN_URL = "https://student.portal.chalmers.se/_layouts/Chalmers/Authenticate.aspx?Source=/sv/studentliv/anmalanavarrangemang/Sidor/AnmalanAvArrangemang.aspx"
  ANMALAN_AV_ARRANGEMANG_URL = "https://student.portal.chalmers.se/sv/studentliv/anmalanavarrangemang/Sidor/AnmalanAvArrangemang.aspx?authenticated"

  def initialize
    Capybara.default_driver = :poltergeist_debug
  end


  def party_report(reports)
    visit LOGIN_URL

    unless current_url == ANMALAN_AV_ARRANGEMANG_URL
      within("#aspnetForm") do
        fill_in 'ctl00_ContentPlaceHolder1_UsernameTextBox', with: Rails.application.secrets.vo_usr
        fill_in 'ctl00_ContentPlaceHolder1_PasswordTextBox', with: Rails.application.secrets.vo_pwd
      end
      find_button('ctl00_ContentPlaceHolder1_SubmitButton').trigger('click')
    end

    reports.each do |b|

      approval_type = b.liquor_license == '1' ? 'Sökt' : 'Ej aktuellt'
      deltagare = 75
      start_date = b.submit_begin_date.strftime '%F'
      end_date = b.submit_end_date.strftime '%F'
      start_time = b.submit_begin_date.strftime '%R'
      end_time = b.submit_end_date.strftime '%R'

      within("#aspnetForm") do
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl00_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.title
        select 'Hubben', from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl01_ctl00_ctl00_ctl04_ctl00_Lookup'
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl02_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: deltagare
        check 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl03_ctl00_ctl00_ctl04_ctl00_ctl00'
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate', with: start_date
        select start_time[0..2], from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours'
        select start_time[3..4], from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes'
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate', with: end_date
        select end_time[0..2], from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours'
        select end_time[3..4], from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes'
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl06_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.group
        select approval_type, from: 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl07_ctl00_ctl00_ctl04_ctl00_DropDownChoice'
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl08_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_name
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl09_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_phone
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl10_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_mail
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl11_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_name
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl12_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_phone
        fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl13_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_mail
        # fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl14_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: comments
      end
      # puts "Sent #{b.title} to Chalmers"
      find_button('ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_toolBarTbl_RightRptControls_ctl00_ctl00_diidIOSaveItem').trigger('click')
      # page.driver.debug

      visit ANMALAN_AV_ARRANGEMANG_URL
    end
  end
end
