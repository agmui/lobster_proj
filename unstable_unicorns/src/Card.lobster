import utils
import terminal_colors

import const
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

let up_downgrade_filter = fn cards: filter(cards)c: c.type == upgrade or c.type == downgrade

class GameState//:

// let a:end_of_turn_cleanup = fn(g:GameState)->int: 1

// maybe have a interface called CardInterface
// then have 5 interfaces implmenting CardInterface called Magic, 
// upgrade, downgrade, resolver, Unicorn...
// then have each of those classes contain a concrete class called Card data
// Card data will have the name, img, text...
// but the upgrade, downgrade, resolver will have the individual funcs for each
// class specific to their type (i.e. for Resolver there is the end_phase_resolver())
// this is so other classes wont need to have a bloated function
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
    // maybe have magic and instant be other interfaces that contain card (i.e. composition over inheritance with the one yt vid)
    def play(caller):
        print("{GRN}({caller.name}) plays {name}{reset}\n")
        if type == magic or type == instant:
            activate(caller)
            game_state().discard(this)
        else:
            enter_stable(caller)
    
    def enter_stable(caller):
        pass()

    def on_deletion(caller):
        pass()

    def activate(caller):
        error("can not activate {name}\n")
    
    
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

abstract class Resolver: Card //TODO: better name
    def end_phase_code():
// point of this func is to always call remove_from_end after it
        error("has no end phase code")
        return false

    def end_phase_resolver():
        let res = end_phase_code()
        game_state().remove_from_end_phase(this)
        return res

class BabyUnicorn_Pink: Card
class BabyUnicorn_Red: Card
// If this card would be sacrificed, destroyed, or returned to your hand,
// TODO: return it to the Nursery instead.

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
        cardAction.destroy(caller, 2)//FIXME: remove the caller.stable() arg

class GlitterBomb: Card
//upgrade

// If this card is in your Stable at the beginning of your turn,
// you may SACRIFICE a card, then DESTROY a card.
    def activate(caller):
        let cur_player_turn = game_state().current_players_turn()
        guard caller == cur_player_turn and game_state().is_beginning_phase():
            error("Not start of turn, can\'t activate {name} at this time")
        let cards = caller.stable().copy() //TODO: should not need to copy? the getter should already return a copy?
        cards.remove_obj(this)
        cardAction.sacrifice(caller, cards)
        cardAction.destroy(caller)

class UnicornLasso: Resolver
//upgrade

// if this card is in your Stable at the beginning of your turn,
// you may move a Unicorn from any player's Stable to your Stable.
// At the end of your turn, move the Unicorn to its First Stable.
    card_moved:Card?=nil
    original_player:Player? = nil
    caller_:Player?=nil

    def activate(caller):
        this.caller_ = caller
        //FIXME: should not be calling choose functions
        let players = game_state().get_players.copy()
        players.remove_obj(caller)
        original_player = cardAction.get_game().choose_player(players)
        card_moved = cardAction.get_game().choose_card(original_player.stable())
        cardAction.move(original_player.stable(), caller.stable(), card_moved)
        guard card_moved != nil:
            error("in Unicorn Lasso card_moved is nil")
        guard original_player != nil:
            error("in Unicorn Lasso original_player is nil")
        guard caller_ != nil:
            error("in Unicorn Lasso caller_ is nil")
        game_state().add_to_end_phase(this)
        

        // game_state().add_to_end_phase(UnicornLasso_help{this})
    def end_phase_code():
        print("Unicorn Lasso resolver")
        guard game_state().is_end_phase():
            error("in {this.name} is not end phase")
            return false
        guard card_moved != nil:
            error("in {this.name} card_moved is nil")
            return false
        guard original_player != nil:
            error("in Unicorn Lasso original_player is nil")
            return false
        guard caller_ != nil:
            error("in Unicorn Lasso caller_ is nil")
            return false
        print("- cleaning up Unicorn Lasso, moving unicorn [{card_moved.name}] back to original stable")
        cardAction.move(caller_.stable(), original_player.stable(), card_moved)
        // game_state().remove_from_end_phase(this)

        return true

class Puppicorn: Resolver
//magical unicorn

// At the end of your turn, move Puppicorn to the Stable of the player on your left.
// TODO: This card cannot be sacrificed or destroyed.
    caller_:Player?=nil
    def enter_stable(caller):
        print("enter")
        this.caller_ = caller
        game_state().add_to_end_phase(this)

    def end_phase_resolver()://this is a hack
        print("Puppicorn resolver")
        guard game_state().is_end_phase():
            error("in {this.name} is not end phase")//TODO: maybe generalize?
            return false
        guard caller_ != nil:
            error("in {this.name} caller_ is nil")
            return false
        let players = game_state().get_players
        let i = find(players)p:p==caller_
        let next_player_index = (i+1)%players.len()
        cardAction.move(caller_.stable(),players[next_player_index].stable(),this)
        caller_ = players[next_player_index]
        return true

class UnicornMafia: Card
//upgrade

// If this card is in your Stable at the beginning of your turn,
// you may DISCARD 2 cards.
// If you do, SACRIFICE or DESTROY a card.
    def activate(caller):
        cardAction.discard(caller,caller.hand(),2)
        cardAction.sacrifice_or_destroy(caller)

class StabbyTheUnicorn:Card
//Magical unicorn

// If this card is sacrificed or destroyed,
// you may DESTROY a Unicorn
    def on_deletion(caller):
        print("{BRED}-- {name}: on deletion activation --{reset}")
        if cardAction.ask_to_activate():
            cardAction.destroy(caller)

class ChainsawUnicorn:Card
// Magical Unicorn	

// When this card enters your Stable,
// you may SACRIFICE or DESTROY an Upgrade or Downgrade card.
    def enter_stable(caller):
        if cardAction.ask_to_activate():
            cardAction.sacrifice_or_destroy(caller,1,up_downgrade_filter)


class Foresight: Card
// Upgrade

// If this card is in your Stable at the beginning of your turn,
// you may look at the top 3 cards of the deck. If you do,
// add 1 of them to your hand,
// TODO: then shuffle the other 2 back into the deck
// and skip your Draw phase.	
    def activate(caller):
        let cards = cardAction.peek_top_deck(3)
        let chosen_card = cardAction.get_game().choose_card(cards)
        cardAction.move(game_state().get_deck(), caller.hand(), chosen_card)
        game_state().update_phase(action_phase)


