# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
module RightScale
  module ServerCollection
    
    @mutex        = Mutex.new
    @loaded_event = ConditionVariable.new

    def breakpoint_set?(instance_uuid)
      
    end
    
    def get_collection(tags)
        server_collection ||= {}
        return unless tags && !tags.empty?
        status = :pending
        result = nil
        @mutex.synchronize do
          EM.next_tick do
            # Create the timer in the EM Thread
            @timeout_timer = EM::Timer.new(QUERY_TIMEOUT) do
              @mutex.synchronize do
                status = :failed
                @loaded_event.signal
              end
            end
          end
          RightScale::RequestForwarder.query_tags(tags) do |r|
            @mutex.synchronize do
              if status == :pending
                result = r
                status = :succeeded
                @timeout_timer.cancel
                @timeout_timer = nil
                @loaded_event.signal
              end
            end
          end
          @loaded_event.wait(@mutex)
        end
        if status == :succeeded && result
          server_collection = collection = {}
          result.each { |k, v| collection[k] = v[:tags] }
        else
          RightScale::RightLinkLog.debug("ServerCollection load failed. (timed out after #{QUERY_TIMEOUT}s)")
        end
        true
      end

  end
end
