//
//  ScreenItems.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/27.
//

import SwiftUI

struct ScreenItems: View {
    
    @State var screen: NSScreen
    
    @State var bug: Int32?
    @State var refresh = false
    
    var body: some View {
        Group {
            Toggle(isOn: $refresh) {
                Text(refresh.description)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)) { _ in
                refresh.toggle()
            }
            ResolutionItems(screen: screen)
            Divider()
            RefreshItems(screen: screen)
            Divider()
            WallpaperItem(screen: screen)
        }
    }
}

#Preview {
    Menu(NSScreen.main?.localizedName ?? "") {
        ScreenItems(screen: NSScreen.main!)
    }
    .frame(width: 120)
}
