# frozen_string_literal: true

# Purpose: To create a controller for the prospects
class Users::DeviseController < ActionController::Base
  protect_from_forgery
  # Purpose of this method is to override the default behavior of Devise
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to Rails.application.routes.url_helpers.home_institutions_path
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
