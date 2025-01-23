//
//  ContentView.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/17.
//

import SwiftUI
import PopupView
struct AccountingAmount : Identifiable {
    let id: UUID
    var type: String //expenses,income
    var amount: Double
}

struct ContentView: View {
    @State private var money: String = ""
    @State private var isDisplaySmallLabel: Bool = false
    @State private var selectedItem: String?
    @State private var selectedCategory: String?
    @EnvironmentObject var accountingViewModel: AccountingViewModel
    var body: some View {
        NavigationStack {
            VStack {
                //顯示金額
                DisplayMoneyPanel(money:$money)
                Spacer()
                //粗分標籤
                AccountRecordBigLabel(isDisplaySmallLabel:$isDisplaySmallLabel,selectedItem: $selectedItem)
                //細分標籤
                if selectedItem != nil {
                    AccountRecordSmallLabel(selectedItem: $selectedItem,selectedCategory: $selectedCategory)
                       }
                //數字按鍵
                CalculatorButtonPanel(money:$money,selectedItem: $selectedItem,selectedCategory: $selectedCategory)
            }
            .navigationTitle(Text("記帳計算機")).navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    ContentView().environmentObject(AccountingViewModel.shared)
}

struct DisplayMoneyPanel: View {
    @Binding var money: String
    var body: some View {
        VStack{
            Text(money.isEmpty ? "0" : money)
                .font(.system(size: 50)) // 設定初始字體大小
                .lineLimit(1)            // 限制行數為1
                .minimumScaleFactor(0.5) // 最小縮放比例 50%
        }.padding().frame(maxWidth:.infinity,minHeight: 400)
    }
}

struct AccountRecordBigLabel: View {
    let labelItem = ["餐飲","交通","購物","娛樂","居家","工作"]
    @Binding var isDisplaySmallLabel: Bool
    @Binding var selectedItem: String?
    var body: some View {
        HStack{
            ForEach(labelItem,id: \.self) { item in
                Button(action:{
                    withAnimation{
                        selectedItem = (selectedItem == item) ? nil : item // Toggle selection
                        isDisplaySmallLabel.toggle()
                    }
                }){
                    Text(item)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(selectedItem == item ? Color.purple.opacity(0.8) : Color.purple.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .fontWeight(.bold)
                }
            }

        }
    }
}

struct CalculatorButtonPanel: View {
    @Binding var money: String
    @Binding var selectedItem: String?
    @Binding var selectedCategory: String?
    @State var showPopup = false
    @State var showErrorPopup = false
    @State var isCalculation = false
    @State var isAddorMinus = true
    @EnvironmentObject var accountingViewModel: AccountingViewModel
    let buttonItem = ["7","8","9","<","4","5","6","+/-","1","2","3","*/÷","收入","0",".","記帳"]
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(buttonItem,id: \.self) { item in
                Button(action:{
                    handleButtonPress(item)
                }){
                    Text(item)
                        .padding()
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .foregroundStyle(.white)
                        .background(handleButtonBackgroundColor(item))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                }.popup(isPresented: $showPopup) {
                    FloatTopSecond()
                } customize: {
                    $0
                        .type(.floater())
                        .position(.top)
                        .closeOnTapOutside(true)
                        .dragToDismiss(true)
                }
                .popup(isPresented: $showErrorPopup) {
                    FloatTopError()
                } customize: {
                    $0
                        .type(.floater())
                        .position(.top)
                        .closeOnTapOutside(true)
                        .dragToDismiss(true)
                }
            }

        }.padding(8)
    }
    
    private func handleButtonPress(_ item: String) {
        switch item {
        case "<":
            if !money.isEmpty {
                money.removeLast()
            }
        case "0"..."9", ".":
            if(isCalculation){
                money = ""
            }
            else {
                money.append(item)
            }
        case "記帳":
            if let selectedCategoryName = selectedCategory{
                let record =  AccountingItem(name: selectedCategoryName, type: "add", amount: money, date: Date())
                accountingViewModel.addRecord(item:record)
                withAnimation {
                    selectedItem = nil
                    selectedCategory = nil
                    showPopup.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showPopup = false
                    }
                }
                money = ""
            }
            else {
                showErrorPopup = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showErrorPopup = false
                    }
                }
            }
        case "+/-":
            if !money.isEmpty {
                let lastCharacter = money.last!
                let isAddOrMinusSymbol = money.contains("+") || money.contains("−")
                let currentSymbol = isAddOrMinusSymbol ? (money.contains("+") ? "+" : "−") : nil

                // 若包含 + 或 −，則處理符號
                if isAddOrMinusSymbol {
                    // 如果最後一個字元是符號，則替換
                    if lastCharacter == "+" || lastCharacter == "−" {
                        money.removeLast()
                        money.append(isAddorMinus ? "+" : "−")
                    } else {
                        // 將字串依照符號分割
                        let parts = money.components(separatedBy: currentSymbol!)
                        // 確保有兩個部分可以運算
                        if parts.count == 2, let resultString = addAndConvertToString(parts[0], parts[1], by: currentSymbol!) {
                            money = resultString
                        } else {
                            print("無法轉換字串為數字")
                        }
                    }
                } else {
                    // 如果不包含符號，則追加符號
                    money.append(isAddorMinus ? "+" : "−")
                }
                isAddorMinus.toggle()
            }
        case "*/÷":
            if !money.isEmpty {
                let lastCharacter = money.last!
                let isAddOrMinusSymbol = money.contains("*") || money.contains("÷")
                let currentSymbol = isAddOrMinusSymbol ? (money.contains("*") ? "*" : "÷") : nil

                // 若包含 + 或 −，則處理符號
                if isAddOrMinusSymbol {
                    // 如果最後一個字元是符號，則替換
                    if lastCharacter == "*" || lastCharacter == "÷" {
                        money.removeLast()
                        money.append(isAddorMinus ? "*" : "÷")
                    } else {
                        // 將字串依照符號分割
                        let parts = money.components(separatedBy: currentSymbol!)
                        // 確保有兩個部分可以運算
                        if parts.count == 2, let resultString = addAndConvertToString(parts[0], parts[1], by: currentSymbol!) {
                            money = resultString
                        } else {
                            print("無法轉換字串為數字")
                        }
                    }
                } else {
                    // 如果不包含符號，則追加符號
                    money.append(isAddorMinus ? "*" : "÷")
                }
                isAddorMinus.toggle()
            }
        default:
            break ;
        }
    }
    private func handleButtonBackgroundColor(_ item: String) -> Color {
        switch item {
        case "記帳":
            return Color.yellow.opacity(1) // Ensure to use `return` here
        default:
            return Color.blue.opacity(0.8)
        }
    }
    private func addAndConvertToString(_ str1: String, _ str2: String, by operatorSymbol: String) -> String? {
        if let num1 = Int(str1), let num2 = Int(str2) {
            switch operatorSymbol {
            case "+":
                let result = num1 + num2
                return String(format: "%d", result)
            case "−":
                let result = num1 - num2
                return String(format: "%d", result)
            case "*":
                let result = num1 * num2
                return String(format: "%d", result)
            case "÷":
                let result = num1 / num2
                return String(format: "%d", result)
            default :
                return nil;
            }
            
        } else {
            return nil // 如果無法轉換字串為數字，回傳 nil
        }
        
    }
}

