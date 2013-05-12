# EmptyPort

take an empty port.

## Usage
    require 'empty_port'
    class YourServerTest < Test::Unit::TestCase
        def setup
          empty_port = EmptyPort.get
          pid = Process.fork do
            server = TCPServer.open('localhost', empty_port)
          end
          EmptyPort.wait(random_port)
          @port = empty_port
          @server_pid = pid
        end

        def test_something_with_server
        end

        def teardown
          Process.kill(@server_pid)
        end
    end

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
