require 'delegate'
require 'pp'
require 'set'

require "struggle/constants"

require "struggle/superpowers"

require "struggle/stack"
require "struggle/engine"
require "struggle/injection"
require "struggle/arguments"
require "struggle/observer"
require "struggle/observers"

require "struggle/move"
require "struggle/work_item"
require "struggle/instruction"
require "struggle/move_arbitrator"
require "struggle/guard_resolver"
require "struggle/guard"

require "struggle/ops_counter"
require "struggle/ops_modifier"

require "struggle/instructions"
require "struggle/arbitrators"
require "struggle/guards"

# TODO delete or graduate components out of here.
require "struggle/models"

require "struggle/data/countries"

require "struggle/card"
require "struggle/cards"
require "struggle/countries"
require "struggle/country"
require "struggle/china_card"
require "struggle/deck"
require "struggle/defcon"
require "struggle/die"
require "struggle/hands"
require "struggle/victory"
require "struggle/military_ops"
require "struggle/phasing_player"
require "struggle/space_race"
require "struggle/turn_marker"
require "struggle/victory_track"

class Struggle
  VERSION = "1.0.0"
end

DEBUG_ENGINE = ENV["STRUGGLE_DEBUG_ENGINE"]

def log(*stuff)
  puts(*stuff.map { |line| ">> " + line }) if $logging
end

