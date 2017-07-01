# Mindapp
##Basic Concept for Mindapp
*  Branch c241510
### Hash

  
[Hash](https://richonrails.com/articles/working-with-ruby-hashes)

    Mindapp::Xmain.create :service=>service,
                          :start=>Time.now,
                          :name=>service.name,
                          :ip=> get_ip,
                          :status=>'I', # init
                          :user=>current_user,
                          :xvars=> {
                              :service_id=>service.id,
                              :p=>params.to_unsafe_h,
                              :id=>params[:id],
                              :user_id=>current_user.try(:id),
                              :custom_controller=>custom_controller,
                              :host=>request.host,
                              :referer=>request.env['HTTP_REFERER']
                          }

This is how Mindapp created hash. It using this format

    {:ruby => "hashes"}

    {ruby: "hashes"}

    h = {ruby: "hashes"}

    h[:ruby] # return "hashes"

 so Mindapp using: 

    :start=>Time.now

and 

    :xvars=> {
       :service_id=>service.id,
       :p=>params.to_unsafe_h
    }

Finally, you can use the new Ruby syntax of placing the colon (:) to the right instead of the left.

    xvars: {
        service_id: service.id
        p: param.to_unsafe_h
    }

    xvars[service_id] #return value service.id


| Style    |        Sample       |  Cool |
|----------|     :-------------: |------:|
|    ruby  |  :ruby => "hashes"  | :xvars=> {:service_id=>service_id |
|   rails  |   ruby:   "hashes"  |  xvars:  {service_id: service_id} |
|  Mindapp |        h[:ruby]     |  xmain[:xvars[:service_id]]  ?????|

Sample:

    def end_output
      init_vars(params[:xmain_id])
      end_action
    end

 Tip
Here how to call value of hash in hash

    h1 = {'h2.1' => {'foo' => 'this', 'cool' => 'guy'}, 'h2.2' => {'bar' => '2000'} }
    h1['h2.1'] # => {'foo' => 'this', 'cool' => 'guy'}
    h1['h2.2'] # => {'bar' => '2000'}
    h1['h2.1']['foo'] # => 'this'
    h1['h2.1']['cool'] # => 'guy'
    h1['h2.2']['bar'] # => '2000'

In Mindapp enter_user.html.erb

    $xvars["enter"]["npass_confirm"]

 Tip 
(@var) are just a way to store a value between methods of one instance of one class:

    class Calculator
      @counter = 0
      def inc
        @counter += 1
      end
      def dec
        @counter -= 1
      end
    end


Mindapp: mindapp_controller.rb assign @xvar as:  

    @xvars['total_steps']= i
    @xvars['total_form_steps']= j

Mindapp: use in view enter_user.html.erb  to get values for users_controllers.rb

    def update_user
      # can't use session, current_user inside mindapp methods
      $user.update_attribute :email, $xvars["enter_user"]["user"]["email"]
    end

## Changelog

* v0.0.8 update for Rails 5

## Prerequisites

These versions works for sure but others may do.

* Ruby 2.4.1
* Rails 5.1.0.rc2
* MongoDB 6
* Freemind 1.0.1

