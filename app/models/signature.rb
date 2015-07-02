class Signature

  include ActiveModel::Validations
  include ActiveModel::Conversion

  extend ActiveModel::Naming

  include ActionView::Helpers::NumberHelper

  DEFAULTS = {
    company:  'EYC3',
    address:  'Level 4, 459 Little Collins St Melbourne, VIC 3000',
    website:  'http://c3.com.au/',
    twitter:  'C3Business',
    linkedin_name:  'EYC3',
    linkedin_url:   'http://www.linkedin.com/company/eyc3'
  }

  LOGO_PATHS = {
    'c3'  =>  'http://c3.com.au/images/ey_c3_email_1.gif',
    'imc' =>  'http://c3.com.au/images/ey_imc_email_1.gif'
  }

  attr_accessor :name, :role, :phone, :email, :linkedin_name, :linkedin_url, :twitter, :company, :address, :website, :logo,
                :assistant_name, :assistant_phone, :assistant_email

  validates :name, :role, :phone, :email, :company, :address, :website, :twitter, :linkedin_name, :linkedin_url, :logo, presence: true
  validates :assistant_phone, :assistant_email, :presence => true, :if => Proc.new { |r| r.assistant_name.present? }
  validates :logo, inclusion: %w( c3 imc )

  def persisted?
    false
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value } if attributes
  end

  DEFAULTS.each do |attribute, default_value|
    define_method("default_#{attribute}") { DEFAULTS[attribute.to_sym] }
    define_method("custom_#{attribute}?") { send(attribute) != send("default_#{attribute}") }
    define_method(attribute) { instance_variable_get("@#{attribute}").presence || send("default_#{attribute}") }
  end

  def phone=(value)
    @phone = number_to_phone value.gsub(/\A(\+61\s*)*/, '').gsub(/\A\s*0/, ''), country_code: 61, delimiter: ' ' if value.present?
  end

  def assistant_phone=(value)
    @assistant_phone = number_to_phone value.gsub(/\A(\+61\s*)*/, '').gsub(/\A\s*0/, ''), country_code: 61, delimiter: ' ' if value.present?
  end

  def email=(value)
    @email = value.gsub(/@.*\Z/, '') if value.present?
  end

  def full_email
    "#{email}@c3.com.au" if email.present?
  end

  def linkedin_name
    custom_linkedin_url? ? name : default_linkedin_name
  end

  def twitter=(value)
    @twitter = value.gsub(/\A@*/, '')
  end

  def twitter_name
    twitter_to_name twitter
  end

  def default_twitter_name
    twitter_to_name default_twitter
  end

  def twitter_url
    twitter_to_url twitter
  end

  def default_twitter_url
    twitter_to_url default_twitter
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

protected

  def twitter_to_name(twitter)
    "@#{twitter}"
  end

  def twitter_to_url(twitter)
    URI::HTTPS.build(host: 'twitter.com', path: "/#{twitter}").to_s
  end

end
