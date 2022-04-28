//
//  ContentView.swift
//  WeSplit3
//
//  Created by Marko Zivanovic on 26.4.22..
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    
    let tipPerecentages = [15, 20, 25, 0]
    
    //MARK: Calculate the total amount per person
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    //MARK: Challenge 2. Add another section showing the total amount for the check – i.e., the original amount plus tip value, without dividing by the number of people.
    var checkGrandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount,format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip perecentage", selection: $tipPercentage) {
                        ForEach(tipPerecentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    //MARK: pickerStyle(.manu, .inline, .segmented, .automatic, .weel)
                    .pickerStyle(.segmented)
                    //MARK: Header trailing closing closure
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(checkGrandTotal, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Check aamounm with tip value")
                }
                
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    //MARK: Challenge 1. Add a header to the third section, saying “Amount per person”
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("We Split")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

