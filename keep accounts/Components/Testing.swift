import SwiftUI

struct TestView: View {
    @EnvironmentObject var accountingViewModel: AccountingViewModel
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "MM月dd日 EEEE"
        return formatter
    }()
    private let dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    var body: some View {
        
        List {
                Section{
                    HStack(alignment: .top) {
                        Text(dateFormatter.string(from: accountingViewModel.accountingSelectedDate))
                            .font(.system(size: 13, weight: .medium))
                    }
                    ForEach(accountingViewModel.selectedRecords,id: \.self) { item in
                        HStack{
                            Text(item.name).fontWeight(.medium).fontDesign(.monospaced).font(.system(size: 18))
                            Spacer()
                            VStack(alignment: .trailing,spacing: 4){
                                Text("-$\(item.amount)").fontWeight(.bold).fontDesign(.monospaced).foregroundColor(.red.opacity(0.9))
                                Text(dateFormatterTime.string(from: item.date)).font(.system(size: 12)).foregroundColor(.gray)
                            }
                        }
                        
                        .padding(.vertical,4)
                        .contextMenu {
//                            Button(role: .cancel) {
//                                print("cancel")
//                            } label: {
//                                Label("", systemImage: "trash")
//                            }
                            Button(role: .destructive,action: {
                                // 刪除項目的動作
                                print("delete")
                                   }) {
                                       Label("Delete", systemImage: "trash")
                                           
                            }

                        }
//                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                            Button {
//                                print("hi")
//                            } label: {
//                                Text("Delete")
//                            } .tint(.blue)
//                            
//                            Button {
//                                print("hi")
//                            } label: {
//                                Text("Mike")
//                            }
//                            .tint(.red)
//                            Button {
//                                print("hi")
//                            } label: {
//                                Text("Rax")
//                            }
//                            .tint(.blue)
//                            
//                        }
//                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                            Button {
//                                print("hi")
//                                
//                            } label: {
//                                Image(systemName: "pin")
//                            }
//                            .tint(.orange)
//                            
//                        }
                    }
                }
                .listRowBackground(Color.white)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView().environmentObject(AccountingViewModel.shared)
    }
}


