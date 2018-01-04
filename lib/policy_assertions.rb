require 'rack'
require 'pundit'
require 'rack/test'
require 'active_support'

if Gem::Specification.find_all_by_name('strong_parameters').empty?
  require 'action_controller/metal/strong_parameters'
else
  require 'strong_parameters'
end

require 'policy_assertions/errors'
require 'policy_assertions/version'
require 'policy_assertions/configuration'

module PolicyAssertions
  class Test < ActiveSupport::TestCase
    def assert_permit(user, record, *permissions)
      get_permissions(permissions).each do |permission|
        policy = Pundit.policy!(user, record)
        assert policy.public_send(permission),
               "Expected #{policy.class.name} to grant #{permission} "\
               "on #{record} for #{user} but it didn't"
      end
    end

    def refute_permit(user, record, *permissions)
      get_permissions(permissions).each do |permission|
        policy = Pundit.policy!(user, record)
        refute policy.public_send(permission),
               "Expected #{policy.class.name} not to grant #{permission} "\
               "on #{record} for #{user} but it did"
      end
    end
    alias assert_not_permitted refute_permit

    def assert_strong_parameters(user, record, params_hash, allowed_params)
      policy = Pundit.policy!(user, record)

      param_key = find_param_key(record)

      params = ActionController::Parameters.new(param_key => params_hash)

      strong_params = params.require(param_key)
                      .permit(*policy.permitted_attributes).keys

      strong_params.each do |param|
        assert_includes allowed_params, param.to_sym,
                        "User #{user} should not be permitted to "\
                        "update parameter [#{param}]"
      end
    end

    private

    # borrowed from Pundit::PolicyFinder
    def find_param_key(record)
      if record.respond_to?(:model_name)
        record.model_name.param_key.to_s
      elsif record.is_a?(Class)
        record.to_s.demodulize.underscore
      else
        record.class.to_s.demodulize.underscore
      end
    end

    def get_permissions(permissions)
      return permissions if permissions.present?

      name = calling_method

      fail(MissingBlockParameters) if name.start_with?('block')

      # remove 'test_' and split
      # append ? to the permission
      name[5..-1].split(PolicyAssertions.config.separator).map { |a| "#{a}?" }
    end

    def calling_method
      if PolicyAssertions.config.ruby_version > 1
        caller_locations(3, 1)[0].label
      else
        caller[2][/`.*'/][1..-2]
      end
    end
  end
end
