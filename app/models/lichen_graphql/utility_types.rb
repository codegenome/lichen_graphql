module LichenGraphql
  module UtilityTypes

    def self.find_or_create_enumerated_type
        @enum_type ||= ::GraphQL::ObjectType.define do
          name 'EnumeratedType'
          description 'Type for enumerated attributes'
          field :label, types.String do
            resolve ->(obj, args, ctx) {
              obj[:label]
            }
          end
          field :key, types.String do
            resolve ->(obj, args, ctx) {
              obj[:key]
            }
          end
          field :code, types.Int do
            resolve ->(obj, args, ctx) {
              obj[:code]
            }
          end
        end
      end

  end
end
