//
//  ContentView.swift
//  Challenge1-Converter
//
//  Created by Ayşıl Simge Karacan on 29.06.2023.
//

import SwiftUI

struct ContentView: View {
    let lengthTypes: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
    
    @State private var inputLengthType: UnitLength = .meters
    @State private var outputLengthType: UnitLength = .meters
    @State private var value: Double = 0
    @FocusState private var valueIsFocused: Bool
    
    var conversionResult : Measurement<UnitLength> {
        
        let inputLength = Measurement(value: value, unit: inputLengthType)
        let conversion = inputLength.converted(to: outputLengthType)
        
        return conversion
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Length Conversion
                Section {
                    Picker("From:", selection: $inputLengthType) {
                        ForEach(lengthTypes, id: \.self) { length in
                            Text(length.symbol)
                        }
                    } .pickerStyle(.segmented)
                    
                    TextField("Value", value: $value, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($valueIsFocused)
                    
                    Picker("To:", selection: $outputLengthType) {
                        ForEach(lengthTypes, id: \.self) { length in
                            Text(length.symbol)
                        }
                    } .pickerStyle(.segmented)
     
                    
                } header: {
                    Text("Length Conversion")
                }
                
                Section {
                    Text("\(conversionResult.value.formatted()) \(conversionResult.unit.symbol)")
                } header: {
                    Text("Result")
                }
            }
            
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        valueIsFocused = false
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
