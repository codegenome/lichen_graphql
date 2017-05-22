module LichenGraphql
  class PermissionAssertion

    attr_accessor :type, :resolve_func

    def initialize(type, resolve_func)
      @type = type
      @resolve_func = resolve_func
    end

    def call(obj, args, ctx)
      resolve_func.call(obj, args, ctx)
    end

  end
end
