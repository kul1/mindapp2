class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # https://www.cookieshq.co.uk/posts/easy-seo-metatags-with-rails-4#a-word-about-turbolinks
  before_action :prepare_meta_tags, if: -> { request.get? }
  def prepare_meta_tags(options={})
    site_name   = "Mindapp2"
    title       = [controller_name, action_name].join(" ")
    description = "Mindapp2 Tools to create visual programming using Freemind by Prateep Kul & Korakot Leemakdej"
    image       = options[:image] || href="/assets/images/logo.png" 
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    %w[Mindapp2 Rails ruby Prateep Kul],
      twitter: {
        site_name: site_name,
        site: '@4dcity.com',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
end
