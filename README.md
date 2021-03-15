# Yabeda::[Rails]

Built-in metrics for out-of-the box [Rails] applications monitoring.

If your monitoring system already collects Rails metrics (e.g. NewRelic) then most probably you don't need this gem.

Sample Grafana dashboard ID: [11668](https://grafana.com/grafana/dashboards/11668)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yabeda-rails'
# Then add monitoring system adapter, e.g.:
# gem 'yabeda-prometheus'
```

And then execute:

    $ bundle

### Registering metrics on server process start

Currently, yabeda-rails automatically registers rails metrics when a server is started via `rails server`, `puma -C config/puma.rb` or `unicorn -c`. However, other application servers or launching via `rackup` aren't supported at the moment.

A possible workaround is to detect server process and manually activate yabeda-rails in an initializer:

```ruby
# config/initializers/yabeda.rb

if your_app_server_process? # Your logic here
  Yabeda::Rails.install!
end
```

You always can add support for your app server to [lib/yabeda/rails/railtie.rb](lib/yabeda/rails/railtie.rb). Pull Requests are always welcome!


## Metrics

 - Total web requests received: `rails_requests_total`
 - Web request duration: `rails_request_duration` (in seconds)
 - Views rendering duration: `rails_view_runtime` (in seconds)
 - DB request duration: `rails_db_runtime` (in seconds)


## Hooks

 - `on_controller_action`: Allows to collect

    ```ruby
    Yabeda::Rails.on_controller_action do |event, labels|
      next unless event.payload[:ext_service_runtime]
      time_in_seconds = event.payload[:ext_service_runtime] / 1000.0
      rails_ext_service_runtime.measure(labels, time_in_seconds)
    end
    ```

## Custom tags

You can add additional tags to the existing metrics by adding custom payload to your controller.

```ruby
# This block is optional but some adapters (like Prometheus) requires that all tags should be declared in advance
Yabeda.configure do
  default_tag :importance, nil
end

class ApplicationController < ActionController::Base
  def append_info_to_payload(payload)
    super
    payload[:importance] = extract_importance(params)
  end
end
```
`append_info_to_payload` is a method from [ActionController::Instrumentation](https://api.rubyonrails.org/classes/ActionController/Instrumentation.html#method-i-append_info_to_payload)

## Default tags: controller/action

```
Yabeda::Rails.enable_controller_action_default_tags = true
```

Other metrics that are generated while handing a request will include a tag for the controller and the action that we being handled. This works well with other yabeda gems like [yabeda-http_requests](https://github.com/yabeda-rb/yabeda-http_requestshttps://github.com/yabeda-rb/yabeda-http_requests).

Due to the potential for high cardinality, this feature is disabled by default.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Releasing

 1. Bump version number in `lib/yabeda/version.rb`

    In case of pre-releases keep in mind [rubygems/rubygems#3086](https://github.com/rubygems/rubygems/issues/3086) and check version with command like `Gem::Version.new(Yabeda::VERSION).to_s`

 2. Fill `CHANGELOG.md` with missing changes, add header with version and date.

 3. Make a commit:

    ```sh
    git add lib/yabeda/version.rb CHANGELOG.md
    version=$(ruby -r ./lib/yabeda/version.rb -e "puts Gem::Version.new(Yabeda::VERSION)")
    git commit --message="${version}: " --edit
    ```

 4. Create annotated tag:

    ```sh
    git tag v${version} --annotate --message="${version}: " --edit --sign
    ```

 5. Fill version name into subject line and (optionally) some description (list of changes will be taken from changelog and appended automatically)

 6. Push it:

    ```sh
    git push --follow-tags
    ```

 7. You're done!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yabeda-rb/yabeda-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Rails]: https://rubyonrails.org "Ruby on Rails MVC web-application framework optimized for programmer happiness"
