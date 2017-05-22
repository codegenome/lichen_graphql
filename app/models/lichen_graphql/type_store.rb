module LichenGraphql
  class TypeStore

    def initialize(type_name, type)
      @@registered_types[type_name] = type
    end

    @@registered_types ||= {}

    def self.registered_types
      @@registered_types
    end

  end
end
