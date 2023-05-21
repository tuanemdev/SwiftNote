//
//  SwiftCharts.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 31/12/2022.
//

import SwiftUI
import Charts

struct SwiftCharts: View {
    var body: some View {
        Chart(itemsData) { item in
            BarMark(
                x: .value("Name", item.name),
                y: .value("Cost", item.cost)
            )
        }
    }
}

struct SwiftCharts_Previews: PreviewProvider {
    static var previews: some View {
        SwiftCharts()
    }
}

struct ProductItem: Identifiable {
    let name: String
    let cost: Int
    var id: String { name }
}

let itemsData: [ProductItem] = [
    ProductItem(name: "Ahihi", cost: 25),
    ProductItem(name: "Do Ngoc", cost: 30),
    ProductItem(name: "Code iOS", cost: 45),
    ProductItem(name: "No Name", cost: 20)
]
