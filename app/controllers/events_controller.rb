class EventsController < ApplicationController
  layout 'theme'

  expose(:gritter_image_url) do
    System::GetAssetFilesUrls.get_image_url('theme/ui-sam.jpg')
  end

  expose(:events) do
    ActiveModel::ArraySerializer.new(
      current_user.events,
      each_serializer: EventSerializer
    )
  end

  def index
  end

  def create
    render json: {}, status: :ok
  end

  def update
    render json: {}, status: :ok
  end

  def destroy
  end
end
