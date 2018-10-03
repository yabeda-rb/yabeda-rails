# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "evil-metrics-rails"
  spec.version       = "0.1.0"
  spec.authors       = ["Andrey Novikov"]
  spec.email         = ["envek@envek.name"]

  spec.summary       = "Extensible metrics for monitoring Ruby on Rails application"
  spec.description   = "Easy collecting your Rails apps metrics"
  spec.homepage      = "https://github.com/evil-metrics/evil-metrics-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "evil-metrics"
  spec.add_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
