module UserTrackable
  extend ActiveSupport::Concern

  included do
    belongs_to :created_by, class_name: "User", optional: true
    belongs_to :updated_by, class_name: "User", optional: true

    before_create do
      self.created_by = User.current_user if User.current_user
    end

    before_save do
      self.updated_by = User.current_user if User.current_user
    end
  end
end
