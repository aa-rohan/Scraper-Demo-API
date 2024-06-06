Sidekiq::Cron::Job.create(
  name: 'Update old products',
  cron: '0 0 * * *',
  class: 'ProductUpdateWorker'
)
