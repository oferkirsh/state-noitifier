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

    class Event
      belongs_to :provider, ...
      has_many :participants, ...

      include StateNotifier
      notification_targets :provider, :participants

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
