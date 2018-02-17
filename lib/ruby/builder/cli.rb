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
        revisions.each_with_index do |revision, i|
          if Rbenv.installed?(revision.name)
            logger.info "Skipped to install #{revision.name}: already installed"
            next
          end

          install_dir = Rbenv.directory(revision.name)
          RubyBuilder.build(revision, install_dir: install_dir)
          logger.info "Succeeded to install #{revision.name} (#{i + 1}/#{revisions.size}): #{install_dir}"
        end
      end

      private

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
