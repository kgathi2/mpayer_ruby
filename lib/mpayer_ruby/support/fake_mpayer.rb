require 'sinatra/base'
require 'tilt/erb'

class FakeMpayer < Sinatra::Base

  [ :get, :post, :put, :delete ].each do |method|
    send method, /.*/ do 
      if (request.env['HTTP_X_WSSE'].empty? rescue true)
        [200, {}, [{base:["Authentication Failed"]}.to_json]]
      else
        slash,api,model,*path = request.path_info.split(/\/|\?/)
        json_response 200, "#{model}/#{request.request_method}_#{path.join('_')}.json"
      end
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    headers "content-type"=>["application/json; charset=utf-8"]
    erb File.open(File.dirname(__FILE__) + '/fake_mpayer/' + file_name, 'rb').read
  end
end