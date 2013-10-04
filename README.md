# Checkgateway

## Installation

Add this line to your application's Gemfile:

    gem 'checkgateway'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install checkgateway

## Usage

First, configure your client with credentials provided by Check Gateway.
```ruby
client = CheckGateway::Client.new(:login => "mylogin",
                                  :password => "mypassword",
                                  :test_url => "Test URL provided by Check Gateway",
                                  :live_url => "Live URL provided by Check Gateway",
                                  :ach_path => "ACH API path provided by Check Gateway",
                                  :consumer_path => "Consumer API path provided by Check Gateway")
```

You can submit ACH real-time calls using consumer data directly.

```ruby
client.authorize(:reference_number => "my-auth-reference",
                 :amount =>"1.02",
                 :routing_number => "999999992",
                 :account_number => "123",
                 :savings => false)
```

Or, if you use the consumer API:

```ruby
# create a consumer
response = client.add_consumer(:name => "Joe Smith",
                               :routing_number => "999999992",
                               :account_number => "123",
                               :savings => false)

# store consumer id
consumer_id = response["Id"]

# future API calls use consumer id instead of consumer data
client.debit(:reference_number => "my-debit-reference",
             :amount =>"1.02",
             :consumer_id => consumer_id)
```

Retrieve a specific consumer profile.

``` ruby
client.list_consumer(:consumer_id => "xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx")
```

Retrieve all consumer profiles.

``` ruby
client.list_consumer
```

Read the source code and API documentation for other API calls.

## Development

Enable debug with:

```ruby
client.debug = true
```

## Production

You must explicitly enable production mode.

```ruby
client.test_mode = false
```

## Notes

Mostly built to be used with consumer ids.

Haven't tested ACH methods without using consumer id.

Using ruby 1.9.3.

Check Gateway API version defaults to 1.4.2.11.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
