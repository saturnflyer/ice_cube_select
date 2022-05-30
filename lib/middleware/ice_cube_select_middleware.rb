require "ice_cube"

class IceCubeSelectMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    regexp = /^\/ice_cube_select\/translate\/(.*)/
    if env["PATH_INFO"] =~ regexp
      I18n.locale = env["PATH_INFO"].scan(regexp).first.first
      request = Rack::Request.new(env)
      params = request.params
      params.symbolize_keys!

      if params and params[:rule_type]
        rule = IceCubeSelect.dirty_hash_to_rule(params)
        [200, {"Content-Type" => "text/html"}, [rule.to_s]]
      else
        [200, {"Content-Type" => "text/html"}, [""]]
      end
    else
      @app.call(env)
    end
  end

end
