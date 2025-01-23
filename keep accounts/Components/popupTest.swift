//
//  popupTest.swift
//  keep accounts
//
//  Created by Rax Cruz on 2025/1/22.
//


import PopupView
import SwiftUI

struct FloatTopFirst: View {

    @Environment(\.popupDismiss) var dismiss

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.purple)
            
            HStack(spacing: 0) {
                Image("avatar1")
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(16)
                    .padding(16.0)
                
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text("Adam Jameson")
                            .bold()
                            .foregroundColor(.black) +
                        Text(" invites you to join his training")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Button {
                        debugPrint("Accepted!")
                        dismiss?()
                    } label: {
                        Text("Accept".uppercased())
                            .font(.system(size: 14, weight: .black))
                    }
                   // .customButtonStyle(foreground: Color(hex: "9265F8"), background: .clear)
                }
                
                Spacer()
            }
        }
        .frame(height: 98)
        .padding(.horizontal, 16)
    }
}

struct FloatTopSecond: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("恭喜又新增一筆記帳 !")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                
                VStack(alignment: .leading) {
                    Text("支出 : 飲料45元").fontWeight(.semibold).font(.system(size: 16)).foregroundColor(.red.opacity(0.8)).padding(.horizontal, 8).padding(.vertical,4).background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    )
                    Text("2025-01-21 09:46:59 星期五").font(.system(size: 14)).foregroundColor(.white.opacity(0.4))
                }
            }
            
            Spacer()
            Text("🥤").font(.system(size: 48)).foregroundColor(.white)
//            Image("CatAccounting")
//                .resizable()
//                .frame(width: 64, height: 64)
                
        }
        .padding(16)
        .background(Color.purple.cornerRadius(12))
        //.shadow(color: Color.purple.opacity(0.5), radius: 40, x: 0, y: 12)
        .padding(.horizontal, 16)
    }
}

struct FloatTopError: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("尚未選擇記帳類型")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            
            Spacer()
           // Text("").font(.system(size: 48)).foregroundColor(.white)
            Image(systemName: "exclamationmark.warninglight.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.white)
                
        }
        .padding(16)
        .background(Color.pink.opacity(0.5).cornerRadius(12))
        //.shadow(color: Color.purple.opacity(0.5), radius: 40, x: 0, y: 12)
        .padding(.horizontal, 16)
    }
}

struct FloatBottomFirst: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Your message has been sent to Alex Brant")
                .font(.system(size: 15))
                .foregroundColor(.black)
            Spacer()
            Image("avatar2")
                .frame(width: 32, height: 32)
                .cornerRadius(16)
        }
        .padding(16)
        .background(Color.white.cornerRadius(12))
        //.shadowedStyle()
        .padding(.horizontal, 16)
    }
}

struct FloatBottomSecond: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
            
            Text("Check your network connection and try again")
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
        .padding(16)
        .background(Color.purple.cornerRadius(12))
        .padding(.horizontal, 16)
    }
}

struct Floats_Previews : View {
    @State var showPopup = false

    var body: some View {
        Button(action:{
            showPopup.toggle()
        }) {
            Text("click")
        }
        .popup(isPresented: $showPopup) {
            FloatTopSecond()
        } customize: {
            $0
                .type(.floater())
                .position(.top)
        }
        FloatTopSecond()
    }
}

#Preview {
    Floats_Previews()
}
