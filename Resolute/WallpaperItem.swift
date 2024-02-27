//
//  WallpaperItem.swift
//  Resolute
//
//  Created by Neal Watkins on 2024/2/28.
//

import SwiftUI

struct WallpaperItem: View {
    
    var screen: NSScreen
    
    @Binding var wallpaper: Picture
    
    @State var bug: String = ""
    
    @State var importing = false
    
    init(screen: NSScreen) {
        self.screen = screen
        _wallpaper = Binding(
            get: { Picture(url: screen.wallpaperURL) },
            set: { screen.wallpaperURL = $0.url }
        )
    }
    
    var body: some View {
        Text(bug).hidden()
        Button {
            importing = true
        } label: {
            if let image = wallpaper.image { image }
            else { Text("Wallpaper") }
        }
        .fileImporter(isPresented: $importing
                      , allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let url) :
                wallpaper.url = url
            case .failure(let error) :
                print(error)
            }
        }
            

    }
}

#Preview {
    WallpaperItem(screen: NSScreen.main!)
    .frame(width: 120)
}
