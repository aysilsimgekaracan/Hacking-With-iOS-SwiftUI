//
//  ContentView.swift
//  Project7-iExpense
//
//  Created by Ayşıl Simge Karacan on 5.08.2023.
//

import SwiftUI

struct ExpenseSection: View {
    let header: String
    let expenseType: String
    let expenses: [ExpenseItem]
    let onRemove: (IndexSet) -> Void
    
    var body: some View {
        Section {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundColor(item.amount > 10 && item.amount < 100  ? .yellow : (item.amount <= 10 ? .black : .red))
                }
                
            }
            .onDelete(perform: onRemove)
        } header : {
            Text(header)
        }
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(getAllExpenseTypes()), id: \.self) { type in
                        ExpenseSection(header: "\(type) Expenses", expenseType: "\(type)", expenses: expensesForType(type)) { indexSet in
                            removeItems(at: indexSet, for: type)
                        }
                    }

                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
        
    }
    
    func getAllExpenseTypes() -> Set<String>  {
        Set(expenses.items.map {$0.type})
    }
    
    func expensesForType(_ type: String) -> [ExpenseItem] {
        expenses.items.filter {
                $0.type == type
            }
        }
    
    func removeItems(at offsets: IndexSet, for type: String) {
        let chosenElement = expensesForType(type)[offsets.first!]
        let uuid = chosenElement.id
        let index = expenses.items.firstIndex(where: { $0.id == uuid })!
        expenses.items.remove(at: index)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
