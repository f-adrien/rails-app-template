# frozen_string_literal: true

def create_controllers
  override_application_controller
  create_workers_controller
end

def override_application_controller
  inject_into_file 'app/controllers/application_controller.rb',
                   after: "class ApplicationController < ActionController::Base\n" do
    <<-'RUBY'
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
    RUBY
  end
end

def create_workers_controller
  file 'app/controllers/workers_controller.rb', <<~RUBY
    # frozen_string_literal: true

    class WorkersController < ActionController::API
      # We add a Mutex since jobs are not locked, for variables safety and data security.
      # Mutex ensure one job is done at a time and not concurrently.
      @@worker_mutex ||= Mutex.new

      def parse_sqs_messages
        @@worker_mutex.synchronize do
          response = JSON.parse(request.body.read)
          if response['job_class']
            case response['job_class']
            when 'JobName'
              # Do something
            else
              Rollbar.error("Unknown job")
            end
          end
          head 200
        end
      rescue StandardError => e
        Rollbar.error(e)
        head 200
      end
    end
  RUBY
end
