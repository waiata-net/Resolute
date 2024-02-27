//
//  ScreenItems.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/27.
//

import SwiftUI

struct ScreenItems: View {
    
    @State var screen: NSScreen
    
    @State var bug: String = ""
    
    init(screen: NSScreen) {
        self.screen = screen
        self.bug = screen.resolutionLabel
    }
    
    var body: some View {
        Text(bug).hidden()
            ForEach(screen.resolutions, id: \.debugDescription) { resolution in
                
                let on = Binding<Bool>(
                    get: { screen.resolution == resolution },
                    set: { _ in 
                        screen.resolution = resolution
                        bug = screen.resolutionLabel
                    }
                )
                
                Toggle(isOn: on) { 
                    Text(String(format: "%.fx%.f", resolution.width, resolution.height))
                }
                .toggleStyle(.button)
            }
        
        
        Divider()
        
        let rateModes = screen.modes(of: screen.resolution)
        
        ForEach(rateModes, id: \.self) { mode in
            let on = Binding<Bool>(
                get: { screen.mode?.refreshRate == mode.refreshRate },
                set: { _ in
                    screen.mode = mode
                    bug = "\(screen.mode?.refreshRate ?? 0.0)"
                }
            )
            Toggle(isOn: on) {
                Text(String(format: "@%.2f", mode.refreshRate))
            }
        }
    }
}

#Preview {
    Menu("") {
        ScreenItems(
            screen: NSScreen.main!
        )
    }
    .frame(width: 120)
}
