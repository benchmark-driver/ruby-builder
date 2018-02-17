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
        execute('git', '-C', source_dir, 'checkout', revision.git)
        unless File.executable?(File.join(source_dir, 'configure'))
          execute('autoreconf', dir: source_dir)
        end

        # Workaround to force updating revision in RUBY_DESCRIPTION
        timestamp_file = File.join(build_dir, '.revision.time')
        if File.exist?(timestamp_file)
          execute('rm', timestamp_file)
        end

        execute(File.join(source_dir, 'configure'), '--disable-install-doc', "--prefix=#{install_dir}", dir: build_dir)
        execute('make', "-j#{Etc.nprocessors}", dir: build_dir)
        execute('make', 'install', dir: build_dir)
      end

      private

      # @param [Array<String>] command
      # @param [String] dir
      def execute(*command, dir: nil)
        if dir
          Dir.chdir(dir) do
            assert_execute(*command, dir: dir)
          end
        else
          assert_execute(*command, dir: dir)
        end
      end

      # @param [Array<String>] command
      def assert_execute(*command, dir:)
        logger.info("+ #{command.shelljoin}")
        unless system(command.shelljoin)
          dir_info = "at '#{dir}' " if dir
          raise BuildFailure.new("Failed to execute '#{command.shelljoin}' #{dir_info}(exit status: #{$?.exitstatus})")
        end
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
