Ializer.setup do |config|
  # config.key_transform = :dasherize # change serailized key names
  # # or
  config.key_transformer = ->(key) {
    key.lowercase.undsercore + "1"
  }
  config.warn_on_default = true
  config.raise_on_default = false
end
