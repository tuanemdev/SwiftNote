//
//  ConfigurationProvider.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 10/06/2023.
//

import Foundation

protocol SwiftNoteConfig {
    var environment: AppEnvironment { get }
    var domain: String { get }
    var exampleValue: String { get }
    var secretKey: String { get }
    var swiftFlags: String { get }
}

enum ConfigurationProvider: SwiftNoteConfig {
    case `default`
    
    /// Tạo một enum để không hard-code
    /// Các key-value được khai báo trong file config cũng sẽ tự xuất hiện tại: Project --> Targets --> Build Settings --> User-Defined (cuối cùng)
    /// Có thể thêm key-value trực tiếp bằng cách ấn button + (Add User-Defined Setting) ở hàng trên cùng.
    /// Không cần thiết thêm vào Info.plist nếu không cần lấy giá trị khi code. Sử dụng trực tiếp trong Build Settings bằng cú pháp $(KEY)
    enum Keys {
        static let config = "CONFIGURATION"
        static let domain = "DOMAIN"
        static let exampleKey = "BUILD_SETTING_DECLARATION_NAME"
    }
    
    /// String của config đang sử dụng: Project --> Info --> Configurations
    var config: String {
        try! Configuration.value(for: Keys.config)
    }
    
    var environment: AppEnvironment {
        AppEnvironment(rawValue: config.lowercased()) ?? .development
    }
    
    /// 2 ví dụ bên dưới là 2 key-value custom được điền trong các file xcconfig
    var domain: String {
        try! Configuration.value(for: Keys.domain)
    }
    
    var exampleValue: String {
        try! Configuration.value(for: Keys.exampleKey)
    }
    
    /// Các thông tin trong file Info.plist có thể bị đánh cắp, do đó vì lý do bảo mật, các giá trị mang tính bảo mật không được lưu trong các file xcconfig
    /// (hoặc lưu nhưng phải dưới dạng đã được mã hóa --> lằng nhằng nên tốt nhất là nếu App không có sẵn công cụ mã hóa thì lưu dưới dạng code)
    var secretKey: String {
        switch environment {
        case .development:
            return "TOKEN_DEV"
        case .staging:
            return "TOKEN_ST"
        case .production:
            return "TOKEN_PR"
        }
    }
    
    /// Custom flags theo các bước: Project --> Build Settings --> Swift Complier - Custom Flags
    /// Đặt tên theo cú pháp -D NAME
    /// Cách đặt tên ở đây chỉ là ví dụ, thường sẽ không đặt trùng với tên các config
    var swiftFlags: String {
        #if PRODUCTION
        "PRODUCTION FLAGS"
        #elseif DEVELOPMENT
        "DEVELOPMENT FLAGS"
        #else
        "STAGING FLAGS"
        #endif
    }
    
    /// Để cho thuận tiện thì người ta thường tạo ra nhiều Scheme để thiết lập sẵn với các file config vừa tạo.
    /// Nếu không muốn tạo nhiều Scheme thì khi muốn thay đổi môi trường cần vào Edit Scheme để thay đổi trước khi build.
    
    /// Việc sử dụng Firebase là rất thường xuyên, để chọn GoogleService-Info.plist cho đúng với config build.
    /// Điền path của GoogleService trong file config, lưu trong Info.plist và setup lệnh Build Phase Script như sau:
    /**
     GOOGLE_SERVICE_INFO_PLIST_SOURCE=${PROJECT_DIR}/${TARGET_NAME}/${GOOGLE_SERVICE_INFO_PLIST}

     if [ ! -f $GOOGLE_SERVICE_INFO_PLIST_SOURCE ]
     then
         echo "${GOOGLE_SERVICE_INFO_PLIST_SOURCE} not found."
         exit 1
     fi

     GOOGLE_SERVICE_INFO_PLIST_DESTINATION="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

     cp "${GOOGLE_SERVICE_INFO_PLIST_SOURCE}" "${GOOGLE_SERVICE_INFO_PLIST_DESTINATION}"
     */
    
    /*
     Hoặc sử dụng cách chính thống được giới thiệu trong tài liệu của Firebase, nhưng cách này sẽ ảnh hưởng đến Analytics
     do Analytics chỉ hoạt động tốt với file được đặt tên là GoogleService-Info.plist --> Ưu tiên sử dụng cách bên trên
     https://firebase.google.com/docs/projects/multiprojects
     let filePath = Bundle.main.path(forResource: "MyGoogleService", ofType: "plist")
     guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
     else { assert(false, "Couldn't load config file") }
     FirebaseApp.configure(options: fileopts)
     */
}
