# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
## Added
- This `CHANGELOG.md` file
- Meta-data to `.gemspec` file

## Removed
- The deprecated `HISTORY.txt` file

## [0.9.4](https://rubygems.org/gems/fmod/versions/0.9.4) - 2018/07/12
## Removed
- Some temporary code that was accidentally left in the `.gemspec` file
- Packaged native FMOD libraries from `.gem` file
- Compiled FMOD help file from `.gem` file

## [0.9.2](https://rubygems.org/gems/fmod/versions/0.9.2) - 2018/07/11
## Added
- `ReverbIndex` module to define reverb presets by strongly-typed integer
- Added `.from_index` class method to `Reverb` class
- Implemented skeleton `DspDescription` structure

## Deprecated
- `FMOD::DspType::LOW_PASS` constant
- `FMOD::DspType::LOW_PASS_SIMPLE` constant
- `FMOD::DspType::HIGH_PASS` constant
- `FMOD::DspType::HIGH_PASS_SIMPLE` constant
- `FMOD::DspType::LADSPA_PLUGIN` constant
- `FMOD::Effects::LowPass` class
- `FMOD::Effects::LowPassSimple` class
- `FMOD::Effects::HighPass` class
- `FMOD::Effects::HighPassSimple` class
- `FMOD::Effects::LadspaPlugin` class

## [0.9.1](https://rubygems.org/gems/fmod/versions/0.9.1) - 2018-07-10
## Added
- `names` method added to `FMOD::Core::Structure` class
- `values` method added to `FMOD::Core::Structure` class

## Bug Fixes
- Retrieving current reverb properties (`FMOD::System##get_reverb`) will no longer cause segmentatiion fault 


## [0.9.0](https://rubygems.org/gems/fmod/versions/0.9.0) - 2018-07-09

- Initial public release