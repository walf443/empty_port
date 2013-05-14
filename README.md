# EmptyPort

take an empty port.

## Usage
	# 1. in case writing test for your server with empty_port
    require 'empty_port'
    class YourServerTest < Test::Unit::TestCase
        def setup
          @port = EmptyPort.get
          @server_pid = Process.fork do
            server = TCPServer.open('localhost', @port)
          end
          EmptyPort.wait(@port)
        end

        def test_something_with_server
        end

        def teardown
          Process.kill(@server_pid)
        end
    end

	# 2. in case writing for memcached test with empty_port

	port = EmptyPort.get
	pid = Process.spawn("memcached -p #{port}")
	at_exit do
		Process.kill(:TERM, pid)
	end
	EmptyPort.wait(port)

	# do something with memcached.

## DESCRIPTION

This library is useful when you test servers or client libraries.

## Installation

Add this line to your application's Gemfile:

    gem 'empty_port'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install empty_port

## THANKS

 * tokuhirom: This library is inspired by [Test::TCP](http://metacpan.org/module/Test::TCP)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
