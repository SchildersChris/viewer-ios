//
//  DetailView.swift
//  Viewer
//
//  Created by C Apple on 12/02/2021.
//

import SwiftUI

struct ObjectDetailView: View {
    let object: ObjectModel

    var body: some View {
            Text(object.name)
            GraphicsImageView(width: 300, height: 300, object: object)
                .frame(width: 300, height: 300)
                .cornerRadius(10)
    }
}

