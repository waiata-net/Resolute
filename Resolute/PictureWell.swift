//
//  PictureWell.swift
//  Court
//
//  Created by Neal Watkins on 2023/4/13.
//

import SwiftUI

struct PictureWell: View {
    
    @Binding var picture: Picture?
    @State var cornerRadius: CGFloat = 8
    @FocusState var focus: Bool
    @State var isBrowsing = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            if let image = picture?.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } else {
                EmptyView()
            }
        }
        .background(.background)
        .cornerRadius(cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.accentColor , lineWidth: focus ? 1 : 0)
        }
        .focused($focus)
        .onTapGesture {
            focus = true
            isBrowsing = true
        }
        .contextMenu {
            Menu(picture: $picture)
        }
        .dropDestination(for: URL.self) { items, _ in
            guard let url = items.first else { return false }
            picture = picture ?? Picture()
            picture?.url = url
            return true
        }
        .fileImporter(isPresented: $isBrowsing, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let url) :
                if let _ = picture {
                    picture?.url = url
                } else {
                    picture = Picture(url: url)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    struct Menu: View {
        
        @Binding var picture: Picture?
        
        var body: some View {
            
            ForEach(Picture.Fit.allCases, id: \.self) { fit in
                Button {
                    picture?.fit = fit
                } label: {
                    Text(fit.label)
                }
            }
            Divider()
            Button {
                picture = nil
            } label: {
                Label("Clear", systemImage: "trash")
            }
        }
    }
    
}

struct PictureWell_Previews: PreviewProvider {
    @State static var pic: Picture? = Picture(url: URL(filePath: "/Users/neal/town/park/Court/art/App/Court App.png"), fit: .fill)
    static var previews: some View {
        PictureWell(picture: $pic)
            .padding()
        VStack {
            PictureWell.Menu(picture: $pic)
        }
        .buttonStyle(.borderless)
    }
}
