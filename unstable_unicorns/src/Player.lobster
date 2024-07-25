import Card

class Player:
    private username: string
    private id: int = -1
    private hand: [Card] = []
    private stable: [Card] = []// max 7 (win condition)
    private skip_turn: bool = false

    def draw(card: Card)://TODO: rename
        hand.push(card)

    def add_stable(card: Card):
        stable.push(card)
    
    def use(card_index: int)->Card:
        let c = hand.remove(card_index)
        if c.type != instant and c.type != magic:
            stable.push(c)
        return c

    def use(card: Card)->Card:
        let c = hand.remove_obj(card)
        if c.type != instant and c.type != magic:
            stable.push(c)
        return c
    
    def activate(card: Card):
        pass()
    
    def destroy(card: Card):
        print("{RED}destroyed{reset} {card.name} in {username}\'s stable")
        stable.remove_obj(card)

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