require 'ruby/builder/revision'
require 'shellwords'

module Ruby
  module Builder
    class RevisionParser
      # @param [String] source_dir
      def initialize(source_dir)
        @source_dir = source_dir
      end

      # @param [String] spec
      def parse(spec)
        unless match = spec.match(/\Ar(?<beg_rev>\d+)(\.\.r(?<end_rev>\d+))?\z/)
          abort "Invalid revision specification '#{spec}': Doesn't match 'rXXXXX' or 'rXXXXX..rXXXXX'"
        end

        beg_rev = Integer(match[:beg_rev])
        end_rev = Integer(match[:end_rev] || beg_rev)
        if end_rev < beg_rev
          abort "Invalid revision specification '#{spec}': #{beg_rev} is larger than #{end_rev}"
        end

        # Note: ruby-builder currently supports only trunk revisions
        trunk_revs = (beg_rev..end_rev).select { |rev| trunk_revision?(rev) }
        trunk_revs.map! do |rev|
          build_revision(rev)
        end
      end

      private

      # @param [Integer] rev
      def trunk_revision?(rev)
        command = ['git', '-C', @source_dir, 'log', '--grep', "/trunk@#{rev} ", '-1']
        result = IO.popen(command, &:read)
        unless $?.success?
          abort "Failed to execute (exit status: #{$?.exitstatus}): #{command.shelljoin}"
        end
        !result.empty?
      end

      # @param [Integer] rev
      def build_revision(rev)
        command = ['git', '-C', @source_dir, 'log', '--grep', "/trunk@#{rev} ", '--format=format:%H', '-1']
        git_revision = IO.popen(command, &:read)
        unless $?.success?
          abort "Failed to execute (exit status: #{$?.exitstatus}): #{command.shelljoin}"
        end
        Revision.new(svn: rev, git: git_revision)
      end
    end
  end
end
