class EventsController < ApplicationController
  layout 'theme'

  expose(:events) do
    ActiveModel::ArraySerializer.new(
      current_user.events,
      each_serializer: EventSerializer
    )
  end

  expose(:event_ser) do
    ActiveModel::ArraySerializer.new(
      [event],
      each_serializer: EventSerializer
    )
  end

  expose(:event) do
    current_user.events.find_by_id(params[:id])
  end

  expose(:errors) do
    if event
      event.errors.full_messages
    else
      [Event.empty_event_message]
    end
  end

  expose(:errors_response) do
    render json: { errors: errors }, status: :unprocessable_entity
  end

  expose(:run_notifies) do
    puts "prev_starts_at #{@prev_starts_at}"
    puts "current starts_at #{event.starts_at}"
    puts "event.starts_at != @prev_starts_at #{event.starts_at != @prev_starts_at}"
    if !@prev_starts_at || event.starts_at != @prev_starts_at
      Events::EventNotifications.new(current_user, event)
    end
  end

  def index
  end

  def create
    self.event = current_user.events.new(event_params)
    create_or_update(event.save)
  end

  def update
    @prev_starts_at = event.starts_at
    create_or_update(event.update(event_params))
  end

  def destroy
    if event
      event.destroy
      render json: nil, status: :ok
    else
      errors_response
    end
  end

  private
  def event_params
    params.require(:event).permit(:title,
                                  :starts_at,
                                  :ends_at,
                                  :all_day)
  end

  def create_or_update(call_method)
    if event && call_method
      run_notifies
      render json: { event: event_ser }, status: :ok
    else
      errors_response
    end
  end
end
