//
//  ResolutionItems.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/28.
//

import SwiftUI

struct ResolutionItems: View {
    
    var screen: NSScreen
    
    @State var bug: String = ""
    
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
        
    }
}

#Preview {
    ResolutionItems(screen: NSScreen.main!)
    .frame(width: 120)
}
