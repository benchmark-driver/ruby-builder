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
        File.join(rbenv_root, 'versions', version)
      end

      private

      def rbenv_root
        return @rbenv_root if defined?(@rbenv_root)

        @rbenv_root = IO.popen(['rbenv', 'root'], &:read).rstrip
        unless $?.success?
          abort "Failed to execute (exit status: #{$?}): rbenv root"
        end
        @rbenv_root
      end
    end
  end
end
