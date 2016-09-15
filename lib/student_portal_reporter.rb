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

  def perform_with_error_msg(element_string, &block)
    begin
      block.call
    rescue Capybara::ElementNotFound
        save_and_open_page
        raise "error, ElementNotFound, (#{element_string}). saved page to app root"
    end
  end

  def correct_minute_string(minute_string)
    minute = (minute_string[3..4].to_i / 5) * 5
    minute.to_s.rjust(2, '0')
  end

  def party_report(reports)
    visit LOGIN_URL
    Rails.logger.info("Starting login")
    while current_url != ANMALAN_AV_ARRANGEMANG_URL
      Rails.logger.info("Trying to login.. ")
      begin
        within("#aspnetForm") do
          fill_in 'ctl00_ContentPlaceHolder1_UsernameTextBox', with: Rails.application.secrets.vo_usr
          fill_in 'ctl00_ContentPlaceHolder1_PasswordTextBox', with: Rails.application.secrets.vo_pwd
        end
      rescue Capybara::ElementNotFound
        save_and_open_page
        raise "Failed to login, saving page to app root."
      end
      #find_button('ctl00_ContentPlaceHolder1_SubmitButton').trigger('click')
      click_button('ctl00_ContentPlaceHolder1_SubmitButton')
    end
    Rails.logger.info("Succesfully logged in") 

    unless current_url == ANMALAN_AV_ARRANGEMANG_URL
      visit ANMALAN_AV_ARRANGEMANG_URL
    end

    sleep 0.5

    reports.each do |b|
      Rails.logger.info("Starting report")
      begin
        approval_type = b.liquor_license == '1' ? 'Sökt' : 'Ej aktuellt'
        deltagare = 75
        start_date = b.begin_date.strftime '%F'
        start_time = b.begin_date.strftime '%R'
        start_minute = correct_minute_string start_time
        end_date = b.end_date.strftime '%F'
        end_time = b.end_date.strftime '%R'
        end_minute = correct_minute_string end_time

          within("#aspnetForm") do
            perform_with_error_msg 'title' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl00_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.title end
            perform_with_error_msg 'lokal' do select 'Hubben', from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl01_ctl00_ctl00_ctl04_ctl00_Lookup' end
            perform_with_error_msg 'antal deltagare' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl02_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: deltagare end
            perform_with_error_msg 'styrelsens medgivande' do check 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl03_ctl00_ctl00_ctl04_ctl00_ctl00' end
            perform_with_error_msg 'start date' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate', with: start_date end
            perform_with_error_msg 'start hour' do select start_time[0..2], from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours' end
            perform_with_error_msg 'start minute' do select start_minute, from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes' end
            perform_with_error_msg 'end date' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate', with: end_date end
            perform_with_error_msg 'end hour' do select end_time[0..2], from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours' end
            perform_with_error_msg 'end minute' do select end_minute, from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes' end
            perform_with_error_msg 'arrangör' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl06_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.group end
            perform_with_error_msg 'serveringstillstånd' do select approval_type, from: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl07_ctl00_ctl00_ctl04_ctl00_DropDownChoice' end
            perform_with_error_msg 'ansvarig' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl08_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_name end
            perform_with_error_msg 'ansvarig mobil' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl09_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_phone end
            perform_with_error_msg 'ansvarig email' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl10_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.party_responsible_mail end
            perform_with_error_msg 'medansvarig' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl11_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_name end
            perform_with_error_msg 'medansvarig mobil' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl12_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_phone end
            perform_with_error_msg 'medansvarig email' do fill_in 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl13_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: b.co_party_responsible_mail end
            # fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl14_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: comments
          end
          # puts "Sent #{b.title} to Chalmers"
          perform_with_error_msg 'submit' do find_button('ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_toolBarTbl_RightRptControls_ctl00_ctl00_diidIOSaveItem').trigger('click') end
          # page.driver.debug
          if page.has_content?(/Tack för din anmälan av detta arrangemang/i)
            Rails.logger.info("Report submitted")
          else
            save_and_open_page
            raise "error, Failed to submit report, saved page to app root"
          end
  
        visit ANMALAN_AV_ARRANGEMANG_URL

      rescue Capybara::ElementNotFound
        save_and_open_page
        raise "error, ElementNotFound, saved page to app root"
      end
    end
  end
end
