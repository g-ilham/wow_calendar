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

  def index
  end

  def create
    self.event = current_user.events.new(event_params)
    if event.save
      render json: { event: event_ser }, status: :ok
    else
      errors_response
    end
  end

  def update
    if event && event.update(event_params)
      render json: { event: event_ser }, status: :ok
    else
      errors_response
    end
  end

  def destroy
    if event
      event.destroy
      render json: nil, status: :ok
    else
      errors_response
    end
  end

  def event_params
    params.require(:event).permit(:title,
                                  :starts_at,
                                  :ends_at,
                                  :all_day)
  end
end
