import dictionary

import Card
import Game
import CardAction

class card_data:
  name: string
  img: string
  text: string
  type: string
  quantity: string
  deck: string

abstract class parser:
    def parse_file(g: Game) -> [Card],[Card]: //):
        return [],[]

class json_parser: parser
    file_name: string = "../data/data_copy.json"

    
    /*
    def convert_data(card: card_data) -> Card:
        let type2enum = dictionary<string,CardType>() // TODO: find number
        type2enum.add("Baby Unicorn", instant)
        type2enum.add("Magic", magic)
        type2enum.add("Upgrade", upgrade)
        type2enum.add("Downgrade", downgrade)
        type2enum.add("Baby Unicorn", baby_unicorn)
        type2enum.add("Basic Unicorn", basic_unicorn)
        type2enum.add("Magical Unicorn", magical_unicorn)
        type2enum.add("Ultimate Unicorn", ultimate_unicorn)

        // let class_name: string = replace_string(card.name, " ", "")
        // let type: CardType = type2enum.get(card.type)

        // let rez = switch class_name:
        //     case "Baby Unicorn (Pink)": nil //UnicornPoison{}
        //     case "Baby Unicorn (Pink)": nil
        //     default: nil //TODO: make black pink error card

        // return rez
        return UnicornPoison{"help", "help", "help", magic, "", }
    */

    def parse_file():
        let json = read_file(file_name)
        if json == nil:
            print("error: file not found")
            assert false

        let str = substring(json, 1, json.length()-2)

        let rez = map(tokenize(str,"\}"," "))s:
                    map(tokenize(s, "\n", " "))a:
                        let i = find_string(a, ":")
                        if(i!=-1):
                            substring(a, i+1, -1)
                        else:
                            ""
        rez.pop()

        let card_arr = map(rez)r:
            let r2 = escape_string(sum(r), "\'", "\\", "")
            parse_data(typeof card_data, "card_data\{ {r2} \}")
            //TODO: just take the first index of r and make that the class/obj name
            // then take the rest as attributes

        map(card_arr)c,i:
            if c != nil:
                convert_data(c)
            else:
                nil
        return [],[]

class mock_parser: parser
    def parse_file(game: Game):
        let cardAction = CardAction{game}

        let bb=BabyUnicorn_Pink{
                "Baby Unicorn (Pink)",
                "Baby_Unicorn_(Pink).png",
                "If this card would be sacrificed, destroyed, or returned to your hand, return it to the Nursery instead.",
                baby_unicorn,
                BBLK,
                cardAction
            }
            
        let bb2=BabyUnicorn_Red{
                "Baby Unicorn (Red)",
                "Baby_Unicorn_(Red).png",
                "If this card would be sacrificed, destroyed, or returned to your hand, return it to the Nursery instead.",
                baby_unicorn,
                BGRN,
                cardAction
            }

        let poison = UnicornPoison{
                "Unicorn Poison",
                "Unicorn_Poison.png",
                "DESTROY a Unicorn.",
                magic,
                BGRN,
                cardAction
            }
        let bku = BlackKnightUnicorn{
                "Black Knight Unicorn",
                "Black_Knight_Unicorn.png",
                "If one of your Unicorns would be destroyed, you may SACRIFICE this card instead.",
                magical_unicorn,
                BLKHB,
                cardAction
            }
        let swh = SharkWithAHorn{
                "Shark With A Horn",
                "Shark_With_A_Horn.png",
                "When this card enters your Stable, you may DESTROY a Unicorn. If you do, SACRIFICE this card.",
                magical_unicorn,
                BLU,
                cardAction
            }
        let tfo = TwoForOne{
            "Two-For-One",
            "Two-For-One.png",
            "SACRIFICE a card, then DESTROY two cards.",
            magic,
            YEL,
            cardAction
        }

        let gtb = GlitterBomb{
            "Glitter Bomb",
            "Glitter_Bomb.png",
            "If this card is in your Stable at the beginning of your turn, you may SACRIFICE a card, then DESTROY a card.",
            upgrade,
            GRN,
            cardAction
        }


        return [
            bb.copy(), bb.copy(), bb.copy(), bb2.copy(),
        ],[
            gtb.copy(),
            tfo.copy(),
            swh.copy(),
            poison.copy(),
            //-------
            gtb.copy(),
            poison.copy(),
            tfo.copy(),
            bku.copy(),
            //-------
            bku.copy(), 
            gtb.copy(),
            poison.copy(),
            bku.copy(),
             swh.copy(), swh.copy(),
            poison.copy(), poison.copy(), poison.copy(),
            bku.copy(), bku.copy(), bku.copy(),
            swh.copy(), swh.copy(), swh.copy(),
        ]