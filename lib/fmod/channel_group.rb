
module FMOD

  # Represents a logical grouping of {Channel} and/or {ChannelGroup} objects
  # that can be manipulated as one.
  class ChannelGroup < ChannelControl

    include Fiddle
    include Enumerable

    # @!attribute [r] subgroup_count
    # @return [Integer]  the number of sub groups under this channel group.
    integer_reader(:subgroup_count, :ChannelGroup_GetNumGroups)

    # @!attribute [r] channel_count
    # @return [Integer] the number of assigned channels to this channel group.
    integer_reader(:channel_count, :ChannelGroup_GetNumChannels)

    ##
    # @return [String] the name of the channel group set when the group was
    #   created.
    def name
      buffer = "\0" * 512
      FMOD.invoke(:ChannelGroup_GetName, self, buffer, 512)
      buffer.delete("\0")
    end

    ##
    # Retrieves the sub-group at the specified index.
    #
    # @param index [Integer] Index to specify which sub channel group to get.
    # @return [ChannelGroup, nil] the group or +nil+ if no group was found at
    #   the specified index.
    def subgroup(index)
      return nil unless FMOD.valid_range?(index, 0, subgroup_count - 1, false)
      FMOD.invoke(:ChannelGroup_GetGroup, self, index, group = int_ptr)
      ChannelGroup.new(group)
    end

    ##
    # @!attribute [r] parent_group
    # @return [ChannelGroup, nil] the channel group parent.
    def parent_group
      FMOD.invoke(:ChannelGroup_GetParentGroup, self, group = int_ptr)
      group.null? ? nil : ChannelGroup.new(group)
    end

    ##
    # Retrieves the {Channel} within this group at the specified index.
    #
    # @param index [Integer] Index within the group of the channel.
    #
    # @return [Channel, nil] the specified {Channel}, or +nil+ if no channel
    #   exists at the specified index.
    def [](index)
      return nil unless FMOD.valid_range?(index, 0, channel_count - 1, false)
      FMOD.invoke(:ChannelGroup_GetChannel, self, index, channel = int_ptr)
      Channel.new(channel)
    end

    ##
    # Enumerates the channels contained within the {ChannelGroup}.
    #
    # @overload each
    #   When called with block, yields each {Channel} within the object before
    #   returning self.
    #   @yield [channel] Yields a channel to the block.
    #   @yieldparam channel [Channel] The current enumerated channel.
    #   @return [self]
    # @overload each
    #   When no block specified, returns an Enumerator for the {ChannelGroup}.
    #   @return [Enumerator]
    def each
      return to_enum(:each) unless block_given?
      (0...channel_count).each { |i| yield self[i] }
      self
    end

    ##
    # Adds a {Channel} or a {ChannelGroup} as a child of this group.
    #
    # @param channel_control [Channel, ChannelGroup] The channel or group to
    #   add as a child.
    #
    # @return [self, DspConnection] either self if a {Channel} was added, or a
    #   {DspConnection} if a group was added.
    def <<(channel_control)
      return add_channel(channel_control) if channel_control.is_a?(Channel)
      return add_group(channel_control) if channel_control.is_a?(ChannelGroup)
      raise TypeError, "#{channel_control} is not a #{ChannelControl}."
    end

    ##
    # Adds a channel as a child of the this group. This detaches the channel
    # from any group it may already be attached to.
    #
    # @param channel [Channel] Channel to add as a child.
    #
    # @return [self]
    def add_channel(channel)
      FMOD.type?(channel, Channel)
      channel.group = self
      self
    end

    ##
    # Adds a channel group as a child of the current channel group.
    #
    # @param group [ChannelGroup] Channel group to add as a child.
    # @param propagate_clock [Boolean] When a child group is added to a parent
    #   group, the clock values from the parent will be propagated down into
    #   the child.
    #
    # @return [DspConnection] a DSP connection, which is the connection between
    #   the parent and the child group's DSP units.
    def add_group(group, propagate_clock = true)
      FMOD.type?(group, ChannelGroup)
      FMOD.invoke(:ChannelGroup_AddGroup, self, group,
        propagate_clock.to_i, connection = int_ptr)
      DspConnection.new(connection)
    end

    alias_method :channel, :[]
  end
end