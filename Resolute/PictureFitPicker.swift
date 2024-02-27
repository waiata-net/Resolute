//
//  PictureFitPicker.swift
//  Court
//
//  Created by Neal Watkins on 2023/4/19.
//

import SwiftUI

struct PictureFitPicker: View {
    
    @Binding var fit: Picture.Fit?
    @State var label = ""
    
    var body: some View {
        
        Picker(label, selection: $fit) {
            ForEach(Picture.Fit.allCases, id: \.self) { fit in
                Label(fit.label, image: fit.icon).tag(fit as Picture.Fit?)
            }
        }
    }
}

struct PictureFitPicker_Previews: PreviewProvider {
    @State static var dummy = Picture.Fit.fit as Picture.Fit?
    static var previews: some View {
        PictureFitPicker(fit: $dummy)
    }
}
