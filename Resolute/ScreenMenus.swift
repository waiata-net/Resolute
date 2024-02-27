//
//  ScreenButtons.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/27.
//

import SwiftUI

struct ScreenMenus: View {
    
    @State var screens = NSScreen.screens
    
    var body: some View {
        
        switch screens.count {
        case 0: EmptyView()
        case 1: ScreenItems(screen: screens.first!)
        default:
            ForEach(screens, id: \.id) { screen in
                Menu(screen.name) {
                    ScreenItems(screen: screen)
                }
            }
        }
    }
}

#Preview {
    ScreenMenus()
}
