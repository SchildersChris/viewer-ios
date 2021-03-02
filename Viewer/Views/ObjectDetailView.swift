//
//  ObjectDetailView.swift
//
//  Created by C Apple on 12/02/2021.
//

import SwiftUI

struct ObjectDetailView: View {
    let object: ObjectModel

    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var translate: (x: Float, y: Float, z: Float) = (x: 0, y: 0, z: -10)
    @State private var rotate: Bool = true

    var body: some View {
        if sizeClass != .compact {
        }

        GraphicsView(
            object: object,
            translate: $translate,
            rotate: $rotate)
                .ignoresSafeArea()
                .navigationBarHidden(sizeClass == .regular)

        if sizeClass == .regular {
            VStack {
                Slider(value: $translate.x, in: -10...10, step: 0.1)
                Text(String(format: "X translate value: %.1f", translate.x))

                Slider(value: $translate.y, in: -10...10, step: 0.1)
                Text(String(format: "Y translate value: %.1f", translate.y))

                Slider(value: $translate.z, in: -20...20, step: 0.1)
                Text(String(format: "Z translate value: %.1f", translate.z))

                Toggle(isOn: $rotate, label: {
                    Text("Rotate")
                })
            }.padding()
        }
    }
}

