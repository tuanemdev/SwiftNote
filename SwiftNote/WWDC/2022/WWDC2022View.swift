//
//  WWDC2022View.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 28/05/2023.
//

import SwiftUI

struct WWDC2022View: View {
    
    @State private var listData: [String] = ["hello", "world", "ahihi", "do ngoc", "swiftui", "uikit", "combine", "core data"]
    @State private var textFieldData: String = ""
    @State private var pickDates: Set<DateComponents> = .init()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Hello WWDC 2022")
                .font(.title3)
            
            List(listData, id: \.self) { item in
                Text(item)
                    .listRowBackground(Color.blue)
            }
            .scrollIndicators(.hidden) /// iOS 16.0 (UITableView.appearance().showsVerticalScrollIndicator = false)
            .scrollContentBackground(.hidden) /// iOS 16.0  (UITableView.appearance().backgroundColor = .clear)
            .frame(height: 250)
            
            TextField("placeholder", text: $textFieldData, axis: .vertical)
                .lineLimit(2...3) /// iOS 16.0 (no fallback)
                .padding(20)
            
            MultiDatePicker("New Date Picker", selection: $pickDates) /// iOS 16 (new feature)
        }
        .background {
            Color.gray.opacity(0.6)
                .ignoresSafeArea()
        }
    }
}

struct WWDC2022View_Previews: PreviewProvider {
    static var previews: some View {
        WWDC2022View()
    }
}
