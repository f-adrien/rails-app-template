# frozen_string_literal: true

# require 'application_responder'

# ApplicationController
class ApplicationController < ActionController::Base
  # self.responder = ApplicationResponder
  # respond_to :html

  protect_from_forgery
  before_action :authenticate_user!
  include ActiveStorage::SetCurrent

  set_current_tenant_through_filter
  before_action :set_infos

  def render_turbo_flashes(flash_type, message)
    flash.now[flash_type] = message
    render turbo_stream: turbo_stream.update(:flashes, partial: 'shared/flashes')
  end

  def close_modal
    @modal_id = params[:id].to_sym
  end

  def change_account
    # Logic in case of cross-accounts redirection
    # referrer_url = Rails.application.routes.recognize_path(request.referrer)
    account_id = params.dig(:accounts, :account_id)
    # redirection_url = RedirectionService.build_redirection(referrer_url, account_id)
    session[:account_id] = account_id
    redirect_to root_path
  end

  private

  def set_infos
    @account = Account.find_by(id: session[:account_id])
    set_current_tenant(@account)
  end
end
