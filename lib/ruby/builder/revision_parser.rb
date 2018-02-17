require 'ruby/builder/revision'

module Ruby
  module Builder
    class << RevisionParser = Module.new
      # @param [String] spec
      # @param [String] source_dir
      def parse(spec, source_dir:)
        unless match = spec.match(/\Ar(?<beg_rev>\d+)\.\.r(?<end_rev>\d+)\z/)
          abort "Invalid revision specification '#{spec}': Doesn't match 'rXXXXX..rXXXXX'"
        end

        beg_rev = Integer(match[:beg_rev])
        end_rev = Integer(match[:end_rev])
        if end_rev < beg_rev
          abort "Invalid revision specification '#{spec}': #{beg_rev} is larger than #{end_rev}"
        end

        []
      end
    end
  end
end
