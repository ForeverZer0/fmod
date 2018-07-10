module FMOD
  module Core

    ##
    # These values are used with to determine what happens when more sounds are
    # played than are specified.
    module SoundGroupBehavior

      ##
      # Will simply fail when attempting to play.
      FAIL = 0

      ##
      # Will be silent, then if another sound in the group stops the sound that
      # was silent before becomes audible again.
      MUTE = 1

      ##
      # Will steal the quietest / least important sound playing in the group.
      STEAL_LOWEST = 2
    end
  end
end