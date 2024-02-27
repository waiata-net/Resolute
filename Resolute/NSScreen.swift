import AppKit

extension NSScreen: Identifiable {
    
    // MARK: - Static
    
    /// rect for total area of all screens
    static var extentsOfAllScreens: CGRect {
        guard let first = screens.first else { return .zero }
        let rest = screens.dropFirst()
        return rest.reduce(first.frame){ $0.union($1.frame) }
    }
    
    static func space(of frame: CGRect?) -> CGRect {
        guard let frame else { return .zero }
        let extents = extentsOfAllScreens
        return CGRect(
            x: (frame.origin.x - extents.origin.x) / extents.width,
            y: (extents.maxY - frame.maxY) / extents.height,
            width: frame.width / extents.width,
            height: frame.height / extents.height
        )
    }
    
    static let layoutChanged = NSApplication.didChangeScreenParametersNotification
    
    static func screen(id: CGDirectDisplayID?) -> NSScreen? {
        return screens.first(where: { $0.id == id })
    }
    
    static let masterPortDefaultKey = kIOMainPortDefault
    
    
    // MARK: - Info
    
    private func info(for displayID: CGDirectDisplayID, options: Int) -> [AnyHashable: Any]? {
        var iterator: io_iterator_t = 0
        
        let result = IOServiceGetMatchingServices(NSScreen.masterPortDefaultKey, IOServiceMatching("IODisplayConnect"), &iterator)
        guard result == kIOReturnSuccess else {
            print("Could not find services for IODisplayConnect: \(result)")
            return nil
        }
        
        var service = IOIteratorNext(iterator)
        while service != 0 {
            let info = IODisplayCreateInfoDictionary(service, IOOptionBits(options)).takeRetainedValue() as! [AnyHashable: Any]
            
            guard
                let vendorID = info[kDisplayVendorID] as! UInt32?,
                let productID = info[kDisplayProductID] as! UInt32?
            else {
                continue
            }
            
            if vendorID == CGDisplayVendorNumber(displayID) && productID == CGDisplayModelNumber(displayID) {
                return info
            }
            
            service = IOIteratorNext(iterator)
        }
        
        return nil
    }
    
    // MARK: - ID
    
    var index: Int? {
        return NSScreen.screens.firstIndex(of: self)
    }
    
    public var id: CGDirectDisplayID {
        deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
    }
    
    var name: String {
        if #available(macOS 10.15, *) {
            return localizedName
        }
        
        guard let info = info(for: id, options: kIODisplayOnlyPreferredName) else { return "" }
        
        guard
            let localizedNames = info[kDisplayProductName] as? [String: Any],
            let name = localizedNames.values.first as? String
        else { return "" }
        
        return name
    }
    
    var indexLabel: String {
        guard let i = index else { return "" }
        return "\(i)"
    }
    
    // MARK: - Mode
    
    typealias Mode = CGDisplayMode
    
    var mode: Mode? {
        get {
            CGDisplayCopyDisplayMode(id)
        } set {
            var config: CGDisplayConfigRef?
            CGBeginDisplayConfiguration(&config)
            CGConfigureDisplayWithDisplayMode(config, self.id, newValue, nil)
            CGCompleteDisplayConfiguration(config, .permanently)
        }
    }
    
    var modes: [Mode] {
        let options: CFDictionary = [kCGDisplayShowDuplicateLowResolutionModes: true] as CFDictionary
        return (CGDisplayCopyAllDisplayModes(id, options) as? [Mode]) ?? []
    }
    
    func modes(of resolution: CGSize?) -> [Mode] {
        modes.filter { $0.resolution == resolution }
    }
    
    /// available displaymode of resolution with closest refresh rate to current
    func mode(resolution: CGSize? = nil, rate: Double? = nil) -> Mode? {
        guard let size = resolution ?? self.resolution else { return nil }
        guard let rate = rate ?? self.mode?.refreshRate else { return nil }
        let near = modes(of: size).min {
            abs($0.refreshRate - rate) < abs($1.refreshRate - rate)
        }
        return near
    }
    
    
    var resolutions: [CGSize] {
        var resolutions = [CGSize]()
        for mode in modes {
            if !resolutions.contains(mode.resolution) {
                resolutions.append(mode.resolution)
            }
        }
        return resolutions
    }

    
    func rates(at resolution: CGSize) -> [Double] {
        modes(of: resolution).map { $0.refreshRate }
    }
    
    var resolution: CGSize? {
        get {
            mode?.resolution
        } set {
            guard let mode = mode(resolution: newValue)
            else { return }
            configure(mode: mode)
        }
    }
    
    
    var resolutionLabel: String {
        return "\(Int(bounds.width)) x \(Int(bounds.height))"
    }
    
    // MARK: - Configure
    
    func configure(mode: Mode) {
        var config: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&config)
        CGConfigureDisplayWithDisplayMode(config, self.id, mode, nil)
        CGCompleteDisplayConfiguration(config, .permanently)
    }
    
    
    // MARK: - Parameters
    
    var isMain: Bool {
        return CGMainDisplayID() == id
    }
    
    var physicalSize: CGSize {
        return CGDisplayScreenSize(id)
    }
    
    var bounds: CGRect {
        return CGDisplayBounds(id)
    }
    
    var rotation: Double {
        return CGDisplayRotation(id)
    }
    
    var snapshot: CGImage? {
        return CGDisplayCreateImage(id)
    }
    
    
    // MARK: - Wallpaper
    
    var wallpaper: NSImage? {
        guard let url = NSWorkspace.shared.desktopImageURL(for: self),
              let image = NSImage(contentsOf: url),
              image.size != .zero
        else { return nil }
        return image
    }
    
    
    var backgroundColor: CGColor? {
        guard
            let desk = NSWorkspace.shared.desktopImageOptions(for: self),
            let fill = desk[NSWorkspace.DesktopImageOptionKey.fillColor] as? NSColor
        else { return nil }
        return fill.cgColor
    }
    
    
    
    
    
    
}

