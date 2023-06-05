//
//  Syntax.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 31/12/2022.
//

import Foundation

#if targetEnvironment(simulator)
    // your simulator code
#else
    // your real device code
#endif

#warning("Fix this later")
/*
 #error("This must be done")
 Comment lại dòng này để có thể biên dịch
 */

/// Làm việc với UIKit và custom view
#if !TARGET_INTERFACE_BUILDER
   // Run this code only in the app
#else
   // Run this code only in Interface Builder
#endif
