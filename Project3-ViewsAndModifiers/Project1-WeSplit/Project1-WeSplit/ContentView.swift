//
//  ContentView.swift
//  Project1-WeSplit
//
//  Created by Ayşıl Simge Karacan on 28.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    var currencyTypeFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD" )
        
    }
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var grandTotal: Double {
        // Calculate the grand total (
        let tipSelection = Double(tipPercentage)
    
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        
        return grandTotal
    }
    
    var totalPerPeron: Double {
        // Calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD" ))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    // .pickerStyle(.navigationLink)
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                    
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(grandTotal, format: currencyTypeFormat)
                        .foregroundColor(tipPercentage == 0 ? .red: .black)
                } header: {
                    Text("Grand Total")
                }
                
                Section {
                    Text(totalPerPeron, format: currencyTypeFormat)
                        .foregroundColor(tipPercentage == 0 ? .red: .black)
                            
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
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
