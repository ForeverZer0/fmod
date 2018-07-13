
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fmod/version'

Gem::Specification.new do |spec|
  spec.name          = 'fmod'
  spec.version       = FMOD::VERSION
  spec.authors       = ['Eric "ForeverZer0" Freed']
  spec.email         = ['efreed09@gmail.com']
  spec.summary       = %q{Ruby wrapper around the high performance, cross-platform FMOD low-level sound library. You get all the benefits of the FMOD library, but in the object-oriented Ruby way!}
  spec.description   = %q{A full-featured and complete Ruby wrapper of the ultra-powerful FMOD Low-Level API. Uses the built-in Fiddle library (Ruby 2.0+) to eliminate unnecessary external gem dependencies, all that is needed is the FMOD platform-specific libraries (included). FMOD supports a host of audio formats including .aiff, .asf, .asx, .dls, .flac, .fsb, .it, .m3u, .mid, .midi, .mod, .mp2, .mp3, .ogg .pls, .s3m , vag, .wav, .wax, .wma, .xm, and .xma.}
  spec.homepage      = 'https://github.com/ForeverZer0/fmod'
  spec.license       = 'MIT'
  spec.has_rdoc      = 'yard'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|.dll|.so|.dylib|.chm)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end
