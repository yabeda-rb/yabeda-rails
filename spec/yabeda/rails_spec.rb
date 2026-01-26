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

  context "with changed controller name case config tp camel case" do
    around do |example|
      original_case = described_class.config.controller_name_case
      described_class.config.controller_name_case = :camel
      example.call
    ensure
      described_class.config.controller_name_case = original_case
    end

    it "reports controller tag in camel case" do
      expect { get "/hello/world" }.to \
        increment_yabeda_counter(Yabeda.rails.requests_total)
        .with_tags(controller: "HelloController", action: "world", status: 200, method: "get", format: :html)
        .by(1)
    end
  end

  context "with default_tags set" do
    before do
      Yabeda.default_tag :custom_tag, nil
    end

    it "increments counters for every request" do
      expect { get "/hello/world" }.to \
        increment_yabeda_counter(Yabeda.rails.requests_total)
        .with_tags(custom_tag: "hello-world")
        .by(1)
    end
  end

  context "with ':rails' default_tags set" do
    before do
      Yabeda.default_tag :custom_tag_from_rails, nil, group: :rails
    end

    it "increments counters for every request" do
      expect { get "/hello/world" }.to \
        increment_yabeda_counter(Yabeda.rails.requests_total)
        .with_tags(custom_tag_from_rails: "hello-world-from-rails")
        .by(1)
    end
  end

  context "with ignore_actions" do
    around do |example|
      original_ignore_actions = described_class.config.ignore_actions
      described_class.config.ignore_actions = ["HelloController#world", "HelloController#long"]
      example.call
    ensure
      described_class.config.ignore_actions = original_ignore_actions
    end

    it "ignores actions matching the proc" do
      expect { get "/hello/world" }.not_to \
        increment_yabeda_counter(Yabeda.rails.requests_total)
    end
  end

  context "with ignore_actions as a proc" do
    around do |example|
      original_ignore_actions = described_class.config.ignore_actions
      described_class.config.ignore_actions = lambda { |controller_action|
        controller_action.start_with?("HelloController#")
      }
      example.call
    ensure
      described_class.config.ignore_actions = original_ignore_actions
    end

    it "ignores actions matching the proc" do
      expect { get "/hello/world" }.not_to \
        increment_yabeda_counter(Yabeda.rails.requests_total)
    end
  end

  context "with custom group name" do
    around do |example|
      original_group_name = described_class.config.group_name
      described_class.config.group_name = :custom_group

      reset_and_reinstall_rails_metrics!
      example.call
    ensure
      described_class.config.group_name = original_group_name
      reset_and_reinstall_rails_metrics!
    end

    it "reports metrics in the custom group" do
      expect { get "/hello/world" }.to \
        increment_yabeda_counter(Yabeda.custom_group.requests_total).
        with_tags(controller: "hello", action: "world", status: 200, method: "get", format: :html).
        by(1)
    end
  end

  def reset_and_reinstall_rails_metrics!
    ActiveSupport::Notifications.notifier.listeners_for("process_action.action_controller").each do |listener|
      ActiveSupport::Notifications.unsubscribe(listener)
    end

    Yabeda.reset!
    Yabeda.register_adapter(:test, Yabeda::TestAdapter.instance)

    Yabeda::Rails.install!
    Yabeda.configure!
  end
end
