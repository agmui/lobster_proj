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

// abstract class Card:
class Card:
    name: string 
    img: string 
    text: string 
    type: CardType 
    cli_color: string
    cardAction: CardAction // = CardAction{}

    def play(caller):
        print("{GRN}({caller.name}) plays {name}{reset}\n")
        if type == magic or type == instant:
            activate(caller)
        else:
            enter_stable(caller)
    
    def enter_stable(caller):
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

class BabyUnicorn_Pink: Card
class BabyUnicorn_Red: Card

class UnicornPoison: Card
    // text: string = "DESTROY a Unicorn."

    def activate(caller):
        cardAction.destroy(caller)

class BlackKnightUnicorn: Card
//   text: string = "If one of your Unicorns would be destroyed, you may SACRIFICE this card instead."


class SharkWithAHorn: Card
//   text: string = "When this card enters your Stable, you may DESTROY a Unicorn. If you do, SACRIFICE this card."

    def play():
        print("played {name}")

    def activate():
        pass()

class TwoForOne: Card
//	SACRIFICE a card, then DESTROY two cards.
    def activate(caller):
        cardAction.sacrifice(caller)
        cardAction.destroy(caller)

class GliterBomb: Card
// If this card is in your Stable at the beginning of your turn,
// you may SACRIFICE a card, then DESTROY a card.