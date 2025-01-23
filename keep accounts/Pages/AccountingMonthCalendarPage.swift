//
//  AccountingMonthCalendarPage.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/17.
//

import SwiftUI

struct AccountingMonthCalendarPage: View {
    var body: some View {
        VStack{
            CalendarView()
            TestView()
            Spacer()
        }
    }
}

#Preview {
    AccountingMonthCalendarPage().environmentObject(AccountingViewModel.shared)
}
