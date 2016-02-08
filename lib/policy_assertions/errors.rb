module PolicyAssertions
  class MissingBlockParameters < StandardError
    def message
      'PolicyTest must pass the permissions into the assert if called ' \
      'from the Rails test block method. Use def test_testname method ' \
      'to have the permissions parsed automatically.'
    end
  end
end
