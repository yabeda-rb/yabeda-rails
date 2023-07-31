# frozen_string_literal: true

require "action_controller/test_case"

RSpec.describe Yabeda::Rails, type: :integration do
  include ActionDispatch::Integration::Runner
  include ActionDispatch::IntegrationTest::Behavior

  def app
    TestApplication
  end

  it "increments counters for every request" do
    expect { get "/hello/world" }.to \
      increment_yabeda_counter(Yabeda.rails.requests_total)
      .with_tags(controller: "hello", action: "world", status: 200, method: "get", format: :html)
      .by(1)
  end

  it "measure action runtime for every request" do
    expect { get "/hello/long" }.to \
      measure_yabeda_histogram(Yabeda.rails.request_duration)
      .with_tags(controller: "hello", action: "long", status: 200, method: "get", format: :html)
      .with(be_between(0.005, 0.05))
  end

  it "returns internal_server_error status code" do
    expect { get "/hello/internal_server_error" }.to \
      increment_yabeda_counter(Yabeda.rails.requests_total)
      .with_tags(controller: "hello", action: "internal_server_error", status: 500, method: "get", format: :html)
  end

  it "supports configuring controller name case" do
    original_case = Yabeda::Rails.config.controller_name_case
    Yabeda::Rails.config.controller_name_case = :camel

    expect { get "/hello/world" }.to \
      increment_yabeda_counter(Yabeda.rails.requests_total)
      .with_tags(controller: "HelloController", action: "world", status: 200, method: "get", format: :html)
      .by(1)

    Yabeda::Rails.config.controller_name_case = original_case
  end
end
