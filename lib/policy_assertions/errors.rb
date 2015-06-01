module PolicyAssertions
  class InvalidClassName < StandardError
    def message
      'The test class must be the same as a pundit policy class. ' \
      'For example, RecordPolicyTest'
    end
  end

  class MissingBlockParameters < StandardError
    def message
      'PolicyTest must pass the permissions into the assert if called ' \
      'from the Rails test block method. Use def test_testname method ' \
      'to have the permissions parsed automatically.'
    end
  end
end
