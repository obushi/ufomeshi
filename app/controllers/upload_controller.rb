class UploadController < application_controller
  skip_before_filter: verify_authenticity_token, only: :new

  def new
  end
end
