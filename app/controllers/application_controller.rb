class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :build_signature
  before_filter :validate_size,     only: [ :preview, :download ]

  def index
    @valid = @signature.valid? if params[:signature]
  end

  def preview
    render partial: params[:size], layout: false
  end

  def download
    template = render_to_string partial: params[:size], layout: false
    send_data template, filename: "#{@signature.name} #{params[:size]} Signature.htm", disposition: 'attachment'
  end

protected

  def build_signature
    @signature = Signature.new params[:signature]
  end

  def validate_size
    raise unless ['full', 'medium', 'minimal'].include? params[:size]
  end

end
