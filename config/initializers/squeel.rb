Squeel.configure do |config|
  # To load hash extensions (to allow for AND (&), OR (|), and NOT (-) against
  # hashes of conditions)
  config.load_core_extensions :hash

  # To load symbol extensions (for a subset of the old MetaWhere functionality,
  # via ARel predicate methods on Symbols: :name.matches, etc)
  # config.load_core_extensions :symbol

  # To load both hash and symbol extensions
  # config.load_core_extensions :hash, :symbol
end