//
//import SwiftUI
//
//// 交易記錄模型
//struct Transaction: Identifiable {
//    let id = UUID()
//    let category: String
//    let icon: String
//    let amount: Double
//    let time: String
//    let isIncome: Bool
//}
//
//// 日期分組模型
//struct DayGroup: Identifiable {
//    let id = UUID()
//    let date: String
//    let weekday: String
//    let transactions: [Transaction]
//    let totalIncome: Double
//    let totalExpense: Double
//}
//
//// 自定義圓形圖示
//struct CircleIcon: View {
//    let iconName: String
//    let backgroundColor: Color
//
//    var body: some View {
//        Image(systemName: iconName)
//            .foregroundColor(.white)
//            .font(.system(size: 24))
//            .frame(width: 48, height: 48)
//            .background(backgroundColor)
//            .clipShape(Circle())
//    }
//}
//
//// 交易記錄行
//struct TransactionRow: View {
//    let transaction: Transaction
//
//    var body: some View {
//        HStack {
//            CircleIcon(
//                iconName: transaction.icon,
//                backgroundColor: transaction.category == "紅包" ? .red : .blue
//            )
//
//            Text(transaction.category)
//                .font(.system(size: 17))
//
//            Spacer()
//
//            VStack(alignment: .trailing) {
//                Text(transaction.isIncome ? "+$\(String(format: "%.0f", transaction.amount))" : "-$\(String(format: "%.0f", transaction.amount))")
//                    .font(.system(size: 17, weight: .medium))
//                    .foregroundColor(transaction.isIncome ? .green : .red)
//
//                Text(transaction.time)
//                    .font(.system(size: 15))
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding(.vertical, 8)
//    }
//}
//
//// 日期標題
//struct DayHeader: View {
//    let group: DayGroup
//
//    var body: some View {
//        HStack {
//            Text("\(group.date) \(group.weekday)")
//                .font(.system(size: 17, weight: .medium))
//
//            Spacer()
//
//            HStack(spacing: 16) {
//                Text("收 $\(String(format: "%.0f", group.totalIncome))")
//                    .foregroundColor(.green)
//                Text("支 $\(String(format: "%.0f", group.totalExpense))")
//                    .foregroundColor(.red)
//            }
//            .font(.system(size: 15))
//        }
//        .padding(.vertical, 12)
//        .padding(.horizontal)
//    }
//}
//struct SectionBackgroundView: View {
//    var body: some View {
//        Color.white
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
//    }
//}
//struct ContentView2: View {
//    @State private var groups = [
//        DayGroup(
//            date: "1月17日",
//            weekday: "週五",
//            transactions: [
//                Transaction(category: "紅包", icon: "yensign.circle.fill", amount: 5, time: "下午 4:39", isIncome: true),
//                Transaction(category: "交通", icon: "bus.fill", amount: 5, time: "上午 10:43", isIncome: false)
//            ],
//            totalIncome: 5,
//            totalExpense: 5
//        )
//    ]
//    
//    var body: some View {
//        ZStack {
//            // 背景顏色
//            Color(red: 0.9, green: 1.0, blue: 0.9)
//                .edgesIgnoringSafeArea(.all)
//            
//            List {
//                ForEach(groups.indices, id: \.self) { groupIndex in
//                    Section {
//                        // 日期標題
//                        HStack {
//                            Text("\(groups[groupIndex].date) \(groups[groupIndex].weekday)")
//                                .font(.system(size: 17, weight: .medium))
//                            
//                            Spacer()
//                            
//                            HStack(spacing: 16) {
//                                Text("收 $\(String(format: "%.0f", groups[groupIndex].totalIncome))")
//                                    .foregroundColor(.green)
//                                Text("支 $\(String(format: "%.0f", groups[groupIndex].totalExpense))")
//                                    .foregroundColor(.red)
//                            }
//                            .font(.system(size: 15))
//                        }
//                        .padding(.vertical, 12)
//                        .listRowBackground(Color.clear)
//                        
//                        // 交易記錄
//                        ForEach(groups[groupIndex].transactions) { transaction in
//                            HStack {
//                                CircleIcon(
//                                    iconName: transaction.icon,
//                                    backgroundColor: transaction.category == "紅包" ? .red : .blue
//                                )
//                                
//                                Text(transaction.category)
//                                    .font(.system(size: 17))
//                                
//                                Spacer()
//                                
//                                VStack(alignment: .trailing) {
//                                    Text(transaction.isIncome ? "+$\(String(format: "%.0f", transaction.amount))" : "-$\(String(format: "%.0f", transaction.amount))")
//                                        .font(.system(size: 17, weight: .medium))
//                                        .foregroundColor(transaction.isIncome ? .green : .red)
//                                    
//                                    Text(transaction.time)
//                                        .font(.system(size: 15))
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            .padding(.vertical, 8)
//                            .listRowBackground(Color.clear)
//                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                Button(role: .destructive) {
//                                    groups[groupIndex].transactions.removeAll { $0.id == transaction.id }
//                                } label: {
//                                    Label("刪除", systemImage: "trash")
//                                }
//                                
//                                Button {
//                                    // 更多操作
//                                } label: {
//                                    Label("更多", systemImage: "ellipsis")
//                                }
//                                .tint(.gray)
//                                
//                                Button {
//                                    // 複製操作
//                                } label: {
//                                    Label("複製", systemImage: "doc.on.doc")
//                                }
//                                .tint(.blue)
//                            }
//                        }
//                    }
//                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                    // 為每個 Section 添加自定義背景
//                    .background(SectionBackgroundView())
//                }
//            }
//            .listStyle(.insetGrouped)
//        }
//    }
//}
//#Preview {
//    ContentView2()
//}
