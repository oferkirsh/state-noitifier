require "state_notifier/version"

module StateNotifier
  extend ActiveSupport::Concern

  def notify_targets(event)
    name = self.class.name.underscore
    method = [name, event] * '_'

    targets = self.class.notification_targets.map {|m| send(m)}.flatten
    Rails.logger.debug "StateNotifier: notifying #{method}, #{targets.size} targets"

    targets.each do |t|
      t.send(method, self) if t.respond_to?(method)
    end
  end

  def notify_transition(transition)
    notify_targets transition.event
    notify_targets transition.to unless transition.to == transition.from
  end

  included do
    after_create {notify_targets :created}
    after_update {notify_targets :updated  unless (changed - self.class.reserved_attributes).empty?}
    if respond_to?(:state_machine)
      state_machine do
        after_transition { |record, transition| record.notify_transition transition }
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
