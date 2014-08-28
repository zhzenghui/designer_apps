class HardWorker
  include Sidekiq::Worker
  def perform(zip_path)
	system zip_path
  end
end