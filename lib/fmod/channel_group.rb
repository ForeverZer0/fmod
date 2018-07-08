
module FMOD
  class ChannelGroup < ChannelControl

    include Fiddle
    include Enumerable

    integer_reader(:subgroup_count, :ChannelGroup_GetNumGroups)
    integer_reader(:channel_count, :ChannelGroup_GetNumChannels)

    def name
      buffer = "\0" * 512
      FMOD.invoke(:ChannelGroup_GetName, self, buffer, 512)
      buffer.delete("\0")
    end

    def subgroup(index)
      FMOD.check_range(index, 0, subgroup_count - 1)
      FMOD.invoke(:ChannelGroup_GetGroup, self, index, group = int_ptr)
      ChannelGroup.new(group)
    end

    def parent_group
      FMOD.invoke(:ChannelGroup_GetParentGroup, self, group = int_ptr)
      group.null? ? nil : ChannelGroup.new(group)
    end

    def [](index)
      FMOD.check_range(index, 0, channel_count - 1)
      FMOD.invoke(:ChannelGroup_GetChannel, self, index, channel = int_ptr)
      Channel.new(channel)
    end

    def each
      return to_enum(:each) unless block_given?
      (0...channel_count).each { |i| yield self[i] }
      self
    end

    def <<(channel_control)
      return add_channel(channel_control) if channel_control.is_a?(Channel)
      return add_group(channel_control) if channel_control.is_a?(ChannelGroup)
      raise TypeError, "#{channel_control} is not a #{ChannelControl}."
    end

    def add_channel(channel)
      FMOD.type?(channel, Channel)
      channel.group = self
      channel
    end

    def add_group(group, propagate_clock = true)
      FMOD.type?(group, ChannelGroup)
      FMOD.invoke(:ChannelGroup_AddGroup, self, group,
        propagate_clock.to_i, connection = int_ptr)
      DspConnection.new(connection)
    end

    alias_method :channel, :[]
  end
end