# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yabeda/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "yabeda-rails"
  spec.version       = Yabeda::Rails::VERSION
  spec.authors       = ["Andrey Novikov"]
  spec.email         = ["envek@envek.name"]

  spec.summary       = "Extensible metrics for monitoring Ruby on Rails application"
  spec.description   = "Easy collecting your Rails apps metrics"
  spec.homepage      = "https://github.com/yabeda-rb/yabeda-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "yabeda", "~> 0.4"
  spec.add_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
