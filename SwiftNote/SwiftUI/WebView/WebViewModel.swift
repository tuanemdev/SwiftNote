//
//  WebViewModel.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 02/01/2023.
//

import Foundation
import Combine

final class WebViewModel: ObservableObject {
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
    var webTitle = PassthroughSubject<String, Never>()
    var showLoader = PassthroughSubject<Bool, Never>()
    var valuePublisher = PassthroughSubject<String, Never>()
}

enum URLType {
    case local(String)
    case remote(String)
    case code(String)
}

enum WebViewNavigation {
    case backward, forward, reload
}
