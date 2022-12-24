//
//  NotificationService.swift
//  Payload Modification
//
//  Created by Nguyen Tuan Anh on 24/12/2022.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    // Có 30s để thực hiện các tác vụ cần thiết, nếu quá thời gian thì sẽ gọi tiếp hàm serviceExtensionTimeWillExpire bên dưới
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
        // Modify the notification content here...
        // Có thể chỉnh sửa bất kỳ thứ gì nhưng phải đảm bảo không remove alert text, nếu không iOS sẽ bỏ qua thay đổi và sử dụng phiên bản payload gốc.
        bestAttemptContent.title = ROT13.shared.decrypt(bestAttemptContent.title)
        bestAttemptContent.body = ROT13.shared.decrypt(bestAttemptContent.body)
        guard let urlPath = request.content.userInfo["media_url"] as? String,
              let url = URL(string: ROT13.shared.decrypt(urlPath)) else {
            contentHandler(bestAttemptContent)
            return
        }
        // Sử dụng dataTask thay vì downloadTask bởi vì downloadTask lưu filename extension không chính xác
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { contentHandler(bestAttemptContent) }
            guard let data = data, error == nil else { return }
            let file = response?.suggestedFilename ?? url.lastPathComponent
            let destination = URL(filePath: NSTemporaryDirectory()).appending(path: file)
            do {
                try data.write(to: destination)
                let attachment = try UNNotificationAttachment(identifier: file, url: destination)
                bestAttemptContent.attachments = [attachment]
            } catch {
                // Nothing to do
            }
        }.resume()
    }
    
    // Hàm này để làm các công việc cần thiết khác trước khi hiển thị
    // Ví dụ: Khi thực hiện tải 1 ảnh để hiển thị đính kèm trong notification mà không đủ thời gian,
    // bạn sẽ muốn thay thế tiêu đề cũ từ "Ảnh một chú mèo cute siêu cấp đây nè" sang "Có một chú mèo cute siêu cấp ở https://www.tuanem.com/"
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
