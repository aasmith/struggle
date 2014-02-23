module Instructions
  class EndGame < Instruction
    needs :victory

    # Set game.over = true. Winner should be set by another instruction. if
    # not set, then winner will be nil and a draw is assumed.
    def action
      puts "GAME OVER: Winner #{victory} (#{victory.reason})"
    end
  end
end
