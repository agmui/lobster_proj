import utils
import terminal_colors

import CardAction


enum CardType:
    instant
    magic
    upgrade
    downgrade
    baby_unicorn
    basic_unicorn
    magical_unicorn
    ultimate_unicorn

class GameState//:

// let a:end_of_turn_cleanup = fn(g:GameState)->int: 1

// abstract class Card: // TODO: idk  something about composition over inheritance
class Card:
    name: string 
    img: string 
    text: string 
    type: CardType 
    cli_color: string
    cardAction: CardAction // = CardAction{}

    def game_state():
        return cardAction.get_game().get_game_state()

    //TODO: maybe merge activate and enter_stable into one func called play()
    def play(caller):
        print("{GRN}({caller.name}) plays {name}{reset}\n")
        if type == magic or type == instant:
            activate(caller)
            game_state().discard(this)
        else:
            enter_stable(caller)
    
    def enter_stable(caller):
        error("{name} can not enter a stable\n")

    def activate(caller):
        error("can not activate {name}\n")
    
    def end_phase_resolver():
        error("has no end phase")
        return false
    
    def unicorn_type_fmt()->string:
        return switch type:
            case instant:
                "{RED}!{reset}"
            case magic:
                "{GRN}*{reset}"
            case upgrade:
                "{YEL}^{reset}"
            case downgrade:
                "{YEL}v{reset}"
            case baby_unicorn:
                "{BLK} {reset}"
            case basic_unicorn:
                "{BLU}*{reset}"
            case magical_unicorn:
                "{BBLU}x{reset}"
            case ultimate_unicorn:
                "{BLUHB}X{reset}"
            default:
                " "
    def fmt():
        return "{unicorn_type_fmt()} {cli_color}{name}{reset}"

class BabyUnicorn_Pink: Card
class BabyUnicorn_Red: Card

class UnicornPoison: Card
    // text: string = "DESTROY a Unicorn."

    def activate(caller):
        cardAction.destroy(caller)

class BlackKnightUnicorn: Card
//   text: string = "If one of your Unicorns would be destroyed, you may SACRIFICE this card instead."


class SharkWithAHorn: Card
// "When this card enters your Stable, you may DESTROY a Unicorn. 
// If you do, SACRIFICE this card."

    def enter_stable(caller):
        if cardAction.ask_to_activate():
            cardAction.destroy(caller)
            caller.remove_stable(this)

class TwoForOne: Card
//	SACRIFICE a card, then DESTROY two cards.
    def activate(caller):
        cardAction.sacrifice(caller)
        cardAction.destroy(caller, caller.stable(),2)//FIXME: remove the caller.stable() arg

class GlitterBomb: Card
//upgrade

// If this card is in your Stable at the beginning of your turn,
// you may SACRIFICE a card, then DESTROY a card.
    def activate(caller):
        let cur_player_turn = game_state().current_players_turn()
        guard caller == cur_player_turn and game_state().is_beginning_phase():
            error("Not start of turn, can\'t activate {name} at this time")
        let cards = caller.stable().copy()
        cards.remove_obj(this)
        cardAction.sacrifice(caller, cards)
        cardAction.destroy(caller)

class UnicornLasso: Card
//upgrade

// if this card is in your Stable at the beginning of your turn,
// you may move a Unicorn from any player's Stable to your Stable.
// At the end of your turn, move the Unicorn to its First Stable.
    card_moved:Card?=nil

    def activate(caller):
        card_moved = cardAction.move()
        // guard this.card_moved != nil: 
        //      error("TODO:")
        game_state().add_to_end_phase(this)

        // game_state().add_to_end_phase(UnicornLasso_help{this})
    def end_phase_resolver():
        print("Unicorn Lasso resolver")
        //TODO: test
        // guard not game_state().is_end_phase():
        //     error("in Unicorn Lasso is not end phase")
        //     return false
        // guard card_moved != nil:
        //     error("in Unicorn Lasso card_moved is nil")
        //     return false
        // print("cleaning up Unicorn Lasso, moving unicorn [{card_moved.name}] back to original stable")
        print(card_moved)
        return 0

class Puppicorn: Card
//magical unicorn

// At the end of your turn, move Puppicorn to the Stable of the player on your left.
// This card cannot be sacrificed or destroyed.