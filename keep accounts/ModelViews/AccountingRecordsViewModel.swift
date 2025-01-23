//
//  AccountingRecordsViewModel.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/20.
//

import Foundation
import Combine

class AccountingViewModel: ObservableObject {
    // 使用日期字串作為鍵值以便快速查找
    @Published var records: [Date?: [AccountingItem]] =
    [
        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 21)): [AccountingItem(name: "🥤 飲料", type: "add", amount: "45", date: Date())]
    ]
    @Published var accountingSelectedDate: Date = Date()
    @Published var selectedRecords: [AccountingItem] = []
    
    static let shared = AccountingViewModel()
    
    private init() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let formatDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
        findRecord(for:formatDate!)
    }  // 防止外部創建新的實例
    
    func findRecord(for date: Date) {
        accountingSelectedDate = date
        print(accountingSelectedDate)
        if let records = records[date] {
            selectedRecords = records
        }else{
            records[date] = []
            selectedRecords = []
        }
        print("找到資料\(selectedRecords)")
    }
    // 搜尋指定日期的帳單
//    func getRecords(for date: Date) -> [AccountingItem] {
//        let dateKey = dateFormatter.string(from: date)
//        return records[dateKey] ?? []
//    }
//
    // 新增一筆帳單記錄
    func addRecord(item: AccountingItem) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let formatDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
        if var record = records[formatDate] {
            record.append(item)
            records.updateValue(record, forKey: formatDate)
            findRecord(for: formatDate!)
            
        }else{
            records[formatDate] = [item]
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "MM月dd日 EEEE"
        return formatter
    }()
}
