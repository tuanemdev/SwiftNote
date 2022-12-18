//
//  Logger.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

// https://developer.apple.com/documentation/os/logger
import Foundation
import OSLog

/*
 Đôi khi việc debug để tìm ra lỗi là không hề dễ dàng,
 Có những lỗi không thể tái hiện lại, rất hiếm gặp hoặc phải thoả mãn một số điều kiện nhất định nào đó.
 Những lỗi như vậy cần nhiều thời gian để tìm ra nên không thể lúc nào cũng cắm máy kết nối với Xcode để debug được.
 Lúc này thì cần dùng đến Logger để lấy các thông tin mà ta nghi ngờ để tìm hiểu và theo dõi.
 */

@MainActor
final class LogStore: ObservableObject {
    // mảng dùng để chứa thông tin log đã lưu
    @Published private(set) var entries: [String] = []
    // subsystem và category sẽ dùng để làm bộ lọc thông tin trong Console
    // có thể thu thập thông tin log bằng 3 cách: app Console, Xcode debug console, log command line tool
    private let logger: Logger = .init(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LogStore.self))
    
    private func doSomeThing() {
        var someThingInfo: Float = 100.00
        // DEBUG LEVEL
        // debug và trace cùng level với nhau, chỉ được lưu trong memory
        logger.debug("Debug Level: \(someThingInfo, privacy: .public)")     // Debug Level: Secret Info
        logger.trace("Debug Level: \(someThingInfo)")     // Debug Level: <private>
        // notice và log cùng level với nhau, tương đương level debug, được lưu trong cả memory và disk
        logger.notice("Debug Level")
        logger.log("Debug Level")
        
        // INFO LEVEL
        // chỉ được lưu trong memory, nếu sử dụng log command line tool để thu thập thông tin
        // thì sẽ được lưu vào cả trong disk
        logger.info("Info Level")
        
        // ERROR LEVEL
        // error và warning cùng level với nhau, được lưu trong cả memory và disk
        // biểu thị ở cột Type với dấu chấm vàng
        logger.error("Error Level")
        logger.warning("Error Level")
        
        // FAULT LEVEL
        // fault và critical cùng level với nhau, được lưu trong cả memory và disk
        // biểu thị ở cột Type với dấu chấm đỏ
        logger.fault("Fault Level")
        logger.critical("Fault Level")
        
        // Hàm dùng chung, có thể chỉ định level log qua OSLogType: có 5 kiểu: `default`, info, debug, error, fault
        // với level: INFO và DEBUG thì ở cột Type không có biểu thị màu
        logger.log(level: .debug, "Log")
        
        /*
         TÍNH BẢO MẬT
         Do thông tin log có thể nhạy cảm và để đảm bảo an toàn thì chỉ có StaticString là được hiển thị
         các thông tin khác sẽ hiển thị <private> theo mặc định
         (StaticString: chuỗi cố định không thay đổi, không có tham số trong chuỗi)
         Để hiển thị các thông tin như nội dung của someThingInfo phía trên ta cần cung cấp privacy level cho nó
         Ngoài ra thì có thể có một số lựa chọn định dạng khác cho nó trong message - chi tiết: OSLogInterpolation
         */
        logger.trace("Debug Level: \(someThingInfo, format: .fixed, align: .right(columns: 10), privacy: .private(mask: .hash))")
    }
    
    // Lấy thông tin đã được lưu trong LogStore
    func export() {
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            // Lấy thông tin trong vòng 24h qua
            let date = Date.now.addingTimeInterval(-24 * 3600)
            let position = store.position(date: date)
            
            entries = try store
                .getEntries(at: position)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
                .map { "[\($0.date.formatted())] [\($0.category)] \($0.composedMessage)" }
        } catch {
            logger.warning("\(error.localizedDescription, privacy: .public)")
        }
    }
}
