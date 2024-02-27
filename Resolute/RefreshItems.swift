//
//  RefreshItems.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/28.
//

import SwiftUI

struct RefreshItems: View {
    
    var screen: NSScreen
    
    @State var bug: String = ""
    
    
    var body: some View {
        let rateModes = screen.modes(of: screen.resolution)
        Text(bug).hidden()
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
        .toggleStyle(.button)
    }
}

#Preview {
    RefreshItems(screen: NSScreen.main!)
    .frame(width: 120)
}
