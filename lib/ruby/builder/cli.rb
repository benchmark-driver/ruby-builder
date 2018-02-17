require 'thor'

module Ruby
  module Builder
    class CLI < Thor
      class_option :source_directory, type: :string, aliases: %w[-d]

      desc 'revision rXXXXX..rXXXXX', 'Build ruby binaries per revision'
      def revision(spec)
      end
    end
  end
end
