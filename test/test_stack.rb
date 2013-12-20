require "helper"

class TestStack < Struggle::Test

  def test_stack_changed?
    obj = Struct.new(:a).new
    s = Stack.new

    assert s.stack_changed? { s.push obj },
      "Adding an item to stack should register a change"

    refute s.stack_changed? { obj.a = 1234 },
      "Modifying an item on the stack should not register a change"

    refute s.stack_changed? { s.peek },
      "Inspecting the stack should not register a change"

    assert s.stack_changed? { s.pop },
      "Removing an item from stack should register a change"

    assert_raises ArgumentError, "should require a block" do
      s.stack_changed?
    end
  end
end

