//
//  DetailView.swift
//  Viewer
//
//  Created by C Apple on 12/02/2021.
//

import SwiftUI

struct ObjectDetailView: View {
    let object: ObjectModel

    @State private var zoom: Float = 1

    var body: some View {
        VStack {
            Text(object.name)
            GraphicsViewController(300, 300, object, $zoom)
                .frame(width: 300, height: 300)
                .cornerRadius(10)

            Slider(value: $zoom, in: 0...5, step: 0.1)
            Text(String(format: "Current object distance level: %.1f", zoom))
        }
        Spacer()
    }
}

