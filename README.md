# policy-assertions

[![Build Status](https://circleci.com/gh/ProctorU/policy-assertions.svg?style=shield&circle-token=7084a829c9e63b415f59e627d9e4ee90db7d2afa)](https://circleci.com/gh/ProctorU/policy-assertions) [![Gem Version](https://badge.fury.io/rb/policy-assertions.svg)](https://badge.fury.io/rb/policy-assertions)

Minitest test assertions for [Pundit](https://github.com/elabs/pundit) policies.

policy-assertions provides a test class for easy Pundit testing. The test class provides assertions and refutations for policies and strong parameters.

## Table of contents

* [Installation](#installation)
* [Usage](#usage)
* [Available test methods](#test-method-naming)
* [Configuration](#configuration)
* [Developing](#developing)
* [Credits](#credits)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'policy-assertions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install policy-assertions

**Add require policy_assertions to test_helper.rb**

```ruby
require 'policy_assertions'
```

## Usage

policy-assertions is intended to make testing Pundit policies as simple as possible. The gem adds the following helpers:

* PolicyAssertions::Test class
* parses permissions to test from method name
* assert_permit and refute_permit methods
* assert_strong_parameters

The following code sample illustrates the intended use of this gem.

```ruby
# The class is named after the policy to be tested.
class ArticlePolicyTest < PolicyAssertions::Test

  # Test that the Article model allows index and show
  # for any site visitor. nil is passed in for the user.
  def test_index_and_show
    assert_permit nil, Article
  end

  # Test that a site staff member is allowed access
  # to new and create
  def test_new_and_create
    assert_permit users(:staff), Article
  end

  # Test that this user cannot delete this article
  def test_destroy
    refute_permit users(:regular), articles(:instructions)
  end

  # Test a permission by passing in an array instead of
  # defining it in the method name
  def test_name_is_not_a_permission
    refute_permit nil, Article, 'create?', 'new?'
  end

  # Test that a site staff member has access to the
  # parameters defined in the params array.
  # Site visitors should not have access to any Article attributes
  def test_strong_parameters
    params = [:title, :body, :tags]
    assert_strong_parameters(users(:staff), Article,
                             article_attributes, params)

    assert_strong_parameters(nil, Article, article_attributes, [])
  end
end
```

If policies are namespaced, the invocation of the class name should follow the same syntax as Pundit.

```ruby
# Test that the Organizations::Article model allows index and show
# for any site visitor. nil is passed in for the user.
def test_index_and_show
  assert_permit nil, [:organizations, Article]
end
```

## Test method naming

policy-assertions can read the permissions to test from the method name. This will only work when using the minitest def test_name syntax. When using the block syntax, you must explicitly pass the permission names.

```ruby
# Good
# The create permission will be parsed from this method name
def test_create
end

# Good
# multiple permissions are defined in this method name
def test_show_and_index
end

# Good block syntax
# The permission cannot be automatically read, so you must pass the policy names directly.
test 'create' do
 refute_permit nil, Article, 'create?', 'new?'
end
```

Define multiple permissions in a method name by separating the permissions using '\_and\_'.

See the configuration section for changing the separator value.

### assert_permit and refute_permit

These methods take the following parameters:

* User to authorize
* Model or instance to authorize
* Optional array of permissions. They should match the permission method name exactly.

#### Passing permissions to assert and refute

When permissions are passed to assert or refute, the test method name is ignored and does not need to match a policy permission.

```ruby
class ArticlePolicyTest < PolicyAssertions::Test
  # this method name is not parsed since the permissions
  # are passed into the method
  def test_that_a_user_can_do_stuff
    assert_permit nil, Article, 'show?', 'index?'
  end
end
```

### Using the rails test block helper

policy-assertions will work with the rails test block helper but it cannot parse the permissions. If a test block is used and the permissions are not passed to the `assert` and `refute` methods, a PolicyAssertions::MissingBlockParameters error will be thrown.

```ruby
class ArticlePolicyTest < PolicyAssertions::Test
  test 'index?' do
    assert_permit @user, Article, 'index?', 'show?'
  end

  # Actions can also be passed as an array
  test 'index?' do
    assert_permit @user, Article, %w(index? show?)
  end

  # this will result in a
  # PolicyAssertions::MissingBlockParameters error
  test 'show?' do
    assert_permit @user, Article
  end
end
```

### Strong Parameters

Since Pundit offers a [permitted_attributes](https://github.com/elabs/pundit#strong-parameters) helper, policy-assertions provides an assert method for testing.

```ruby
class ArticlePolicyTest < PolicyAssertions::Test
  # Test that a site staff member has access to the
  # parameters defined in the params method.
  # Site visitors should not have access to any Article attributes
  def test_strong_parameters
    params = [:title, :body, :tags]
    assert_strong_parameters(users(:staff), Article,
                             article_attributes, params)

    assert_strong_parameters(nil, Article, article_attributes, [])
  end
end
```

## Configuration

Use the following in your test helper to change the test definition permissions separator.

```ruby
PolicyAssertions.config.separator = '__separator__'
```

## Developing

1. Fork it ( https://github.com/[my-github-username]/policy-assertions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes with tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

Policy-assertions is maintained and funded by [ProctorU](https://twitter.com/ProctorU),
a simple online proctoring service that allows you to take exams or
certification tests at home.

We'd like to thank [@ksimmons](https://github.com/ksimmons) for being the original creator of policy-assertions and allowing us to maintain the project.

<br>

<p align="center">
  <a href="https://twitter.com/ProctorUEng">
    <img src="https://s3-us-west-2.amazonaws.com/dev-team-resources/procki-eyes.svg" width=108 height=72>
  </a>

  <h3 align="center">
    <a href="https://twitter.com/ProctorUEng">ProctorU Engineering & Design</a>
  </h3>
</p>
