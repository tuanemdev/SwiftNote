//
//  AppDelegate.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 20/12/2022.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    let notificationDelegate: NotificationDelegate = .init()
    
    // var orientation: UIInterfaceOrientationMask = .allButUpsideDown
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Cách 1:
        guard let topViewController = application.topViewController() else { return .allButUpsideDown }
        switch topViewController {
        case is ExampleViewController:
            return .landscape
        default:
            return .allButUpsideDown
        }
        // Cách 2: Sử dụng: AppDelegate.shared.orientation = .landscape (nhớ set lại giá trị mặc định khi dismiss View)
        // Bổ sung (nếu cần): UIDevice.current.setValue(orientation.rawValue, forKey: "orientation") (chưa rõ lý do hoạt động không ổn định)
        /*
         return .orientation
         */
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications(application)
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration: UISceneConfiguration = .init(name: connectingSceneSession.configuration.name, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}
