require 'immutable-struct'

module Ruby
  module Builder
    Revision = ImmutableStruct.new(
      :name, # @param [String] - "r62445"
    )
  end
end
