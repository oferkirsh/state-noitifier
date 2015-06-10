require "state/notifier/version"

module State
  module Notifier
    extend ActiveSupport::Concern

    def notify_targets(event)
      custom_subclasses = {
        'custom_rails_admin/approved_funz' => 'funz',
        'custom_rails_admin/unapproved_funz' => 'funz'
      }

      name = self.class.name.underscore
      if custom_subclasses[name]
        name = custom_subclasses[name]
        klass = self.class.superclass
      else
        klass = self.class
      end
      method = [name, event] * '_'
      targets = klass.notification_targets.map do |m|
        m.is_a?(Symbol) ? send(m) : m
        end.flatten
        Rails.logger.debug "StateNotifier: notifying #{method}, #{targets.size} targets"     
      targets.each do |t|
        t.send(method, self) if t.respond_to?(method)
      end
    end

    def notify_transition(transition)
      notify_targets transition.event
      unless transition.to == transition.from
        notify_targets transition.to
        notify_targets "#{transition.from}_#{transition.event}"
        notify_targets "#{transition.event}_#{transition.to}"
        notify_targets "#{transition.from}_#{transition.to}"
        notify_targets "#{transition.from}_#{transition.event}_#{transition.to}"
        notify_targets :state_changed
      end
    end

    included do
      after_create {notify_targets :created}
      after_update {notify_targets :updated  unless (changed - self.class.reserved_attributes).empty?}
      if respond_to?(:state_machines) && respond_to?(:state_machine)
        state_machines.keys.each do |machine|
          state_machine machine do
            after_transition { |record, transition| record.notify_transition transition }
          end
        end
      end
    end

    module ClassMethods
      def notification_targets(*values)
        if values.present?
          @notification_targets = values
        else
          @notification_targets
        end
      end

      def reserved_attributes
        %w[created_at updated_at state]
      end
    end
  end
end
