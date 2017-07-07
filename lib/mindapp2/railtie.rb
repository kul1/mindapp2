require 'mindapp2'
require 'mindapp2/helpers'

module Mindapp
  require 'rails'
  class Railtie < Rails::Railtie
    initializer "testing" do |app|
      ActionController::Base.send :include, Mindapp::Helpers
    end
    rake_tasks do
      load "tasks/mindapp.rake"
    end
  end
end

module ApplicationHelper
  include Mindapp::Helpers
end
