//
//  Picture.swift
//  Stage
//
//  Created by Neal Watkins on 2022/2/1.
//

import CoreImage
import QuartzCore
import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct Picture: Codable, Equatable {
    
    // MARK: - Coding
    
    var url: URL?
    var fit: Fit?
    
    enum CodingKeys: String, CodingKey {
        case url
        case fit
    }
    
    var isEmpty: Bool {
        url == nil && fit == nil
    }
    
    // MARK: - Core
    
    var coreImage: CIImage {
        guard let url = url else { return CIImage() }
        return CIImage(contentsOf: url) ?? CIImage()
    }
    
    var cgImage: CGImage? {
        coreImage.cgImage
    }
    
    
    // MARK: - Platform
    
    #if os(macOS)
    var nsImage: NSImage? {
        guard let url = url else { return nil }
        return NSImage(contentsOf: url)
    }
    
    var content: NSImage? {
        nsImage
    }
    
    var image: Image? {
        guard let native = nsImage else { return nil }
        return Image(nsImage: native)
        
    }
    #else
    var uiImage: UIImage? {
        guard let url = url else { return nil }
        return UIImage(url: URL)
    }
    
    var content: CGImage? {
        cgImage
    }
    
    var image: Image? {
        guard let native = uiImage else { return nil }
        return Image(uiImage: native)
    }
    #endif
    
    // MARK: - ID
    
    var label: String {
        url?.deletingPathExtension().lastPathComponent ?? ""
    }
    
    // MARK: - Fit
    
    enum Fit: String, Codable, CaseIterable {
        case fit
        case fill
        case stretch
        case centre
        case topLeft
        case top
        case topRight
        case right
        case bottomRight
        case bottom
        case bottomLeft
        case left
        
        var gravity: CALayerContentsGravity {
            switch self {
                
            case .fit: return .resizeAspect
            case .fill: return .resizeAspectFill
            case .stretch: return .resize
            case .centre: return .center
            case .top: return .top
            case .topLeft: return .topLeft
            case .topRight: return .topRight
            case .bottom: return .bottom
            case .bottomLeft: return .bottomLeft
            case .bottomRight: return .bottomRight
            case .left: return .left
            case .right: return .right
            }
        }
        
        var label: String {
            self.rawValue.localizedCapitalized
        }
        
        var icon: String {
            switch self {
                
            case .fit: return "Fit Fit"
            case .fill: return "Fit Fill"
            case .stretch: return "Fit Stretch"
            case .centre: return "Fit Centre"
            case .topLeft: return "Fit TopLeft"
            case .top: return "Fit Top"
            case .topRight: return "Fit TopRight"
            case .right: return "Fit Right"
            case .bottomRight: return "Fit BottomRight"
            case .bottom: return "Fit Bottom"
            case .bottomLeft: return "Fit BottomLeft"
            case .left: return "Fit Left"
            }
        }
    }
    
}


