require 'spec_helper'

describe EmptyPort do
  it 'should have a version number' do
    EmptyPort::VERSION.should_not be_nil
  end

  it 'should give you empty_port by EmptyPort.get' do
    empty_port = EmptyPort.get
    empty_port.class.should == Fixnum
    lambda {
      server = TCPServer.open(nil, empty_port)
      server.close
    }.should_not raise_error(Errno::ECONNREFUSED)
  end

  describe "EmptyPort.listen?" do
    before do
      @port = EmptyPort.get
    end

    describe "in case when a port is not listened" do
      it "should return false" do
        EmptyPort.listened?(@port).should == false
      end
    end

    describe "in case when a port is listened" do
      describe "when TCPServer listen the port" do
        it "should return true" do
          server = TCPServer.open(nil, @port)
          EmptyPort.listened?(@port).should == true
          server.close
        end
      end
    end
  end

  describe "EmptyPort.wait" do
    describe "in case when a port is not listened" do
      it 'should block until a port is listened' do
        port = EmptyPort.get
        lambda {
          EmptyPort.wait(port, timeout: 0.1).should == false
        }.should raise_error(Timeout::Error)
      end
    end

    describe "in case when a port is listened" do
      it "should block until a port is listened" do
        port = EmptyPort.get
        sleep_time = 0.1
        timeout = 1
        th = Thread.new {
          sleep(sleep_time)
          server = TCPServer.open(nil, port)
        }
        res = EmptyPort.wait(port, timeout: timeout)
        th.kill
        res.should >= sleep_time
        res.should < timeout
        res.should < sleep_time * 3
      end
    end
  end

end
