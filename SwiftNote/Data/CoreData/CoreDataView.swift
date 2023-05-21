//
//  CoreDataView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 23/05/2023.
//

import SwiftUI

struct CoreDataView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [.init(keyPath: \Item.price, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text("Item \(item.name!) cost \(item.price)$")
            }
        }
    }
}

struct CoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
