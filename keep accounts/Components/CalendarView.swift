//
//  Calendar.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/17.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @EnvironmentObject var accountingViewModel: AccountingViewModel
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter
    }()
    
    private let daysOfWeek = ["日", "一", "二", "三", "四", "五", "六"]
    
    private var monthDays: [[Date?]] {
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        
        // 获取当月第一天
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let firstDayOfMonth = calendar.date(from: components)!
        
        // 获取当月天数
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        
        // 获取第一天是周几
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        // 添加当月的日期
        for day in 1...daysInMonth {
            components.day = day
            if let date = calendar.date(from: components) {
                days.append(date)
            }
        }
        
        // 补全最后一周
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        // 将数组分成每周一组
        return stride(from: 0, to: days.count, by: 7).map {
            Array(days[$0..<min($0 + 7, days.count)])
        }
    }
    var body: some View {
        VStack {
            // 标题和月份切换
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Text(dateFormatter.string(from: selectedDate))
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .font(.system(size: 16))
                    .padding(.horizontal)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // 星期标题行
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 日期网格
            VStack{
                ForEach(monthDays.indices, id: \.self) { week in
                    HStack {
                        ForEach(0..<7) { day in
                            if let date = monthDays[week][day] {
                                Button(action:{
                                    accountingViewModel.findRecord(for: date)
                                    
                                }){
                                    Text("\(calendar.component(.day, from: date))")
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .foregroundColor(.black.opacity(0.8))
                                        .fontDesign(.serif)
                                        .background(
                                            calendar.isDate(date, inSameDayAs: Date()) ?
                                            Color.purple.opacity(0.7) :
                                                Color.purple.opacity(0.1)
                                        )
                                        .background(
                                            calendar.isDate(accountingViewModel.accountingSelectedDate, inSameDayAs: date) ?
                                            Color.blue.opacity(0.3) :
                                                Color.clear
                                        )
                                        .cornerRadius(8)
                                }
                            } else {
                                //補空白的地方
                                Text("")
                                    .frame(maxWidth: .infinity, minHeight: 40)
                            }
                        }
                    }
                }
            }.padding(.bottom,16).padding(.horizontal,8)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView().environmentObject(AccountingViewModel.shared)
    }
}
