module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.append "flashes", partial: "shared/flash"
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

  def active_if(controller_name)
    return 'active' if controller_name == params[:controller]
  end

  def show_meta_tags
    assign_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end

  def assign_meta_tags(options = {})
    defaults = t('meta_tags.defaults')
    options.reverse_merge!(defaults)
    site = options[:admin] ? "[Admin]#{t('site.name')}" : t('site.name')
    description = t('site.description')
    title = options[:title]
    image = image_url('OGP.png')
    configs = {
      separator: '|',
      reverse: true,
      site:,
      title:,
      description:,
      keywords: %w[コーヒー豆 レビュー 購入記録 コーヒー豆販売店検索],
      canonical: request.original_url,
      icon: {
        href: image_url('placeholder.png')
      },
      og: {
        type: 'website',
        title: title.presence || site,
        description:,
        url: request.original_url,
        image:,
        site_name: site
      },
      twitter: {
        site:,
        card: 'summary_large_image',
        image:
      }
    }
    set_meta_tags(configs)
  end
end
