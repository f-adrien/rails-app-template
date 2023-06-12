# frozen_string_literal: true

creds = Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id), Rails.application.credentials.dig(:aws, :secret_access_key))

# Aws::Rails.add_action_mailer_delivery_method(
#   :ses,
#   credentials: creds,
#   region: 'eu-west-1'
# )

Shoryuken.sqs_client = Aws::SQS::Client.new(
  credentials: creds,
  region: 'eu-west-3'
)
