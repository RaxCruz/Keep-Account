//
//  HomePage.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/21.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("首頁", systemImage: "house.fill")
                }
                .tag(0)

            AccountingMonthCalendarPage()
                .tabItem {
                    Label("個人資料", systemImage: "person.fill")
                }
                .tag(1)

        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
//import AnimatedTabBar
//
//struct BottomNavItem:View {
//    let icon: String
//    let title: String
//    let tag: Int
//    var body: some View {
//        Image(systemName: icon)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 24, height: 24)
//    }
//}
//
//
//struct HomePage: View {
//    @State private var selectedIndex = 0
//    
//    let navItems = [
//        BottomNavItem(icon: "tray", title: "設備", tag: 0),
//        BottomNavItem(icon: "safari", title: "服務", tag: 1),
//    ]
//    
//    var body: some View {
//        ZStack {
//            // 上方主內容
//            ZStack {
//                switch selectedIndex {
//                case 0: ContentView()
//                case 1: AccountingMonthCalendarPage()
//                default: Text("預設內容")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            VStack {
//                Spacer()
//                AnimatedTabBar(selectedIndex: $selectedIndex,views:navItems)
//                    .barColor(.blue)
//                    .ballColor(.blue)
//                    .selectedColor(.white)
//                    .unselectedColor(.white.opacity(0.5))
//                    .ballTrajectory(.straight)
//   
//                
//            }.ignoresSafeArea(.all)
//        }
//    }
//}
    
struct HomeView: View {
    var body: some View {
        Text("這是首頁")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("這是個人資料頁面")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("這是設定頁面")
    }
}

#Preview {
    HomePage().environmentObject(AccountingViewModel.shared)
}
