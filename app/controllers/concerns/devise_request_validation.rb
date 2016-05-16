module Concerns
  module DeviseRequestValidation
    extend ActiveSupport::Concern

    included do
      before_action :html?, only: [ :new, :create ]
    end

    private

    def html?
      if request.format.html?
        redirect_to root_path
      end
    end
  end
end
