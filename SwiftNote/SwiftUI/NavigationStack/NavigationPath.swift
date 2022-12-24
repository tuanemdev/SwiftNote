//
//  NavigationPath.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 24/12/2022.
//

import SwiftUI

@MainActor
final class NavigationStore: ObservableObject {
    @Published var path: NavigationPath = .init()
}
