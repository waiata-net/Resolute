//
//  ScreenMode.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/27.
//

import AppKit

extension CGDisplayMode {
    
    
    var resolution: CGSize {
        CGSize(width: self.width, height: self.height)
    }
    
    var area: CGFloat {
        resolution.width * resolution.height
    }
}
