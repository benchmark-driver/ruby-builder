require 'logger'
require 'shellwords'
require 'tmpdir'

module Ruby
  module Builder
    BuildFailure = Class.new(StandardError)

    class << RubyBuilder = Module.new
      # @param [Ruby::Builder::Revision] revision
      # @param [String] source_dir
      # @param [String] build_dir
      # @param [String] install_dir
      def build(revision, source_dir:, build_dir:, install_dir:)
        execute('git', 'checkout', revision.git, dir: source_dir)
        unless File.executable?(File.join(source_dir, 'configure'))
          execute('autoreconf', dir: source_dir)
        end
        execute(File.join(source_dir, 'configure'), '--disable-install-doc', "--prefix=#{install_dir}", dir: build_dir)
        execute('make', "-j#{Etc.nprocessors}", dir: build_dir)
        execute('make', 'install', dir: build_dir)
      end

      private

      # @param [Array<String>] command
      # @param [String] dir
      def execute(*command, dir:)
        Dir.chdir(dir) do
          logger.info("+ #{command.shelljoin}")
          unless system(command.shelljoin)
            raise BuildFailure.new("Failed to execute '#{command.shelljoin}' at '#{dir}' (exit status: #{$?.exitstatus})")
          end
        end
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
