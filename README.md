# ProjectWeSplit3
Paul Hudson 100DaysOfSwiftUI


DAY 17

Creating pickers in a form


SwiftUI’s pickers serve multiple purposes, and exactly how they look depends on which device you’re using and the context where the picker is used.
Pickers, like text fields, need a two-way binding to a property so they can track their value.

So, picker doesn’t just read the value of paymentType, it also writes the value. This is what’s called a two-way binding, because any changes to the value of paymentType will update the picker, and any changes to the picker will update paymentType.

This is where the dollar sign comes in: Swift property wrappers use that to provide two-way bindings to their data, so when we say $paymentType SwiftUI will write the value using the property wrapper, which will in turn stash it away and cause the UI to refresh automatically.

At first glance all these @ and $s might seem a bit un-Swifty, however, they allow us to get features that would otherwise require a lot of hassle:

* Without @State we wouldn’t be able to change properties in our structs, because structs are fixed values.
* Without StateObject we wouldn’t be able to create classes that stay alive for the duration of our app.
* Without @EnvironmentObject we wouldn’t be able to receive shared data from elsewhere in our app.
* Without ObservableObject we wouldn’t be notified when an external value changes.
* Without $property two-way bindings we would need to update values by hand.


Adding a segmented control for tip percentages

Now we’re going to add a second picker view to our app, but this time we want something slightly different: we want a segmented control. This is a specialized kind of picker that shows a handful of options in a horizontal list, and it works great when you have only a small selection to choose from.


Calculating the total per person

There are a few ways we could solve this, but the easiest one also happens to be the cleanest one, by which I mean it gives us code that is clear and easy to understand: we’re going to add a computed property that calculates the total. 

We have a name property that for example stores a String
Swift has another different kind of property called a computed property – a property that runs code to figure out its value.

This needs to do a small amount of mathematics: the total amount payable per person is equal to the value of the order, plus the tip percentage, divided by the number of people. 

First, add the computed property itself, just before the body property: 

var totalPerPerson: Double {
    // calculate the total per person here
    return 0
} 

Next, we can figure out how many people there are by reading numberOfPeople and adding 2 to it. Remember, this thing has the range 2 to 100, but it counts from 0, which is why we need to add the 2.

You’ll notice that converts the resulting value to a Double because it needs to be used alongside the checkAmount. 

For the same reason, we also need to convert our tip percentage into a Double.

Now that we have our input values, it’s time do our mathematics. This takes another three steps:
* We can calculate the tip value by dividing checkAmount by 100 and multiplying by tipSelection.
* We can calculate the grand total of the check by adding the tip value to checkAmount.
* We can figure out the amount per person by dividing the grand total by peopleCount.


Replace return 0 in the property with this: return amountPerPerson 

If you’ve followed everything correctly your code should look like this: 

var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
    let tipSelection = Double(tipPercentage)

    let tipValue = checkAmount / 100 * tipSelection
    let grandTotal = checkAmount + tipValue
    let amountPerPerson = grandTotal / peopleCount

    return amountPerPerson
} 


Now that totalPerPerson gives us the correct value, we can change the final section in our table so it shows the correct text. 

Section {
    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
} 


All the values that make up our total are marked with @State, changing any of them will cause the total to be recalculated automatically.


Hiding the keyboard


Once the keyboard appears for the check amount entry, it never goes away!

This is a problem with the decimal and number keypads, because the regular alphabetic keyboard has a return key on there to dismiss the keyboard. However, with a little extra work we can fix this:
1. We need to give SwiftUI some way of determining whether the check amount box should currently have focus – should be receiving text input from the user.
2. We need to add some kind of button to remove that focus when the user wants, which will in turn cause the keyboard to go away.
To solve the first one you need to meet your second property wrapper: @FocusState. This is exactly like a regular @State property, except it’s specifically designed to handle input focus in our UI. 

@FocusState private var amountIsFocused: Bool

Now we can attach that to our text field, so that when the text field is focused amountIsFocused is true, otherwise it’s false. Add this modifier to your TextField:

.focused($amountIsFocused)

That’s the first part of our problem solved: although we can’t see anything different on the screen, SwiftUI is at least silently aware of whether the text field should have focus or not.
The second part of our solution is to add a toolbar to the keyboard when it appears, so we can place a Done button in there.

.toolbar {
    ToolbarItemGroup(placement: .keyboard) {           
        Button("Done") {
            amountIsFocused = false
        }
    }
}


1. The toolbar() modifier lets us specify toolbar items for a view. These toolbar items might appear in various places on the screen – in the navigation bar at the top, in a special toolbar area at the bottom, and so on.
2. ToolbarItemGroup lets us place one or more buttons in a specific location, and this is where we get to specify we want a keyboard toolbar – a toolbar that is attached to the keyboard, so it will automatically appear and disappear with the keyboard.
3. The Button view we’re using here displays some tappable text, which in our case is “Done”. We also need to provide it with some code to run when the button is pressed, which in our case sets amountIsFocused to false so that the keyboard is dismissed.


Before we’re done, there’s one last small change: 

That adds one small but important new view before the button, called Spacer. This is a flexible space by default – wherever you place a spacer it will automatically push other views to one side. That might mean pushing them up, down, left, or right depending on where it’s used, but by placing it first in our toolbar it will cause our button to be pushed to the right.

ToolbarItemGroup(placement: .keyboard) {
    Spacer()

    Button("Done") {
        amountIsFocused = false
    }
}


The difference – it’s really minor, but having the Done button on the right of the keyboard is also the same thing other iOS apps do.
