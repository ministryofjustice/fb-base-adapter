require 'logger'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

logger = Logger.new('./sweeper.log')

# At 06:00.
scheduler.cron '* 06 * * *' do
  files = Dir['tmp/*']
  logger.info("Sweeping files: #{files.join(',')}")
  FileUtils.rm_rf(files)
end

scheduler.join
