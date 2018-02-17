require 'ruby/builder/revision'

module Ruby
  module Builder
    class << Rbenv = Module.new
      # @param [String] version
      def installed?(version)
        File.directory?(directory(version))
      end

      # @param [String] version
      def directory(version)
        require "pry";binding.pry
      end
    end
  end
end
