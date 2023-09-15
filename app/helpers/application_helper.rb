module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.append "flash", partial: "flash"
  end

  def bg_if(controller_name)
    return 'bg-secondary' if controller_name == params[:controller]
  end

  def link_color_if(controller_name)
    if controller_name == params[:controller]
      'link-light' 
    else
      'link-dark'
    end
  end
end
