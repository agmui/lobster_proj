class Player
class Card

enum phase:
    beginning_phase
    draw_phase
    action_phase
    end_phase

struct card_event://TODO: better name
    player:Player
    cards:[Card]


