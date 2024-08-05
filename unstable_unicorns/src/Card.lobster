import utils
import terminal_colors

import const
import CardAction
import Publisher


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

//TODO: maybe move into Card class
def is_unicorn(card):
    return exists([baby_unicorn, basic_unicorn, magical_unicorn, ultimate_unicorn])t:
        card.type == t

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

    //NOTE:
    // should only be used when sacrificing or destroying (Stabby the unicorn)
    def sac_or_destroy(caller):
        pass()

    def activate(caller):
        error("can not activate {name}\n")
    
    def forced_activate(caller):
        pass()
    
    def unicorn_type_fmt()->string:
        return switch type:
            case instant: "{RED}!{reset}"
            case magic: "{GRN}*{reset}"
            case upgrade: "{YEL}^{reset}"
            case downgrade: "{YEL}v{reset}"
            case baby_unicorn: "{BLK} {reset}"
            case basic_unicorn: "{BLU}*{reset}"
            case magical_unicorn: "{BBLU}x{reset}"
            case ultimate_unicorn: "{BLUHB}X{reset}"
            default: " "
    def fmt():
        return "{unicorn_type_fmt()} {cli_color}{name}{reset}"


class BabyUnicorn_Pink: Card
class BabyUnicorn_Red: Card
// If this card would be sacrificed, destroyed, or returned to your hand,
// TODO: return it to the Nursery instead.

class BasicUnicornRed: Card
constructor BasicUnicornRed(ca):
    return BasicUnicornRed{
        "Basic Unicorn (Red)", 
        "Basic_Unicorn_(Red).png",
        "Beards are like, so hot.",
        basic_unicorn, RED, ca
    }
    

class UnicornPoison: Card
    // text: string = "DESTROY a Unicorn."

    def activate(caller):
        cardAction.destroy_menu(caller)


class SharkWithAHorn: Card
    def enter_stable(caller):
        if cardAction.ask_to_activate(this.fmt()):
            cardAction.sacrifice(caller, this)
            cardAction.destroy_menu(caller)
    
constructor SharkWithAHorn(ca):
    return SharkWithAHorn{
            "Shark With A Horn",
            "Shark_With_A_Horn.png",
            """
            When this card enters your Stable, you may SACRIFICE this card.
            If you do, DESTROY a Unicorn card.
            """,
            magical_unicorn, BLU, ca
        }



// Second Print
// When this card enters your Stable, you may SACRIFICE this card.
// If you do, DESTROY a Unicorn card.
    

class TwoForOne: Card
//	SACRIFICE a card, then DESTROY two cards.
    def activate(caller):
        cardAction.sacrifice_menu(caller)
        cardAction.destroy_menu(caller, 2)//FIXME: remove the caller.stable() arg

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
        cardAction.sacrifice_menu(caller, cards)
        cardAction.destroy_menu(caller)

class UnicornLasso: Card 
    end_phase_sub = Subscriber<Empty,UnicornLasso>()
    card_moved:Card?=nil
    original_player:Player? = nil
    c:Player?=nil

    def enter_stable(caller):
        this.c = caller
        let pub = game_state().end_phase_pub
        end_phase_sub.subscribe(pub)

    def sac_or_destroy(caller):
        card_moved = nil
        original_player = nil
        c = nil
        let pub = game_state().end_phase_pub
        end_phase_sub.unsubscribe(pub)

    def activate(caller):
        let chosen_cards, chosen_player = cardAction.steal_menu(caller)
        card_moved, original_player = chosen_cards[0], chosen_player

constructor UnicornLasso(ca):
    let ucl = UnicornLasso{
        "Unicorn Lasso", "Unicorn_Lasso.png",
        """
        second
        If this card was in your Stable at the beginning of your turn,
        you may STEAL a Unicorn card. At the end of your turn,
        return that Unicorn card to the Stable from which you stole it.
        """,
        upgrade, YEL, ca
    }
    ucl.end_phase_sub = Subscriber<Empty>(ucl)msg:
        let this = msg.get_data<Empty,UnicornLasso>()
        let card_moved,original_player,c = this.card_moved,this.original_player,this.c
        print("Unicorn Lasso resolver")
        guard this.game_state().is_end_phase():
            error("in {this.name} is not end phase")
        guard card_moved != nil:
            error("in {this.name} card_moved is nil")
        guard original_player != nil:
            error("in Unicorn Lasso original_player is nil")
        guard c != nil:
            error("in Unicorn Lasso caller_ is nil")
        print("- cleaning up Unicorn Lasso, moving unicorn [{card_moved.name}] back to original stable")
        this.cardAction.move(c.stable(), original_player.stable(), card_moved)
    return ucl



