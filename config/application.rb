require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CorpValidator
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.before_configuration do
      env_variables_path = File.join(Rails.root, "config", "env_variables.yml")

      if File.exists?(env_variables_path)
        YAML.load(File.open(env_variables_path)).each do |key, value|
          ENV[key.to_s] = value.to_s
        end
      end
    end
  end
end
