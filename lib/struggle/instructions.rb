module Instructions; end

require_relative "instructions/action_round"
require_relative "instructions/action_round_end"
require_relative "instructions/action_rounds_end"
require_relative "instructions/add_current_card"
require_relative "instructions/add_influence"
require_relative "instructions/add_permission_modifier"
require_relative "instructions/add_to_deck"
require_relative "instructions/advance_space_race"
require_relative "instructions/advance_turn"
require_relative "instructions/attempt_space_race"
require_relative "instructions/award_victory_points"
require_relative "instructions/award_net_victory_points"
require_relative "instructions/boycott_olympic_games"
require_relative "instructions/cancel_effect"
require_relative "instructions/check_held_cards"
require_relative "instructions/check_military_ops"
require_relative "instructions/claim_china_card"
require_relative "instructions/coup"
require_relative "instructions/deal_cards"
require_relative "instructions/declare_winner"
require_relative "instructions/degrade_defcon"
require_relative "instructions/discard_held_card"
require_relative "instructions/dispose_current_cards"
require_relative "instructions/early_phase"
require_relative "instructions/end_game"
require_relative "instructions/support_olympic_games"
require_relative "instructions/free_move"
require_relative "instructions/final_scoring"
require_relative "instructions/flip_china_card"
require_relative "instructions/game"
require_relative "instructions/headline_phase"
require_relative "instructions/improve_defcon"
require_relative "instructions/increment_military_ops"
require_relative "instructions/initialize_markers"
require_relative "instructions/late_phase"
require_relative "instructions/mid_phase"
require_relative "instructions/noop"
require_relative "instructions/optional_action_round"
require_relative "instructions/place_in_effect"
require_relative "instructions/play_card"
require_relative "instructions/player_action_round"
require_relative "instructions/player_action_round_end"
require_relative "instructions/realignment"
require_relative "instructions/remove_card_from_hand"
require_relative "instructions/remove_current_card"
require_relative "instructions/remove_influence"
require_relative "instructions/replace_influence"
require_relative "instructions/reset_action_round"
require_relative "instructions/reset_military_ops"
require_relative "instructions/reset_space_race_attempts"
require_relative "instructions/score_region"
require_relative "instructions/set_defcon"
require_relative "instructions/set_headline_phase"
require_relative "instructions/set_phasing_player"
require_relative "instructions/setup"
require_relative "instructions/space_race_advancement"
require_relative "instructions/starting_influence"
require_relative "instructions/surrender_china_card"
require_relative "instructions/turn"
require_relative "instructions/war_loss"
require_relative "instructions/war_outcome_factory"
require_relative "instructions/war_victory"
require_relative "instructions/wargames_award_vp"
require_relative "instructions/wargames_award_vp_and_end_game"

require_relative "instructions/war_invasion"
require_relative "instructions/brush_war"
require_relative "instructions/iran_iraq_war"
require_relative "instructions/indo_pakistani_war"

# Generates:
#  instructions/discard
#  instructions/remove
#  instructions/limbo
require_relative "instructions/card_dumpers"

