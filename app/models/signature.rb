class Signature

  include ActiveModel::Validations
  include ActiveModel::Conversion

  extend ActiveModel::Naming

  include ActionView::Helpers::NumberHelper

  DEFAULTS = {
    linkedin: 'http://www.linkedin.com/company/c3-businesssolutions',
    company:  'C3 Business Solutions',
    address:  'Level 4, 459 Little Collins St Melbourne, VIC 3000',
    website:  'http://c3.com.au/'
  }

  LOGO_PATHS = {
    'c3'  =>  'http://c3.com.au/images/ey_c3_email_logo.gif',
    'imc' =>  'http://c3.com.au/images/ey_imc_email_logo.gif'
  }

  attr_accessor :name, :phone, :email, :linkedin, :company, :address, :website, :logo

  validates :name, :phone, :email, :linkedin, :company, :address, :website, presence: true
  validates :logo, inclusion: %w( c3 imc )

  def persisted?
    false
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value } if attributes
  end

  def phone=(value)
    @phone = number_to_phone value.gsub(/\A(\+61\s*)*/, '').gsub(/\A\s*0/, ''), country_code: 61, delimiter: ' ' if value.present?
  end

  def email=(value)
    @email = value.gsub(/@.*\Z/, '') if value.present?
  end

  def full_email
    "#{email}@c3.com.au" if email.present?
  end

  def linkedin
    @linkedin.presence || DEFAULTS[:linkedin]
  end

  def linkedin_is_default?
    linkedin == DEFAULTS[:linkedin]
  end

  def company
    @company_name.presence || DEFAULTS[:company]
  end

  def address
    @address.presence || DEFAULTS[:address]
  end

  def website
    @website.presence || DEFAULTS[:website]
  end

  def website_host
    URI.parse(website).host
  end

  def logo_path
    LOGO_PATHS[logo]
  end

end
