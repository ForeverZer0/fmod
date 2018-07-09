
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fmod/version'

Gem::Specification.new do |spec|
  spec.name          = 'fmod'
  spec.version       = FMOD::VERSION
  spec.authors       = ['Eric "ForeverZero" Freed']
  spec.email         = ['efreed09@gmail.com']
  spec.summary       = %q{Ruby wrapper around the high performance, cross-platform FMOD low-level sound library. You get all the benefits of the FMOD library, but in the object-oriented Ruby way!}
  spec.description   = %q{A full-featured (complete Ruby wrapper) of the ultra-powerful FMOD Low-Level API. Uses the built-in Fiddle library (Ruby 2.0+), and has no external gem dependencies, all that is needed is the native FMOD platform-specific native FMOD libraries (included).

FMOD supports a host of audio formats including:

- Audio Interchange File Format (.aiff )
- Advanced Systems Format (.asf)
- Advanced Stream Redirector (.asx)
- Downloadable Sound (.dls)
- Free Lossless Audio Codec (.flac)
- FMOD Sound Bank (.fsb)
- Impulse Tracker (.it)
- MPEG Audio Layer 3 URL (.m3u)
- Musical Instrument Digital Interface (.mid, .midi)
- Module Format (.mod)
- MPEG Audio Layer 2 (.mp2)
- MPEG Audio Layer 3 (.mp3)
- OGG Vorbis (.ogg)
- Playlist (.pls)
- ScreamTracker 3 Module (.s3m )
- PS2/PSP Format (.vag )
- Waveform Audio File Forma (.wav )
- Windows Media Audio Redirector (.wax )
- Windows Media Audio (.wma )
- Extended Module (.xm )
- Windows Media Audio (Xbox 360) (.xma)

FMOD is most widely known for its application in video games for sound effects, as it fully supports 3D sound, and can be found in all popular video game consoles (Sony, Microsoft, and Nintendo), as well as a large number of popular PC and mobile games. Built-in is a large collection of audio effects that can be applied to a sound, including various equalizers, advanced reverb environments, pitch-shifting, frequency, flange, chorus, and many, many more.

The wrapper supports callbacks for various events, such as sync-points in wave files, sound playback ending (either by user or end of data), and various other scenarios. It additionally supports access to raw PCM data directly from the sound card, for creating visualizations or examining the sound in real-time.}

  spec.homepage      = 'https://github.com/ForeverZer0/fmod'
  spec.license       = 'MIT'
  spec.has_rdoc      = 'yard'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end
