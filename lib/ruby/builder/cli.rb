require 'logger'
require 'thor'
require 'ruby/builder/rbenv'
require 'ruby/builder/revision_parser'
require 'ruby/builder/ruby_builder'

module Ruby
  module Builder
    class CLI < Thor
      class_option :source_directory, type: :string, aliases: %w[-d]

      desc 'revision rXXXXX..rXXXXX', 'Build ruby binaries per revision'
      def revision(spec)
        source_dir = File.expand_path(options.fetch(:source_directory, Dir.pwd))

        logger.info "Parsing revisions at '#{source_dir}'..."
        revisions = RevisionParser.new(source_dir).parse(spec)

        if revisions.empty?
          logger.error "No revisions found for '#{spec}' in: #{source_dir}"
          exit 1
        end

        logger.info "Starting to build #{spec} (#{revisions.size} revisions) from '#{source_dir}'"
        Dir.mktmpdir("ruby-builder-") do |build_dir|
          preserve_revision(source_dir) do
            build_revisions(revisions, source_dir: source_dir, build_dir: build_dir)
          end
        end
      end

      private

      def build_revisions(revisions, source_dir:, build_dir:)
        revisions.each_with_index do |revision, i|
          if Rbenv.installed?(revision.name)
            logger.info "Skipped to install #{revision.name} (#{i + 1}/#{revisions.size}): already installed"
            next
          end

          install_dir = Rbenv.directory(revision.name)
          begin
            RubyBuilder.build(revision, source_dir: source_dir, build_dir: build_dir, install_dir: install_dir)
          rescue BuildFailure => e
            logger.error "Failed to install #{revision.name} (#{i + 1}/#{revisions.size}): #{e.class}: #{e.message}"
          else
            logger.info "Succeeded to install #{revision.name} (#{i + 1}/#{revisions.size}) to '#{install_dir}'"
          end
        end
      end

      def preserve_revision(source_dir, &block)
        command = ['git', '-C', source_dir, 'rev-parse', '--abbrev-ref', 'HEAD']
        orig_rev = IO.popen(command, &:read).rstrip
        unless $?.success?
          abort "Failed to execute '#{command.shelljoin}'"
        end
        block.call
      ensure
        if orig_rev
          checkout_cmd = ['git', '-C', source_dir, 'checkout', orig_rev].shelljoin
          logger.info("+ #{checkout_cmd}")
          unless system(checkout_cmd)
            abort "Failed to execute '#{checkout_cmd}'"
          end
        end
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
