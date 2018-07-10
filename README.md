# FMOD

[![Gem Version](https://badge.fury.io/rb/fmod.svg)](https://badge.fury.io/rb/fmod) ![Documentation](https://img.shields.io/badge/Documentation-71%25-orange.svg)


A full-featured (*complete* Ruby wrapper) of the ultra-powerful FMOD Low-Level API. Uses the built-in Fiddle library (Ruby 2.0+), and has no external gem dependencies, all that is needed is the native FMOD platform-specific native FMOD libraries.

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
   
FMOD is most widely known for its application in video games for sound effects, as it fully supports 3D sound, and can be found in all popular video game consoles (Sony, Microsoft, and Nintendo), as well as a large number of popular PC and mobile games. Built-in is a large collection of audio effects that can be applied to a sound, including various equalizers, advanced reverb environments, pitch-shifting, frequency, flange, chorus, and many, many more. 

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
    
The dependent binaries will be loaded automatically on Windows and Mac without further action, and are included within the gem. Linux user will need to locate the `./ext` directory within the gem file and extract `libfmod.zip` into the `./ext` directory. Due to symbolic linking, this process needs done on the host machine, and will hopefully be automated in future releases.

## Usage

Including in the `/extras` folder is the compiled help documentation for the actual FMOD library, which can be helpful for understanding how the API works if you are unfamiliar.

Those who are familiar with FMOD will find the structure and syntax familiar, though performed in the object-oriented "Ruby" way.  All base core FMOD data types have been created as classes, and mostly share the same names with their C counterpart though in Ruby "snake_case" style as opposed to "UpperCamelCase".  Being object-oriented each class is wrapped around using the functions that relate to it, and doesn't require the use of passing pointers or the object to the methods.

So creating and working with objects has been simplied..

```ruby
require 'fmod'

FMOD.load_library

system = FMOD::System.create
sound = system.create_sound("./myFile.mp3")
sound.play  
``` 

Each get/set method in the FMOD API has been converted to an "attribute" that can be accessed in the Ruby way. So instead of`FMOD_Channel_GetVolume` and `FMOD_Channel_SetVolume`, it is simply `channel.volume` and `channel.volume = value`. 

## Future Releases

As of the current release, only slightly better than 71% of documentation is complete. The scripts are highly technical, and good documentation takes time, but it is actively being updated, and will be completed at the highest priority level. If you are using version `1.0.0`, you will have to rely more heavily upon the included FMOD Low-Level API Reference that is included in the `./extras` folder.

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