// TODO: This card cannot be sacrificed or destroyed.
class Puppicorn: Card
    start_of_turn = Subscriber<Empty,Puppicorn>()
    c:Player?=nil

    def enter_stable(caller):
        this.c = caller
        let pub = game_state().beginning_phase_pub
        start_of_turn.subscribe(pub)

    def sac_or_destroy(caller):
        error("TODO: puppicorn cant be sacrificed or destroyed")
        assert false

constructor Puppicorn(ca):
    let pup = Puppicorn{
        "Puppicorn", "Puppicorn.png",
        """
        Each time any player begins their turn, move this card to that player's Stable.
        This card cannot be sacrificed or destroyed.
        """,
        magical_unicorn, MAG, ca
    }
    pup.start_of_turn = Subscriber<Empty>(pup)msg:
        let this = msg.get_data<Empty,Puppicorn>()
        guard this.c != nil:
            error("in {this.name} caller_ is nil")
            assert false
        let next_player = this.game_state().current_players_turn()
        this.cardAction.move(this.c.stable(), next_player.stable(), this)
        this.c = next_player
    return pup


class UnicornMafia: Card
//upgrade

// If this card is in your Stable at the beginning of your turn,
// you may DISCARD 2 cards.
// If you do, SACRIFICE or DESTROY a card.
    def activate(caller):
        cardAction.discard_menu(caller,caller.hand(),2)
        cardAction.sacrifice_or_destroy(caller)

class StabbyTheUnicorn:Card
//Magical unicorn

// If this card is sacrificed or destroyed,
// you may DESTROY a Unicorn
    def sac_or_destroy(caller):
        print("{BRED}-- {name}: on deletion activation --{reset}")
        if cardAction.ask_to_activate(this.fmt()):
            cardAction.destroy_menu(caller)

class ChainsawUnicorn:Card
// Magical Unicorn	

// When this card enters your Stable,
// you may SACRIFICE or DESTROY an Upgrade or Downgrade card.
    def enter_stable(caller):
        if cardAction.ask_to_activate(this.fmt()):
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

class ControlledChaos: Card
// Upgrade

// If this card is in your Stable at the beginning of your turn,
// you may DISCARD 2 cards. If you do,
// DESTROY a Unicorn card OR search the deck for a Unicorn card and
// add it to your hand. Shuffle the deck.	
    def activate(caller):
        cardAction.discard_menu(caller, caller.hand(), 2)
        let choices = [
            "DESTROY a Unicorn card ",
            "search the deck for a Unicorn card and add it to your hand. Shuffle the deck."
        ]
        if cardAction.choice_selection(choices) == 0:
            cardAction.destroy_menu(caller)
        else:
            let card_filter = fn cards:
                filter(cards)c:
                    c.type == basic_unicorn or c.type == magical_unicorn or c.type == ultimate_unicorn
            let chosen_card = cardAction.search_deck(1,card_filter)[0]
            cardAction.move(game_state().get_deck(), caller.hand(), chosen_card)
            game_state().shuffle_deck()

class ExtraLife: Card
    sacrifice_destroy = Subscriber<card_event,ExtraLife>()
    c: Player? = nil

    def enter_stable(caller):
        this.c = caller
        let pub = game_state().sacrifice_pub
        let pub2 = game_state().destroy_pub
        sacrifice_destroy.subscribe(pub)
        sacrifice_destroy.subscribe(pub2)

    //on leaving the stable unsubscribe
    def sac_or_destroy(caller):
        c = nil
        let pub = game_state().sacrifice_pub
        let pub2 = game_state().destroy_pub
        sacrifice_destroy.unsubscribe(pub)
        sacrifice_destroy.unsubscribe(pub2)

