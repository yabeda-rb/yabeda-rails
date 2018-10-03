# Evil::Metrics::[Rails]

Built-in metrics for out-of-the box [Rails] applications monitoring 

if your monitoring system already collects Rails metrics (e.g. NewRelic) then you don't need this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evil-metrics-rails'
# Then add monitoring system adapter, e.g.:
# gem 'evil-metrics-prometheus'
```

And then execute:

    $ bundle

## Metrics

 - Total web requests received: `rails_requests_total`
 - Web request duration: `rails_request_duration` (in seconds)
 - Views rendering duration: `rails_view_runtime` (in seconds)
 - DB request duration: `rails_db_runtime` (in seconds)


## Hooks

 - `on_controller_action`: Allows to collect

    ```ruby
    Evil::Metrics::Rails.on_controller_action do |event, labels|
      next unless event.payload[:ext_service_runtime]
      time_in_seconds = event.payload[:ext_service_runtime] / 1000.0
      rails_ext_service_runtime.measure(labels, time_in_seconds)
    end
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/evil-metrics/evil-metrics-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Rails]: https://rubyonrails.org "Ruby on Rails MVC web-application framework optimized for programmer happiness"
