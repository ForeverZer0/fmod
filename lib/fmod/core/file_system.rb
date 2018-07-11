module FMOD
  module Core

    class FileSystem

      include Fiddle

      # TODO: Upsets the stack, causing a segfault with STD_CALL.

      def initialize(system)
        @callbacks = []
        @cbs = [open_cb, close_cb, seek_cb, close_cb]
        FMOD.invoke(:System_AttachFileSystem, system, *@cbs)
      end

      def on_open(proc = nil, &block)
        set_callback(0, &(block_given? ? block : proc))
      end

      def on_close(proc = nil, &block)
        set_callback(1, &(block_given? ? block : proc))
      end

      def on_read(proc = nil, &block)
        set_callback(2, &(block_given? ? block : proc))
      end

      def on_seek(proc = nil, &block)
        set_callback(3, &(block_given? ? block : proc))
      end

      private

      def set_callback(index, &block)
        raise LocalJumpError, "No block given." unless block_given?
        @callbacks[index] = block
      end

      def open_cb
        sig = Array.new(4, TYPE_VOIDP)
        abi = FMOD::ABI
        Closure::BlockCaller.new(TYPE_INT, sig, abi) do |name, size, ptr, user|
          if @callbacks[0]
            size = size.to_s(SIZEOF_INT).unpack1('L')
            @callbacks[0].call(name, size, ptr, user)
          end
          Result::OK
        end
      end

      def close_cb
        sig = [TYPE_VOIDP, TYPE_VOIDP]
        abi = FMOD::ABI
        Closure::BlockCaller.new(TYPE_INT, sig, abi) do |handle, user_data|
          @callbacks[1].call(handle, user_data) if @callbacks[1]
          Result::OK
        end
      end

      def read_cb
        sig = Array.new(5, TYPE_VOIDP)
        abi = FMOD::ABI
        Closure::BlockCaller.new(TYPE_INT, sig, abi) do |handle, buffer, size, read, user|
          if @callbacks[2]
            @callbacks[2].call(handle, buffer, size, read, user)
          end
          Result::OK
        end
      end

      def seek_cb
        sig = Array.new(3, TYPE_VOIDP)
        abi = FMOD::ABI
        Closure::BlockCaller.new(TYPE_INT, sig, abi) do |handle, position, user|
          if @callbacks[3]
            @callbacks[3].call(handle, position, user)
          end
          Result::OK
        end
      end
    end

    # TODO: Remove after fixing
    private_constant :FileSystem

  end
end