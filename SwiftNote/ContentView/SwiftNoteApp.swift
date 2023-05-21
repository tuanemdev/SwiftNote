//
//  SwiftNoteApp.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

import SwiftUI

@main
struct SwiftNoteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.notificationDelegate)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print("App State: background")
            case .inactive:
                print("App State: foreground inactive")
            case .active:
                print("App State: foreground active")
            @unknown default:
                print("App State: unknow")
            }
        }
    }
}
