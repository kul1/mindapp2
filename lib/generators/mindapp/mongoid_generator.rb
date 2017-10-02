module Mindapp
  module Generators
    class MongoidGenerator < Rails::Generators::Base
      desc "Set up mongoid config"
      def setup_mongoid
        generate "mongoid:config"
        inject_into_file 'config/mongoid.yml', :after => '  # raise_not_found_error: true' do
          "\n    raise_not_found_error: false"
        end

        inject_into_file 'config/mongoid.yml', :after => '  # belongs_to_required_by_default: true' do
          "\n    belongs_to_required_by_default: false"
        end
        inject_into_file 'config/mongoid.yml', :after => '  # app_name: MyApplicationName' do
          "\n\nproduction:" +
              "\n  clients:" +
              "\n    default:" +
              "\n      uri: <%= ENV['MONGODB_URI'] %>" +
              "\n  options:" +
              "\n    raise_not_found_error: false" +
              "\n    belongs_to_required_by_default: false\n"
        end
      end
      def finish
        puts "Mongoid finished configured for rails 5 and heroku.\n"
        puts "Next: To set up user/password as admin/secret\n"
        puts "Please run the following command:\n"
        puts "----------------------------------------\n"
        puts "rake mindapp:seed\n"
        puts "----------------------------------------\n"
      end
    end
  end
end

