require 'spec_helper'

describe EmptyPort do
  it 'should have a version number' do
    EmptyPort::VERSION.should_not be_nil
  end

  it 'should do something useful' do
    false.should be_true
  end
end
