import std
import dictionary

import utils
import terminal_colors

import const
// import CardAction
import Card
import Player

class GameState: 
    private players: [Player] = []

    private deck: [Card] = []
    private discard: [Card] = []
    private nursery: [Card] = []

    private current_player_id_turn: int = 0 // TODO: make random
    private cur_player_turn: Player = Player{""}
    private num_rounds: int = 0
    private cur_phase:phase = beginning_phase
    private end_phase_queue:[Resolver] = []

    def init_cards(parsed_nursery, parsed_deck):
        this.nursery, this.deck = parsed_nursery, parsed_deck
    
    def shuffle_deck():
        // shuffle(deck)// from std
        pass()

    def update_player_turn():
        current_player_id_turn = (current_player_id_turn+1)%players.len()
        cur_player_turn = this.players[current_player_id_turn]
        num_rounds+=1

    def deal_hands():
        // everyone gets 1 bb unicorn
        for(players)p:
            p.add_stable(nursery.remove(0))

        // everyone draws 4 cards
        for(players)p:
            for(4):
                p.draw(deck.remove(0))
        // == debug ==
        players[0].add_stable(deck.remove(0))
        // ===========

    def init():
        cur_player_turn = players[0]
        shuffle_deck()
        deal_hands()

    def draw(player: Player)->Card:
        player.draw(deck.remove(0))

    def draw(player, num:int)->[Card]: //):
        player.draw(map(num): deck.remove(0))
    
    def discard(cards: [Card]):
        for(cards)c:
            discard(c)

    def discard(card: Card):
        discard.push(card)

    def add_player(p: Player):
        pass()
        // cur_player_turn = this.players[current_player_id_turn]

    def add_players(p_arr: [Player]):
        this.players = p_arr
        for(p_arr)p,i:
            p.set_id(i)
    
    def update_phase(phase: phase):
        cur_phase = phase
    
    def add_to_end_phase(c:Resolver):
        print("add to end")
        end_phase_queue = end_phase_queue.push(c)

    def remove_from_end_phase(c:Resolver)://TODO: this is extremely jank, make better system
        print("remove from to end")
        end_phase_queue.remove_obj(c)

    def end_phase_cleanup():
        for(end_phase_queue)c:// TODO: maybe just store arr of the cards and have the cards have their own methods to "solve" end_turn
            if c.end_phase_resolver() == false:
                error("end of phase error")//TODO: make better
                assert false
    
    def current_players_turn():
        return cur_player_turn
    
    def num_rounds():
        return num_rounds

    def fmt(stack):
        if stack.len() > 7:
            return "["+concat_string(map(stack.slice(0,7)):_.fmt(), " | ")+" ... ]"
        return "["+concat_string(map(stack):_.fmt(), " | ")+" ]"
    
    def get_deck():
        return deck

    def get_players():
        return players

    def get_phase()->phase:
        return cur_phase
    
    def is_beginning_phase()->bool:
        return cur_phase == beginning_phase
    
    def is_end_phase()->bool:
        return cur_phase == end_phase

    def hformat<T>(arr:[[T]], min_pad_size=5, colum_size=2):
        var biggest = arr[0].len()
        for(arr)a:
            if biggest < a.len():
                biggest = a.len()
        
        let longest_char = max(map(arr)a: max(map(a)i: strip_ansi_code("{i}").length))
        let pad_size = max(longest_char, min_pad_size)

        let pad = fn len: repeat_string(" ", len)
        var str = ""
        for(biggest)i:
            for(arr)a:
                if i < a.len:
                    let c = string(a[i])
                    // str += BLUHB
                    str += c + pad(pad_size-strip_ansi_code(c).length) + reset
                else:
                    str += pad(pad_size)
                str += pad(colum_size)
            str +="\n"
        return str
    def table_print<T>(arr:[[T]], head_color=GRNB, body_color=BLUB, min_pad_size=5, colum_size=2):
        // highlights first entry in different color
        var biggest = arr[0].len()// TODO: use find_best()
        for(arr)a:
            if biggest < a.len():
                biggest = a.len()
        
        let longest_char = max(map(arr)a: max(map(a)i: strip_ansi_code("{i}").length))
        let pad_size = max(longest_char, min_pad_size)

        let pad = fn len: repeat_string(" ", len)
        var str = ""
        for(biggest)i:
            for(arr)a:
                if i < a.len:
                    let c = string(a[i])
                    if i == 0: str += head_color
                    else: str += body_color 
                    str += " "
                    str += c
                    str += pad(pad_size-strip_ansi_code(c).length)
                    str += " " + reset
                else:
                    str += pad(pad_size)
                str += pad(colum_size)
            str +="\n"
        return str
    
    def deck_info()->string:
        return "{BGRN}deck:{reset} {fmt(deck)}\n"+
        "nursery:{reset} {fmt(nursery)}\n"+
        "{BLK}discard:{reset} {fmt(discard)}\n"+
        "{BCYN}current turn: {BYEL}{current_players_turn().name}{reset}\n"

    def fmt():
        let get_cards = fn cards: map(cards)c,i: " {i+1} {c.fmt()}  "
        let player_info =
            map(players)p:
                cons(GRNB+p.name+" (hand)",get_cards(p.hand()))
                    .append_into(cons("",cons(REDB+"stable",get_cards(p.stable()))))
        return hformat(player_info)