struct AccountRecordSmallLabel: View {
    let smallLabelItem: [String: [String]] = [
        "餐飲": [
            "🍳 早餐",
            "🥤 飲料",
            "🍱 午餐",
            "🫖 下午茶",
            "🍴 晚餐",
            "🍗 宵夜",
            "🥳 聚餐",
            "🍪 零食",
            "🥬 買菜原料"
        ],
        "交通": [
            "🚗 開車",
            "🚌 公車",
            "🚉 地鐵",
            "🚲 單車",
            "✈️ 飛機",
            "🚢 船隻",
            "🚕 計程車",
            "🚄 高鐵"
        ],
        "購物": [
            "📱 電子產品",
            "📚 書籍",
            "🎁 禮物",
            "🍎 食品"
        ],
        "娛樂": [
            "🎮 電玩",
            "📽️ 看電影",
            "🎤 KTV",
            "🎨 美術館",
            "🎢 遊樂園",
            "🏖️ 海灘",
            "🎸 演唱會",
            "🎮 遊戲機",
            "🎫 彩卷"
        ],
        "居家": [
            "🛋️ 家居家具",
            "🧹 家政打掃",
            "🧴 盥洗用品",
            "💅 美容用品",
            "🌷 園藝",
            "🛠️ 物業材料",
            "⚡ 水電燃料",
            "🏠 住宿房租"
        ],
        "工作": [
            "💻 電腦",
            "🖨️ 印表機",
            "📂 文件",
            "🖊️ 文具",
            "🧳 商務旅行",
            "📈 報表",
            "🤝 客戶拜訪"
        ]
    ]


    @Binding var selectedItem: String?
    @Binding var selectedCategory: String?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let selectedItem = selectedItem,let smallLabelItem = smallLabelItem[selectedItem] {
                    ForEach(smallLabelItem,id:\.self){ item in
                        Button(action:{
                            selectedCategory = (selectedCategory == item) ? nil : item
                        }){
                            Text(item)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .foregroundStyle(selectedCategory == item ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                                .background(selectedCategory == item ? Color.blue.opacity(0.8) : Color.blue.opacity(0.2))
                                .fontWeight(.bold)
                                .fontDesign(.monospaced)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}
