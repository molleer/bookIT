require 'capybara'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true, :js_errors => false)
end

class StudentPortalReporter
  include Capybara::DSL

  LOGIN_URL = "https://idp.chalmers.se/adfs/ls/?wa=wsignin1.0&wtrealm=urn%3achalmers%3astudent&wctx=https%3a%2f%2fstudent.portal.chalmers.se%2f_layouts%2fChalmers%2fAuthenticate.aspx%3fSource%3dhttps%3a%2f%2fstudent.portal.chalmers.se%2fsv%2fchalmersstudier%2fSidor%2fTjanster.aspx"
  ANMALAN_AV_ARRANGEMANG_URL = "https://student.portal.chalmers.se/sv/studentliv/anmalanavarrangemang/Sidor/AnmalanAvArrangemang.aspx?authenticated"
  SUCCESS_CONTENT = /Tack för din anmälan av detta arrangemang/i

  def initialize
    Capybara.default_driver = :poltergeist_debug
  end

  def correct_minute_string(minute_string)
    minute = (minute_string[3..4].to_i / 5) * 5
    minute.to_s.rjust(2, '0')
  end

  def try_10_times(wait_between_tries, on_attempt_failed, on_all_failed)
    tries = 0
    begin
      yield
    rescue
      if tries < 10
        on_attempt_failed.call(tries, 10, wait_between_tries)
        sleep wait_between_tries
        tries += 1
        retry
      else
        on_all_failed.call(tries)
      end
    end

  end

  FIELD_IDS = {
    title:                      'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl00_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    room:                       'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl01_ctl00_ctl00_ctl04_ctl00_Lookup',
    participants:               'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl02_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    boards_approval:            'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl03_ctl00_ctl00_ctl04_ctl00_ctl00',
    start_date:                 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate',
    start_time:                 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours',
    start_minute:               'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl04_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes',
    end_date:                   'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDate',
    end_time:                   'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateHours',
    end_minute:                 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl05_ctl00_ctl00_ctl04_ctl00_ctl00_DateTimeField_DateTimeFieldDateMinutes',
    organiser:                  'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl06_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    liquor_license:             'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl07_ctl00_ctl00_ctl04_ctl00_DropDownChoice',
    party_responsible_name:     'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl08_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    party_responsible_phone:    'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl09_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    party_responsible_mail:     'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl10_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    co_party_responsible_name:  'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl11_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    co_party_responsible_phone: 'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl12_ctl00_ctl00_ctl04_ctl00_ctl00_TextField',
    co_party_responsible_mail:  'ctl00_m_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl13_ctl00_ctl00_ctl04_ctl00_ctl00_TextField'
  }

  def try_login
    visit LOGIN_URL
    Rails.logger.info("Trying to login.. ")

    begin
      within("#loginForm") do
        fill_in 'UserName', with: Rails.application.secrets.vo_usr
        fill_in 'Password', with: Rails.application.secrets.vo_pwd
      end
    rescue Capybara::ElementNotFound
      return if first('#' + FIELD_IDS[:title]) # If the title field is found, then we're already logged in.
      save_and_open_page
      raise "Failed to login, elements not found, saving page to app root."
    end
    click_button('submitButton')
  end

  def party_report(reports)
    Rails.logger.info("Starting login")

    login_attemt_failed = ->(current_try, max_tries, wait_time) {Rails.logger.info("Login attemt #{current_try}/#{max_tries} failed, waiting #{wait_time} and trying again.")}
    unable_to_login = ->(tries) {
      Rails.logger.info("All #{tries} login attemts failed. Are corrent login credentials being used?")
      save_and_open_page
      raise "Unable to login to studentportalen, check the logs, saved page to app root"
    }
    try_10_times 0.5, login_attemt_failed, unable_to_login do try_login end

    Rails.logger.info("Succesfully logged in")

    unless current_url == ANMALAN_AV_ARRANGEMANG_URL
      visit ANMALAN_AV_ARRANGEMANG_URL
    end

    sleep 0.5

    reports.each do |b|
      Rails.logger.info("Starting report")
      begin
        approval_type = b.liquor_license ? 'Sökt' : 'Ej aktuellt'
        deltagare = 75
        start_date = b.begin_date.strftime '%F'
        start_time = b.begin_date.strftime '%R'
        start_minute = correct_minute_string start_time
        end_date = b.end_date.strftime '%F'
        end_time = b.end_date.strftime '%R'
        end_minute = correct_minute_string end_time

          within("#aspnetForm") do
            fill_in FIELD_IDS[:title], with: b.title
            select  'Hubben', from: FIELD_IDS[:room]
            fill_in FIELD_IDS[:participants], with: deltagare
            check   FIELD_IDS[:boards_approval]
            fill_in FIELD_IDS[:start_date], with: start_date
            select  start_time[0..2], from: FIELD_IDS[:start_time]
            select  start_minute, from: FIELD_IDS[:start_minute]
            fill_in FIELD_IDS[:end_date], with: end_date
            select  end_time[0..2], from: FIELD_IDS[:end_time]
            select  end_minute, from: FIELD_IDS[:end_minute]
            fill_in FIELD_IDS[:organiser], with: b.group
            select  approval_type, from: FIELD_IDS[:liquor_license]
            fill_in FIELD_IDS[:party_responsible_name], with: b.party_responsible_name
            fill_in FIELD_IDS[:party_responsible_phone], with: b.party_responsible_phone
            fill_in FIELD_IDS[:party_responsible_mail], with: b.party_responsible_mail
            fill_in FIELD_IDS[:co_party_responsible_name], with: b.co_party_responsible_name
            fill_in FIELD_IDS[:co_party_responsible_phone], with: b.co_party_responsible_phone
            fill_in FIELD_IDS[:co_party_responsible_mail], with: b.co_party_responsible_mail
            # fill_in 'ctl00_ctl19_g_2ec8a987_c320_462d_8231_f85b57c1503e_ctl00_ctl00_ctl05_ctl14_ctl00_ctl00_ctl04_ctl00_ctl00_TextField', with: comments
          end
          # puts "Sent #{b.title} to Chalmers"
          click_button("Skicka anmälan")
          # page.driver.debug

        on_attempt_failed = ->(current_try, max_tries, time_between_tries) {
          Rails.logger.info("Couldn't find success content yet. Trying again in #{time_between_tries} sec. Try #{current_try}/#{max_tries}")
        }
        on_all_failed = ->(tries) {
            save_and_open_page
            raise "error, Unable to see success content, check your mail to see if it was successful, saved page to app root"
        }

        try_10_times 0.5, on_attempt_failed, on_all_failed do
          raise "error" unless page.has_content?(SUCCESS_CONTENT)
        end

        visit ANMALAN_AV_ARRANGEMANG_URL

      rescue Capybara::ElementNotFound => e
        save_and_open_page
        raise "error, saved page to app root, #{e.message}"
      end
    end
  end


end
