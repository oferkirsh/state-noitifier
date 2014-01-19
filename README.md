# State::Notifier

TODO: Simple gem to notify 'subscribers' about record state changes.

## Installation

Add this line to your application's Gemfile:

    gem 'state-notifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state-notifier

## Usage

    `notify_targets(method_name)` will call `<class_name>_<method_name>` on
    every target that supports it (i.e. `responds_to?`). For example, calling
    `notify_target(:foo)` on an `Event` object will call `event_foo` on
    supporting targets.

    `notify_targets` is automatically called with `:created` and `:updated` in
    `after_create` and `after_update` respectively.

    For classes with a state machine the following calls are made:

    - `<event_name>`
    - `<target_state>` - only when its different from previous state
    - `<event_name>_<target_state>` - only when its different from previous state

    class Event
      belongs_to :provider, ...
      has_many :participants, ...

      include State::Notifier
      notification_targets :provider, :participants, EventMailer

      state_machine do
        ...
        state :canceled

        event :cancel do
          transition all => :canceled
        end
      end

      def foo
        notify_targets :foo
      end
    end

    class User
      def event_created
        # called for provider when event created (no participants yet)
      end

      def event_foo
        # custom event
      end

      def event_cancel
        # called on event 'cancel'
      end

      def event_canceled
        # called when transitioning into 'canceled' state.
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
