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
    current_user.events.find(params[:id])
  end

  expose(:errors) do
    event.errors.full_messages
  end

  def index
  end

  def create
    self.event = current_user.events.new(event_params)
    if event.save
      render json: { event: event_ser }, status: :ok
    else
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    if event.update(event_params)
      render json: { event: event_ser }, status: :ok
    else
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def event_params
    params.require(:event).permit(:title,
                                  :starts_at,
                                  :ends_at,
                                  :all_day)
  end
end
