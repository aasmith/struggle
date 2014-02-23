require 'delegate'
require 'pp'
require 'set'

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

require "struggle/ops_counter"
require "struggle/ops_modifier"

require "struggle/instructions"
require "struggle/arbitrators"

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

# TODO make this into a serializing log.
if defined?(ENABLE_LOG) && ENABLE_LOG
  alias log puts
else
  def log(*); end
end
