class Users::EventsController < ApplicationController
  layout 'theme'

  before_action :fetch_prev_event_attrs, only: [ :update ]

  expose(:events) do
    serialize(current_user.events)
  end

  expose(:event) do
    current_user.events.find_by_id(params[:id])
  end

  expose(:event_eliminator) do
    Events::Eliminator.new(event)
  end

  expose(:event_settings_creator) do
    Events::SettingsCreator.new(event)
  end

  expose(:event_settings_updator) do
    Events::SettingUpdator.new(event, @prev_event_attr)
  end

  def create
    self.event = current_user.events.new(event_params)

    if event.save
      repeated_event = event_settings_creator.run

      render json: {
        event: serialize(event),
        repeated_event: serialize(repeated_event)
      }, status: :ok
    else
      errors_response
    end
  end

  def update
    if event.update(event_params)
      repeated_event = event_settings_updator.run

      render json: {
        event: serialize(event),
        repeated_event: serialize(repeated_event)
      }, status: :ok
    else
      errors_response
    end
  end

  def destroy
    if event_eliminator.success?
      self.event = event_eliminator.run

      render json: { repeated_event: serialize(event) }, status: :ok
    else
      errors_response
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title,
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

  def serialize(event)
    ActiveModel::ArraySerializer.new(event,
                                     each_serializer: EventSerializer)
  end

  def errors_response
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def errors
    if event.present?
      event.errors.full_messages
    else
      empty_message
    end
  end

  def empty_message
    [
      I18n.t(:activerecord)[:models][:event] + ' ' +
      I18n.t(:errors)[:messages][:empty]
    ]
  end
end
