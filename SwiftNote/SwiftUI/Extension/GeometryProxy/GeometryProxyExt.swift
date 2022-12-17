//
//  File.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import SwiftUI

extension GeometryProxy {
    var minSize: Double {
        min(size.width, size.height)
    }
    
    var maxSize: Double {
        max(size.width, size.height)
    }
}
