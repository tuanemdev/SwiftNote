//
//  AppURL.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/05/2023.
//

import SwiftUI

struct AppURL {
    // Gọi điện
    let call            = URL(string: "tel:0987654321")!
    // Gửi email
    let sendMail        = URL(string: "mailto:admin@tuanem.com")!
    // Cài đặt
    let settings        = UIApplication.openSettingsURLString
    // Thông báo
    let noti            = UIApplication.openNotificationSettingsURLString
}
