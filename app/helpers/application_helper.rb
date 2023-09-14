module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.append "flash", partial: "flash"
  end
end
