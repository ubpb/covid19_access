class ApplicationController < ActionController::Base

  before_action :authenticate!

  def stats
    setup_stats

    render partial: "application/stats", locals: {
      number_of_people_entered: @number_of_people_entered,
      max_number_of_people: @max_number_of_people
    }
  end

  def log
    setup_log

    render partial: "application/log", locals: {
      last_registrations: @last_registrations
    }
  end

private

  def authenticate!
    config_username = Rails.configuration.application.username
    config_password = Rails.configuration.application.password

    if config_username.present? && config_password.present?
      authenticate_or_request_with_http_basic do |username, password|
        secure_password = BCrypt::Password.new(
           BCrypt::Password.create(password)
        )

        username == config_username && secure_password == config_password
      end
    else
      false
    end
  end

  def get_filtered_ilsid(id)
    filter_proc = ->(id) { id.gsub(/\s+/, "").upcase } # default filter proc

    if filter_proc_string = Rails.configuration.application.id_filter_proc
      filter_proc = eval(filter_proc_string)
    end

    filter_proc.(id)
  end

  def aleph_x_client
    url = Rails.configuration.application.aleph_x_services_url || "http://localhost:8991/X"
    @aleph_x_client ||= AlephApi::XServicesClient.new(url: url)
  end

  def get_bib_data_for(ilsid)
    aleph_data = aleph_x_client.get(
      op: "bor_info",
      bor_id: ilsid,
      cash: "N",
      loans: "N",
      hold: "N"
    )
    aleph_xml = Nokogiri.parse(aleph_data)

    #puts aleph_xml

    if aleph_xml.at_xpath("//error")&.text
      nil
    else
      bib_data = {}

      bib_data[:name] = aleph_xml.at_xpath("//z304/z304-address-0")&.text
      bib_data[:street] = aleph_xml.at_xpath("//z304/z304-address-1")&.text
      bib_data[:city] = aleph_xml.at_xpath("//z304/z304-address-2")&.text
      bib_data[:phone] = aleph_xml.at_xpath("//z304/z304-telephone")&.text
      bib_data[:email] = aleph_xml.at_xpath("//z304/z304-email-address")&.text

      bib_data
    end
  end

  def setup_stats
    @number_of_people_entered = Registration.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    now = Time.zone.now
    @number_of_people_entered_last_hour = Registration.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Registration.where(exited_at: (now - 1.hour)..now).count
  end

  def setup_log
    @last_registrations = Registration.order("updated_at desc").limit(10)
  end

  def verify_ilsid(ilsid, redirect_to)
    matchers = Rails.configuration.application.valid_ids || []

    if matchers.none?{|r| r.match(ilsid)}
      flash["error"] = "Ausweis-Nr. #{ilsid} ist ungültig."
      redirect_to(redirect_to) and return
    end

    return true
  end

  def verify_registration_for(ilsid)
    registration = Registration.find_by(ilsid: ilsid, exited_at: nil)

    if registration.present?
      flash["error"] = "Ausweis-Nr. #{ilsid} befindet sich bereits im Gebäude. Möglicherweise wurde die Auslassbuchung nicht erfasst."
      redirect_to(entries_path) and return
    end

    return true
  end

  def verify_bib_data(ilsid, bib_data)
    if bib_data.nil?
      flash["error"] = "Ausweis #{ilsid} unbekannt."
      redirect_to(entries_path) and return
    end

    return true
  end

end
