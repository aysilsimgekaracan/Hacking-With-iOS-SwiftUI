//
//  Expenses.swift
//  Project7-iExpense
//
//  Created by Ayşıl Simge Karacan on 6.08.2023.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items")  {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)  {
                items = decodedItems
                return
            }
        }
        items = []
    }
}
