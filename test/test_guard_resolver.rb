require "helper"

class GuardResolverTest < Struggle::Test

  # Uses a const_get, so we need to be sure input is validated.
  def test_cannot_find_things_that_arent_guards
    move = EmptyMove.new(
      player: USSR,
      instruction: Instructions::PlayCard.new(
        player: USSR,

        # use a valid card action here because PlayCard.new
        # validates it also.
        card_action: :influence,

        card_ref: "Derp"
      )
    )

    injector = NullInjector.new(nil)

    move.instruction.card_action = "::String" # <--TEEHEE

    gr = GuardResolver.new(injector)

    ex = assert_raises ArgumentError do
      gr.resolve(move)
    end

    assert_match %r/Invalid action/, ex.message
  end

end
