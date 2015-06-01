module PolicyAssertions
  Configuration = Struct.new(:separator, :ruby_version)
  @config = Configuration.new('_and_', RUBY_VERSION.split('.')[0].to_i)

  # rubocop:disable Style/TrivialAccessors
  def self.config
    @config
  end
end
