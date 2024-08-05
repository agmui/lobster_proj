import const
import Card

class Player:
    private username: string
    private id: int = -1
    private hand: [Card] = []
    private stable: [Card] = []// max 7 (win condition)
    private skip_turn: bool = false
    empty_hand_pub = Publisher<Player>{"hand_empty_pub"}
    no_unicorns_pub = Publisher<Player>{"no_unicorns_pub"}

    def draw(card: Card)://TODO: rename
        hand.push(card)

    def add_stable(card: Card):
        stable.push(card)
    
    def use(card_index: int)->Card:
        let c = discard(card_index) //hand.remove(card_index)
        if c.type != instant and c.type != magic:
            // stable.push(c)
            add_stable(c)
        return c

    def use(card: Card)->Card:
        let c = discard(card) //hand.remove_obj(card)
        if c.type != instant and c.type != magic:
            // stable.push(c)
            add_stable(c)
        return c
    
    def return_to_hand(cards:[Card]):
        remove_stable(cards)
        for(cards)card:
            hand.push(card)
    
    def remove_stable(cards: [Card]):
        for(cards)card:
            remove_stable(card)

    def remove_stable(card: Card):
        //TODO: check if card in stable
        stable.remove_obj(card)
        if(not exists(stable): _.is_unicorn):
            no_unicorns_pub.publish(this)

    //TODO: check if card in hand
    def discard(card_index:int)->Card:
        //FIXME: move() breaks this
        let removed_card = hand.remove(card_index)
        if hand.len == 0:
            empty_hand_pub.publish(this)
        return removed_card
    def discard(card:Card)->Card:
        let removed_card = hand.remove_obj(card)
        if hand.len == 0:
            empty_hand_pub.publish(this)
        return removed_card
    def discard(card:[Card]):
        return map(card)c:
            discard(c)

    def id():
        return id
    
    def set_id(num: int):
        this.id = num

    def name():
        return username
    
    def hand():
        return hand
    
    def stable():
        return stable
    
    def fmt():
        return username+" "+concat_string((map(hand):_.name),", ")

