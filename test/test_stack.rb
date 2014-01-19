require "helper"

class TestStack < Struggle::Test

  def test_monitor
    obj = Struct.new(:a).new
    s = Stack.new

    assert s.monitor { s.push obj },
      "Adding an item to stack should register a change"

    refute s.monitor { obj.a = 1234 },
      "Modifying an item on the stack should not register a change"

    refute s.monitor { s.peek },
      "Inspecting the stack should not register a change"

    assert s.monitor { s.pop },
      "Removing an item from stack should register a change"

    assert_raises ArgumentError, "should require a block" do
      s.monitor
    end
  end
end

