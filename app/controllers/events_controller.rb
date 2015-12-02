class EventsController < ApplicationController
  layout 'theme'
  before_action :fetch_prev_event_attrs, only: [ :update ]

  expose(:recurring_with_notifications) do
    Events::RecurringWithNotifications.new(event,
                                            action_name,
                                            @prev_event_attr)
  end

  expose(:errors) do
    if event
      event.errors.full_messages
    else
      [event.empty_message]
    end
  end

  expose(:errors_response) do
    render json: { errors: errors }, status: :unprocessable_entity
  end

  expose(:success_response) do
    res = { repeated_event: after_processing_event_action }
    if action_name == 'destroy'
      res
    else
      res[:event] = serialize_events(event)
    end
    res
  end

  def index
  end

  def create
    self.event = current_user.events.new(event_params)
    handle_event_actions(event.save)
  end

  def update
    handle_event_actions(event.update(event_params))
  end

  def destroy
    handle_event_actions(true)
  end

  private

  def event_params
    params.require(:event).permit(:title,
                                  :starts_at,
                                  :ends_at,
                                  :repeat_type,
                                  :all_day)
  end

  def fetch_prev_event_attrs
    @prev_event_attr = {
      starts_at: event.starts_at,
      repeat_type: event.repeat_type,
      updated_at: event.updated_at
    }
  end

  def handle_event_actions(call_method)
    if event && call_method
      render json: success_response, status: :ok
    else
      errors_response
    end
  end

  def after_processing_event_action
    serialize_events(recurring_with_notifications.base_handle)
  end
end
