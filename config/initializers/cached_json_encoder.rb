if ENV['CACHE']
  require 'as_json_encoder'

  if ENV['NULL_STORE']
    AsJsonEncoder.cache = ActiveSupport::Cache::NullStore.new
  end

  if ENV['LOG']
    ActiveSupport::Notifications.subscribe "cache_fetch_hit.active_support" do |*, payload|
      Rails.logger.debug "[HIT]  #{payload[:key]}"
    end

    ActiveSupport::Notifications.subscribe "cache_generate.active_support" do |*, payload|
      Rails.logger.debug "[MISS] #{payload[:key]}"
    end
  end

  Cachable = AsJsonEncoder::Cachable
else
  Cachable = Module.new
end
