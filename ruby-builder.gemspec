
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby/builder/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-builder'
  spec.version       = Ruby::Builder::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']

  spec.summary       = %q{Build ruby binaries per revision under rbenv directory}
  spec.description   = %q{Build ruby binaries per revision under rbenv directory}
  spec.homepage      = 'https://github.com/benchmark-driver/ruby-builder'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
