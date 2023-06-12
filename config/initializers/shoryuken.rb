Shoryuken.active_job_queue_name_prefixing = true

# For dynamically adding queues prefixed by Rails.env
Shoryuken.add_group('default', 25)
%w[cameamea].each do |name|
  Shoryuken.add_queue("#{Rails.env}_#{name}", 1, 'default')
end

Shoryuken.worker_executor = Shoryuken::Worker::InlineExecutor if Rails.env == 'development'
