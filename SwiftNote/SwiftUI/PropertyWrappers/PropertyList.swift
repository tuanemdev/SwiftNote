//
//  PropertyList.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 12/02/2023.
//

// MARK: - Danh sách tất cả các Property Wrappers có sẵn của SwiftUI
/*
 @UIApplicationDelegateAdaptor: đăng ký App Delegate cho iOS App
 @NSApplicationDelegateAdaptor: đăng ký App Delegate cho macOS App
    code: @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 
 @State
 Dùng để cho phép thay đổi giá trị của biến trong Struct, điều mà thông thường không được phép
 Có nghĩa bộ nhớ của biến đó được di chuyển ra khỏi Struct và được lưu trữ quản lý bởi SwiftUI
 Tất cả các biến @State đều nên được đánh dấu là private, và sử dụng với các value-type đơn giản
    code: @State private var username: String = ""
 
 @StateObject
 Tương tự như @State để tránh biến bị destroyed khi update View, nhưng sử dụng cho reference-type conforms protocol ObservableObject
 Chỉ sử dụng @StateObject một lần duy nhất cho mỗi một Object nơi chúng được khởi tạo. Ở các vị trí được chia sẻ khác sử dụng @ObservedObject
    code: @StateObject var user = User()
 
 @ObservedObject
 Như giải thích phía trên với @StateObject, nó được dùng với reference-type conforms ObservableObject
 Tuy nhiên điểm khác biệt với @StateObject là @ObservedObject không được dùng để khởi tạo và chỉ được dùng để refer đến một instance được khởi tạo với @StateObject ở một nơi khác
 Nếu không SwiftUI có thể destroyed instance một cách không kiểm soát được
    code: @ObservedObject var order: Order
 
 @EnvironmentObject
 Có rất nhiều điểm tương đồng giữa @EnvironmentObject và @ObservedObject. Chúng đều không khởi tạo instance mà chỉ là tham chiếu đến một nơi khác đã khởi tạo nó và
 có thể được chia sẻ giữa hai hoặc nhiều View
 Điểm khác nhau là @EnvironmentObject lấy dữ liệu từ môi trường còn @ObservedObject được truyền từ View này qua View khác
 Tưởng tượng: View A -> View B -> View C -> View D -> View E. View A và View E sử dụng chung 1 object là ObZ
 Nếu sử dụng @ObservedObject thì ta cần truyền ObZ qua View B -> View C -> View D. Những View thực sự không cần sử dụng đến nó, khi này ta nên sử dụng @EnvironmentObject
 Nếu View E sử dụng @EnvironmentObject nhưng không tìm thấy ObZ trong môi trường (Do bạn quên truyền ObZ vào môi trường từ View A) thì App sẽ crash do nil
    code: @EnvironmentObject var order: Order
 
 @Published
 Được sử dụng với các properties của một ObservableObject, và nói với SwiftUI cần refresh lại các View sử dụng nó khi giá trị được cập nhật
    code: @Published var items = [String]()
 
 @Binding
 Một biến được khai báo ở một đâu đó khác và được chia sẻ với View hiện tại. Thay đổi ở View hiện tại (local) cũng
 đồng thời thay đổi data tại View nó được khởi tạo (remote)
    code: @Binding var isPresented: Bool
 
 @Environment
 Lấy dữ liệu cần thiết từ hệ thống: ví dụ darkMode, hỗ trợ tiếp cận, ...
 Danh sách các @Environment mặc định được nêu cụ thể sau. Tuy nhiên ta vẫn có thể custom thêm các key vào @Environment nếu muốn
 Tuy cùng lấy data từ môi trường, nhưng điểm khác nhau giữa @Environment và @EnvironmentObject là @Environment chủ yếu là các key được định nghĩa từ trước và có thể có
 nhiều biến với cùng một kiểu dữ liệu còn @EnvironmentObject thì chỉ là một từ kiểu dữ liệu mà nó mong muốn lấy từ môi trường
    code: @Environment(\.managedObjectContext) var managedObjectContext
 
 @AppStorage
 Đọc ghi dữ liệu từ UserDefaults
    code: @AppStorage("username") var username: String = "Anonymous" (username = "@twostraws" tương đương UserDefaults.standard.set("@twostraws", forKey: "username"))
          @AppStorage("username", store: UserDefaults(suiteName: "group.com.hackingwithswift.unwrap")) var username: String = "Anonymous"
 
 @SceneStorage
 Cách sử dụng khá tương tự với @AppStorage tuy nhiên mỗi một màn hình sẽ có một data riêng của nó. Thay vì sử dụng UserDefaults thì mục đích chính của @SceneStorage
 là để phục hồi trạng thái. Khi App bị chấm dứt thì @SceneStorage cũng bị huỷ.
 Để tối ưu hoá thì @AppStorage và @SceneStorage chỉ thực sự được lưu khi App chuyển qua trạng thái background
    code: @SceneStorage("text") var text = ""
 
 @FetchRequest
 Sử dụng để lấy data từ CoreData đã được đưa vào môi trường
    code: @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)], predicate: NSPredicate(format: "surname == %@", "Hudson")) var users: FetchedResults<User>
 
 @FocusedBinding
 
 @FocusedValue
 
 @GestureState
 Dùng để theo dõi giá trị trạng thái của gesture. Khi gesture kết thúc thì giá trị của nó sẽ được trả về giá trị mặc định ban đầu
    code: @GestureState var dragAmount = CGSize.zero
 
 @ScaledMetric
 Dựa theo cài đặt Dynamic Type để thu phóng nội dung theo một con số chúng ta chỉ định trước
    code: @ScaledMetric var imageSize = 100.0
          @ScaledMetric(relativeTo: .largeTitle) var imageSize = 100.0
 
 @Namespace
 Dùng để tạo animation hiệu ứng chuyển cảnh (matched geometry effects) giữa các View khác nhau
    code: @Namespace var animation
          var animation: Namespace.ID
 */

// MARK: - Danh sách Environment Key
