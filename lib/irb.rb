require 'irb'
require_relative 'fmod'

include FMOD

FMOD.load_library

mp3 = Dir.glob("#{Dir.home}/Music/**/*.mp3").sample

unless mp3.nil?
  puts("Now playing \"#{File.basename(mp3)}...\"")
  $system = System.create
  $sound = $system.create_sound(mp3)
  $channel = $system.play_sound($sound)
end

IRB.start(__FILE__)