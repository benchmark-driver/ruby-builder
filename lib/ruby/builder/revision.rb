require 'immutable-struct'

module Ruby
  module Builder
    # @param [Integer] svn
    # @param [String] git
    Revision = ImmutableStruct.new(:svn, :git) do
      def name
        "r#{svn}"
      end
    end
  end
end
