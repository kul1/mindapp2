module Mindapp
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install mindapp component to existing Rails app "
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      def setup_routes
        route "root :to => 'mindapp#index'"
        route "mount Ckeditor::Engine => '/ckeditor'"
        route "resources :identities"
        route "resources :sessions"
        route "resources :password_resets"
        route "post '/auth/:provider/callback' => 'sessions#create'"
        route "get '/auth/:provider/callback' => 'sessions#create'"
        route "get '/auth/failure' => 'sessions#failure'"
        route "get '/logout' => 'sessions#destroy', :as => 'logout'"
        route "get ':controller(/:action(/:id))(.:format)'"
        route "post ':controller(/:action(/:id))(.:format)'"
      end

      def setup_env
        create_file 'README.md', ''
        inject_into_file 'config/application.rb', :after => 'require "active_resource/railtie"' do
          "\nrequire 'mongoid/railtie'\n"
          "\nrequire 'rexml/document'\n"
        end
        application do
%q{
  # Mindapp default
  config.generators do |g|
    g.orm             :mongoid
    g.template_engine :haml
    g.test_framework  :rspec
    g.integration_tool :rspec
  end
  # gmail config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => 'user@gmail.com',
    :password             => 'secret',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
}
        end
        initializer "mindapp.rb" do
%q{# encoding: utf-8
MM = "#{Rails.root}/app/mindapp/index.mm"
DEFAULT_TITLE = 'Mindapp2'
DEFAULT_HEADER = 'Mindapp2'
DEFAULT_DESCRIPTION = 'Rails Application Generator'
DEFAULT_KEYWORDS = %w[Mindapp2 Rails ruby Generator]
GMAP = false
ADSENSE = true
NEXT = "Next >"
# comment IMAGE_LOCATION to use cloudinary (specify params in config/cloudinary.yml)
IMAGE_LOCATION = "upload"
# for debugging
# DONT_SEND_MAIL = true
}
        end

initializer "mongoid.rb" do
%q{# encoding: utf-8
#
# Mongoid 6 follows the new pattern of AR5 requiring a belongs_to relation to always require its parent
# belongs_to` will now trigger a validation error by default if the association is not present.
# You can turn this off on a per-association basis with `optional: true`.
# (Note this new default only applies to new Rails apps that will be generated with
# `config.active_record.belongs_to_required_by_default = true` in initializer.)
#
Mongoid::Config.belongs_to_required_by_default = false
}
        end

        inject_into_file 'config/environment.rb', :after => "initialize!"  do
          "\n\n# hack to fix cloudinary error https://github.com/archiloque/rest-client/issues/141" +
          "\nclass Hash\n  remove_method :read\nrescue\nend"
        end
        inject_into_file 'config/environments/development.rb', :after => 'config.action_mailer.raise_delivery_errors = false' do
          "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
        end
        inject_into_file 'config/environments/production.rb', :after => 'config.assets.compile = false' do
          "\n  config.assets.compile = true"
        end
        inject_into_file 'config/initializers/assets.rb', :after => '# Precompile additional assets.
' do        
"Rails.application.config.assets.precompile += %w( sarabun.css )" +
"\nRails.application.config.assets.precompile += %w( disable_enter_key.js )\n"
        end
      end

      def setup_omniauth
        # gem 'bcrypt-ruby', '~> 3.0.0'
        # gem 'omniauth-identity'
        initializer "omniauth.rb" do
%q{
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
    :fields => [:code, :email],
    :on_failed_registration=> lambda { |env|
      IdentitiesController.action(:new).call(env)
  }
  provider :facebook, ENV['FACEBOOK_API'], ENV['FACEBOOK_KEY']
end
}
        end
      end

      def setup_app
        inside("public") { run "mv index.html index.html.bak" }
        inside("app/views/layouts") { run "mv application.html.erb application.html.erb.bak" }
        inside("app/assets/javascripts") { run "mv application.js application.js.bak" }
        inside("app/assets/stylesheets") { run "mv application.css application.css.bak" }
        directory "app"
      end

      def gen_user
        # copy_file "seeds.rb","db/seeds.rb"
      end

      def gen_image_store
        copy_file "cloudinary.yml","config/cloudinary.yml"
        copy_file ".env",".env"

        empty_directory "upload" # create upload directory just in case
      end

      def setup_gems
        gem 'maruku', '~> 0.7.3'
        gem 'rouge'
        gem 'normalize-rails'
        gem 'font-awesome-rails'
        gem 'ckeditor', github: 'galetahub/ckeditor'
        gem 'mongoid-paperclip', require: 'mongoid_paperclip'
        gem 'meta-tags'
        gem 'jquery-turbolinks'

        gem 'mongo', '~> 2.2'
        gem 'bson', '~> 4.0'
        gem 'mongoid', github: 'mongodb/mongoid'
        # gem "mongoid"
        gem 'nokogiri' # use for mindapp/doc
        gem 'haml', git: 'https://github.com/haml/haml'
        gem 'haml-rails'
        gem 'mail'
        gem 'prawn'
        gem 'redcarpet'
        gem 'bcrypt-ruby'
        gem 'omniauth-identity'
        gem 'omniauth-facebook'
        gem 'dotenv-rails'
        gem 'cloudinary'
        gem 'kaminari'
        gem 'kaminari-mongoid'
        gem 'jquery-rails'
        gem_group :development, :test do
          gem "rspec"
          gem "rspec-rails"
          gem "better_errors"
          gem "binding_of_caller"
          gem 'pry-byebug'
        end
      end

# gem 'ckeditor', github: 'galetahub/ckeditor'      
# rails generate ckeditor:install --orm=mongoid --backend=paperclip
      def setup_ckeditor
        initializer "ckeditor.rb" do
%q{# gem 'ckeditor', github: 'galetahub/ckeditor'      
Ckeditor.setup do |config|
  require 'ckeditor/orm/mongoid'
end  
}  
        end            
      end

      def finish
        puts "Mindapp installation finish, please run the following command:\n"
        puts "----------------------------------------\n"
        puts "bundle install\n"
        puts "rails generate mindapp:mongoid\n"
        puts "----------------------------------------\n"
      end

    end
  end
end
