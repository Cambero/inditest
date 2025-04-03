env :PATH, ENV["PATH"]
set :output, "log/cron_log.log"
set :environment, "development"

job_type :runner, "cd :path && RAILS_ENV=:environment asdf exec bundle exec rails runner :task :output"

every 10.minutes do
  runner "RemoveExpiredProductsFromCarts.call"
end
