//
//  OverlayView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/03/2023.
//

import SwiftUI
import StoreKit

struct OverlayView: View {
    
    @State private var showOverlay = false
    
    var body: some View {
        Button("Winner Picker on AppStore") {
            showOverlay.toggle()
        }
        .appStoreOverlay(isPresented: $showOverlay) {
            // https://apps.apple.com/vn/app/winner-picker-lucky-cat/id1668554885
            let config = SKOverlay.AppConfiguration(appIdentifier: "1668554885", position: .bottom)
            config.userDismissible = false
            return config
        }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
    }
}

// MARK: - UIKit
class OverlayVC: UIViewController, SKOverlayDelegate {
    func displayOverlay() {
        guard let scene = view.window?.windowScene else { return }
        
        let config = SKOverlay.AppConfiguration(appIdentifier: "1668554885", position: .bottom)
        config.userDismissible = false
        let overlay = SKOverlay(configuration: config)
        overlay.delegate = self
        overlay.present(in: scene)
    }
}
