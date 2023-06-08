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
        when 'GenerateProspectsVideosJob'
          GenerateProspectsVideosJob.perform_now(response['arguments'].first)
        else
          Rollbar.error("Unknown job #{response['job_class']}")
        end
      end
      head 200
    end
  rescue StandardError => e
    Rollbar.error(e)
    head 200
  end
end
