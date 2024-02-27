//
//  MainMenu.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/27.
//

import SwiftUI

struct MainMenu: View {
    
    var body: some View {
        ScreenMenus()
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }.keyboardShortcut("q")
        
    }
}

#Preview {
    MainMenu()
}
