require "ice_cube"

class IceCubeSelectMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    regexp = /^\/ice_cube_select\/translate\/(.*)/
    if env["PATH_INFO"]&.match?(regexp)
      I18n.locale = env["PATH_INFO"].scan(regexp).first.first
      request = Rack::Request.new(env)
      params = request.params.to_h.transform_keys(&:to_sym)

      if params && params[:rule_type]
        rule = IceCubeSelect.dirty_hash_to_rule(params)
        [200, {"content-type" => "text/html"}, [rule.to_s]]
      else
        [200, {"content-type" => "text/html"}, [""]]
      end
    else
      @app.call(env)
    end
  end
end
