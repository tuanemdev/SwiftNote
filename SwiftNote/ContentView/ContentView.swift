//
//  ContentView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(DataConstants.loadingData.localized)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
