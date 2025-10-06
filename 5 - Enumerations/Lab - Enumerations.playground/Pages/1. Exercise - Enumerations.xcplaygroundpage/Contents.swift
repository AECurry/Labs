/*:
## Exercise - Enumerations
 
 Define a `Suit` enum with four possible cases: `clubs`, `spades`, `diamonds`, and `hearts`.
 */
enum Suit {
    case clubs
    case spades
    case diamonds
    case hearts
}
//:  Imagine you are being shown a card trick and have to draw a card and remember the suit. Create a variable instance of `Suit` called `cardInHand` and assign it to the `hearts` case. Print out the instance.
var cardInHand: Suit
cardInHand = .hearts
print(cardInHand)

//:  Now imagine you have to put back the card you drew and draw a different card. Update the variable to be a spade instead of a heart.
cardInHand = .spades
print(cardInHand)

//:  Imagine you are writing an app that will display a fun fortune (i.e. something like "You will soon find what you seek.") based on cards drawn. Write a function called `getFortune(cardSuit:)` that takes a parameter of type `Suit`. Inside the body of the function, write a switch statement based on the value of `cardSuit`. Print a different fortune for each `Suit` value. Call the function a few times, passing in different values for `cardSuit` each time.
func getFortune(cardSuit: Suit) {
    switch cardSuit {
    case.clubs:
        print("Clubes: a challenge is coming, but you are ready for it!")
    case.spades:
        print("Spades: You will soon find what you seek. Don't give up hope!")
    case.diamonds:
        print("Diamonds: A surprise gift of money is on it's way!")
    case.hearts:
        print("Hearts: You will find love and joy in unexpected ways today! Keep your heart open.")
    }
}
getFortune(cardSuit: .hearts)
getFortune(cardSuit: .spades)
getFortune(cardSuit: .diamonds)
getFortune(cardSuit: .clubs)
//:  Create a `Card` struct below. It should have two properties, one for `suit` of type `Suit` and another for `value` of type `Int`.
struct Card {
    enum Value {
        case ace
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king
    }
    var suit: Suit
    var value: Value
}

let firstCard = Card(suit: .hearts, value: .queen)
let secondCard = Card(suit: .spades, value: .ace)
let thirdCard = Card(suit: .diamonds, value: .ten)

print("Your card is the \(firstCard.value) of \(firstCard.suit).")
print("Your card is the \(secondCard.value) of \(secondCard.suit).")
print("Your card is the \(thirdCard.value) of \(thirdCard.suit)")
//:  How many values can playing cards have? How many values can `Int` be? It would be safer to have an enum for the card's value as well. Inside the struct above, create an enum for `Value`. It should have cases for `ace`, `two`, `three`, `four`, `five`, `six`, `seven`, `eight`, `nine`, `ten`, `jack`, `queen`, `king`. Change the type of `value` from `Int` to `Value`. Initialize two `Card` objects and print a statement for each that details the card's value and suit.
//answer given above

/*:
page 1 of 2  |  [Next: App Exercise - Swimming Workouts](@next)
 */
