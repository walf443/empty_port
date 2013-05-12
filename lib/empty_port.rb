require "empty_port/version"
require 'socket'
require 'timeout'

# ## Example
#   require 'empty_port'
#   class YourServerTest < Test::Unit::TestCase
#       def setup
#         empty_port = EmptyPort.get
#         pid = Process.fork do
#           server = TCPServer.open('localhost', empty_port)
#         end
#         EmptyPort.wait(random_port)
#         @port = empty_port
#         @server_pid = pid
#       end
#
#       def test_something_with_server
#       end
#
#       def teardown
#         Process.kill(@server_pid)
#       end
#   end
#
module EmptyPort
  class NotFoundException < Exception; end

  module ClassMethods
    # SEE  http://www.iana.org/assignments/port-numbers
    MIN_PORT_NUMBER = 49152
    MAX_PORT_NUMBER = 65535

    # get an empty port except well-known-port.
    def get
      random_port = MIN_PORT_NUMBER + ( rand() * 1000 ).to_i
      while random_port < MAX_PORT_NUMBER
        begin
          sock = TCPSocket.open('localhost', random_port)
          sock.close
        rescue Errno::ECONNREFUSED => e
          return random_port
        end
        random_port += 1
      end
      raise NotFoundException
    end

    def listened?(port)
      begin
        sock = TCPSocket.open('localhost', port)
        sock.close
        return true
      rescue Errno::ECONNREFUSED
        return false
      end
    end

    DEFAULT_TIMEOUT = 2
    DEFAULT_INTERVAL = 0.1

    def wait(port, options={})
      options[:timeout] ||= DEFAULT_TIMEOUT
      options[:interval] ||= DEFAULT_INTERVAL

      timeout(options[:timeout]) do
        start = Time.now
        loop do
          if self.listened?(port)
            finished = Time.now
            return finished - start
          end
          sleep(options[:interval])
        end
      end
    end
  end

  extend ClassMethods
end

