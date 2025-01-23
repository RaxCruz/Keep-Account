//
//  AccountingRecords.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/20.
//

import Foundation

struct AccountingRecords: Identifiable {
    let id: UUID = UUID()
    let recordDate: Date
    var items: [AccountingItem]
}

struct AccountingItem: Identifiable,Hashable {
    let id: UUID = UUID()
    var name: String
    var type: String
    var amount: String
    var date: Date
}