constructor ExtraLife(ca):
    let etl = ExtraLife{
        "Extra Life", "Extra_Life.png",
        """
        If a Unicorn card in your Stable is sacrificed or destroyed,
        you may SACRIFICE this card. If you do,
        bring that card from the discard pile directly into your Stable.	
        """,
        upgrade, RED, ca
    }

    etl.sacrifice_destroy = Subscriber<card_event>(etl)msg:
        let this, data = msg.get_data<card_event,ExtraLife>()
        let player, cards = data.player, data.cards

        guard this.c != nil and player != this.c
        if (exists(cards): _!=this):
            if this.cardAction.ask_to_activate(this.fmt()):
                let card = this.cardAction.choose_card(cards)
                this.cardAction.sacrifice(this.c, [this]::Card)
                this.cardAction.move(this.game_state().get_discard(),this.c.stable(),card)
                card.enter_stable(this.c)
    return etl

// ---

// Hex
class Hex: Card
    empty_hand = Subscriber<Player,Hex>()
    c:Player? = nil // maybe a bit redundant

    def enter_stable(caller):
        this.c = caller
        let pub = caller.empty_hand_pub
        empty_hand.subscribe(pub)

    def sac_or_destroy(caller):
        c = nil
        let pub = caller.empty_hand_pub
        empty_hand.unsubscribe(pub)

    def forced_activate(caller):
        print("Card: Hex, skipped draw phase")
        game_state().skip_draw()

constructor Hex(ca):
    let hex = Hex{
        "Hex", "Hex.png",
        """
        If this card is in your Stable at the beginning of your turn,
        skip your Draw phase. If at any time you have no cards in your hand,
        move this card to any player's Stable.	
        """,
        downgrade, MAGHB, ca
    }
    hex.empty_hand = Subscriber<Player>(hex)msg:
        let this, data = msg.get_data<Player,Hex>()
        guard this.c != nil and this.c == data: 
            error("this.c is nil in Hex")
            assert false
        let g = this.game_state()
        let chosen_player = this.cardAction.get_game().choose_player(g.get_players())
        this.cardAction.move(this.c.stable(),chosen_player.stable(), this)

    return hex


class UnicornAbduction: Card
    no_unicorns = Subscriber<Player,UnicornAbduction>()
    c:Player? = nil // maybe a bit redundant

    def enter_stable(caller):
        this.c = caller
        let pub = caller.no_unicorns_pub
        no_unicorns.subscribe(pub)

    def forced_activate(caller):
        print("forced")
        let chosen_card = cardAction.choose_card( filter(caller.stable()): _.is_unicorn )
        caller.remove_stable(chosen_card)
        cardAction.shuffle_into_deck(chosen_card)

constructor UnicornAbduction(ca):
    let uca = UnicornAbduction{
        "Unicorn Abduction", "Unicorn_Abduction.png",
        """
        If this card is in your Stable at the beginning of your turn,
        shuffle a Unicorn card from your Stable into the deck, then DRAW a card.
        If at anytime you have no Unicorn cards in your Stable,
        SACRIFICE this card.
        """,
        downgrade, GRN, ca
    }
    uca.no_unicorns = Subscriber<Player>(uca)msg:
        let this, data = msg.get_data<Player,UnicornAbduction>()
        guard this.c != nil and this.c == data: 
            error("this.c is nil in UnicornAbduction")
            assert false
        // unsubscribing must be done before sacrificing bc
        // it will go into a recursion loop if you dont unsub
        // before sacrificing
        let pub = this.c.no_unicorns_pub 
        this.no_unicorns.unsubscribe(pub)
        this.cardAction.sacrifice(this.c, this)
        this.c = nil
    return uca
    

class TemporalParadox: Card
    def activate(caller):
        cardAction.return_card_menu(caller)
constructor TemporalParadox(ca):
    return TemporalParadox{
        "Temporal Paradox", "Temporal_Paradox.png",
        "Return a card in any player\'s Stable to that player\'s hand and DRAW a card.",
        magic, BLU, ca
    }
