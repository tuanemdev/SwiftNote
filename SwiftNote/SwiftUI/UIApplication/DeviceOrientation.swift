//
//  DeviceOrientation.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 30/04/2023.
//

import UIKit
import Combine

final class DeviceOrientation: ObservableObject {
    
    enum Orientation {
        case portrait
        case landscape
    }
    
    @Published var orientation: Orientation
    private var listener: AnyCancellable?
    
    init() {
        orientation = UIDevice.current.orientation.isLandscape ? .landscape : .portrait
        listener = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { ($0.object as? UIDevice)?.orientation }
            .compactMap { deviceOrientation -> Orientation? in
                if deviceOrientation.isPortrait {
                    return .portrait
                } else if deviceOrientation.isLandscape {
                    return .landscape
                } else {
                    return nil
                }
            }
            .assign(to: \.orientation, on: self)
    }
    
    deinit {
        listener?.cancel()
    }
}
