//
//  keep_accountsApp.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/17.
//

import SwiftUI

@main
struct keep_accountsApp: App {
    var body: some Scene {
        WindowGroup {
            HomePage().environmentObject(AccountingViewModel.shared)
        }
    }
}
