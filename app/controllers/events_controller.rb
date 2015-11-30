class EventsController < ApplicationController
  layout 'theme'

  expose(:events) do
    serialize_events(current_user.events)
  end

  expose(:event) do
    current_user.events.find_by_id(params[:id])
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

  expose(:recurring) do
    Events::Recurring.new(current_user, event, action_name).res
  end

  expose(:recurring_event_interactions) do
    if action_name == "create"
      Rails.logger.info"ON CREATE #{action_name}"
      Events::Notifications.new(event)
      event.delay_creating_clone! if event.repeat_type != "not_repeat"

    elsif (starts_at_changed || repeat_type_changed)
      Rails.logger.info"ON UPDATE #{action_name}"
      recurring
    end
  end

  def index
  end

  def create
    self.event = current_user.events.new(event_params)
    create_or_update(event.save)
  end

  def update
    fetch_prev_event_attr
    create_or_update(event.update(event_params))
  end

  def destroy
    if event
      repeated_event = serialize_events(recurring)
      render json: { repeated_event: repeated_event }, status: :ok
    else
      errors_response
    end
  end

  private

  def event_params
    params.require(:event).permit(:title,
                                  :starts_at,
                                  :ends_at,
                                  :repeat_type,
                                  :all_day)
  end

  def starts_at_changed
    event.starts_at != @prev_starts_at
  end

  def repeat_type_changed
    event.repeat_type != @prev_repeat_type
  end

  def fetch_prev_event_attr
    @prev_starts_at = event.starts_at
    @prev_repeat_type = event.repeat_type
  end

  def create_or_update(call_method)
    if event && call_method
      repeated_event = serialize_events(recurring_event_interactions)

      render json: {

        event: serialize_events(event),
        repeated_event: repeated_event

      }, status: :ok
    else
      errors_response
    end
  end

  def serialize_events(current_event_or_events)
    ActiveModel::ArraySerializer.new(
      [current_event_or_events].flatten,
      each_serializer: EventSerializer
    )
  end
end
