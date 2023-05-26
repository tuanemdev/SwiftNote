//
//  DeepLink.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 19/03/2023.
//

// Deep Link gồm 2 loại là URI Scheme và Universal Link

// MARK: - URL Scheme
/*
 Là loại cũ và hiện không được khuyến khích sử dụng do việc đăng ký dễ dàng và có thể trùng lặp scheme giữa các App
 Đồng thời vấn đề về bảo mật kém do bất kỳ ai biết scheme của App đều có thể mở App của bạn khi người dùng click đường link đó
 
 Cách đăng ký:
 Project -> TARGETS -> Info -> URL Types
 
 Chỉ cần quan tâm đến 2 mục chính là
 + identifier:  Dùng để iOS nhận biết và phân biệt các App khi có nhiều App cùng đăng ký một URL Scheme giống nhau.
                Thực hành tốt nhất là sử dụng bundle ID làm id luôn vì bundle ID luôn là duy nhất, không thể trùng lặp
 + URL Schemes: định nghĩa scheme để mở App, ví dụ trong App mẫu này là swiftnote
 + Các trường cần điền khác không cần quan tâm vì nó liên quan đến thiết lập cho ứng dụng trên macOS và cũng không có nhiều ý nghĩa thực tiễn (icon, Role, properties)
 
 Phần thiết lập chỉ đơn giản như vậy, bây giờ khi người dùng ấn vào link có định dạng swiftnote:// thì hệ thống sẽ xuất hiện 1 popup thông báo có muốn mở ứng dụng SwiftNote hay không
 
 Hạn chế:
 + Các developer không thể biết scheme mình dùng có đang là duy nhất hay không và cũng không thể ngăn cản các developer khác sử dụng scheme mà mình đã dùng
 + Vấn đề về bảo mật do bất cứ khi nào người dùng bấm vào scheme thì đều hiện thông báo mở App cho dù link đó đến từ nguồn lừa đảo
 + Luôn xuất hiện popup thông báo khi người dùng bấm vào link và không điều hướng trực tiếp luôn đến App
 + Chỉ mở được App khi App đã được cài đặt còn lại không có tác dụng nào khác
 
 Xử lý
 + Với SwiftUI xử lý trong hàm .onOpenURL { incomingURL in }
 + Trong AppDelegate:
        func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool { }
 + Trong SceneDelegate:
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let url = connectionOptions.urlContexts.first?.url else { return }
        }
 
 ==> Nhiều hạn chế, dẫn đến việc ra đời của Universal Link
 */

// MARK: - Universal Link
// https://developer.apple.com/videos/play/wwdc2020/10098/
/*
 Khác với URL Scheme sử dụng các scheme tuỳ chỉnh và dễ dàng đăng ký
 Thì Universal Link có các ưu điểm:
 + sử dụng địa chỉ domain máy chủ web, là tên miền duy nhất được sở hữu bởi tổ chức - các nhân và không thể bị trùng lặp (ví dụ tuanem.com)
 + Trong khi URL Scheme chỉ hoạt động khi App đã được cài đặt thì Universal Link sẽ mở App nếu App được cài đặt còn không sẽ tiếp tục được sử dụng với phiên bản Web
 + Không hỏi popup khi ấn vào link mà sẽ mở App ngay lập tức
 
 Hạn chế của Universal Link
 Chỉ hoạt động trên các App tạo bởi Apple ví dụ như Safari, Mail, ... khi đó hệ thống mới tải tệp json và điều hướng tới App
 Các App bên thứ 3 như Chrome sẽ không hoạt động, chúng chỉ mở như một URL thông thường
 
 Cách đăng ký:
 Phía App
 Project -> TARGETS -> Signing & Capabilities -> + -> Associated Domains
 Phía Web
 Tải file json như mô tả phía dưới lên máy chủ web
 
 Xử lý
 Trong AppDelegate:
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            print(userActivity.webpageURL!)
        }
    }
 */

/*
 file json phía web: https://tuanem.com/apple-app-site-association có định dạng mẫu như sau:
 {
    "applinks": {
       "details": [
            {
              "appIDs": [ "ABCDE12345.com.example.app", "ABCDE12345.com.example.app2" ],
              "components": [
                {
                   "#": "no_universal_links",
                   "exclude": true,
                   "comment": "Matches any URL with a fragment that equals no_universal_links and instructs the system not to open it as a universal link."
                },
                {
                   "/": "/buy/*",
                   "comment": "Matches any URL with a path that starts with /buy/."
                },
                {
                   "/": "/help/website/*",
                   "exclude": true,
                   "comment": "Matches any URL with a path that starts with /help/website/ and instructs the system not to open it as a universal link."
                },
                {
                   "/": "/help/*",
                   "?": { "articleNumber": "????" },
                   "comment": "Matches any URL with a path that starts with /help/ and that has a query item with name 'articleNumber' and a value of exactly four characters."
                }
              ]
            }
        ]
    },
     "appclips": {
         "apps": [
             "ABCDE12345.com.example.app.Clip"
         ]
     }
 }
*/*/*/*/
