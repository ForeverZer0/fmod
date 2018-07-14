# ![LOGO](https://upload.wikimedia.org/wikipedia/de/c/c9/Fmod-logo.svg)


[![Gem Version](https://badge.fury.io/rb/fmod.svg)](https://badge.fury.io/rb/fmod) ![Documentation](https://img.shields.io/badge/Documentation-99.22%25-green.svg)


A full-featured and complete Ruby wrapper of the ultra-powerful FMOD Low-Level API. Uses the built-in Fiddle library (Ruby 2.0+) to eliminate unnecessary external gem dependencies, all that is needed is the native FMOD platform-specific native FMOD libraries.

Supports a host of audio formats including:
* Audio Interchange File Format (.aiff )
* Advanced Systems Format (.asf)
* Advanced Stream Redirector (.asx)
* Downloadable Sound (.dls)
* Free Loss-less Audio Codec (.flac)
* FMOD Sound Bank (.fsb)
* Impulse Tracker (.it)
* MPEG Audio Layer 3 URL (.m3u)
* Musical Instrument Digital Interface (.mid, .midi)
* Module Format (.mod)
* MPEG Audio Layer 2 (.mp2)
* MPEG Audio Layer 3 (.mp3)
* OGG Vorbis (.ogg)
* Playlist (.pls)
* ScreamTracker 3 Module (.s3m )
* PS2/PSP Format (.vag )
* Waveform Audio File Forma (.wav )
* Windows Media Audio Redirector (.wax )
* Windows Media Audio (.wma )
* Extended Module (.xm )
* Windows Media Audio (Xbox 360) (.xma)
   
FMOD is most widely known for its application in video games for sound effects, as it fully supports 3D sound, and can be found in all popular video game consoles (Sony, Microsoft, and Nintendo), as well as a large number of popular PC and mobile games. This is not a restriction by any means, though, and it functions just as well for any audio back-end in your Ruby application, even providing the core functionality to a full-fledged audio player, as it supports such a wide array of formats.

Built-in is a large collection of audio effects that can be applied to a sound, including various equalizers, advanced reverb environments, pitch-shifting, frequency, flange, chorus, and many, many more. Sound manipulation is where FMOD really shines, and places it as an industry standard on nearly all platforms.

The wrapper supports callbacks for various events, such as sync-points in wave files, sound playback ending (either by user or end of data), and various other scenarios.  It additionally supports access to raw PCM data directly from the sound card, for creating visualizations or examining the sound in real-time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fmod'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fmod

As of version 0.9.3, the external dependencies are no longer bundled with the gem, but are readily available [here](https://github.com/ForeverZer0/fmod/tree/master/extras) (these are the versions the gem was built against). Alternatively, you may download the external libraries directly from the [FMOD website](https://www.fmod.com/download) (free registration required). Place the platform-specific binaries within the working directory, or in directory of your choice and use `FMOD.load_library` to initialize the gem.

## Usage

Including in the `/extras` folder (no longer bundled with the gem as of version `0.9.3`, but found [here on GitHub](https://github.com/ForeverZer0/fmod/tree/master/extras)) is the compiled help documentation for the actual FMOD library, which can be helpful for understanding how the API works if you are unfamiliar.

Those who are familiar with FMOD will find the structure and syntax familiar, though performed in the object-oriented "Ruby" way.  All base core FMOD data types have been created as classes, and mostly share the same names with their C counterpart though in Ruby "snake_case" style as opposed to "UpperCamelCase".  Being object-oriented each class is wrapped around using the functions that relate to it, and doesn't require the use of passing pointers or the object to the methods.

So creating and working with objects has been simplified..

```ruby
require 'fmod'

FMOD.load_library

system = FMOD::System.create
sound = system.create_sound("./myFile.mp3")
sound.play  
``` 

Each get/set method in the FMOD API has been converted to an "attribute" that can be accessed in the Ruby way. So instead of`FMOD_Channel_GetVolume` and `FMOD_Channel_SetVolume`, it is simply `channel.volume` and `channel.volume = value`. 

## Future Releases

There is still yet to be a few areas that need completed, and are in active development. Included are the following known issues:
   * FMOD plugin support (including 3rd party codecs)
   * Loading custom sound formats (related to plugin support)
   * Custom file-system support to piggyback and monitor FMOD's read/write callbacks
   * Creation of custom effects (Digital Sound Processors) (also related to plugins)
   
None of these incomplete areas will have any effect on the existing code-base, and existing code will be unaffected by their implementation in future versions.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/ForeverZer0/fmod). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The FMOD library is under a free license for non-commercial use, and a proprietary license otherwise. See the [FMOD License Page](https://www.fmod.com/licensing) for details on pricing if you plan to use this commercially.

## Code of Conduct

Everyone interacting in the FMOD project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ForeverZer0/fmod/blob/master/CODE_OF_CONDUCT.md).
