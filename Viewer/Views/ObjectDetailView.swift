//
//  DetailView.swift
//  Viewer
//
//  Created by C Apple on 12/02/2021.
//

import SwiftUI
import Rasterizer

struct ObjectDetailView: View {
    let object: ObjectModel

    @State private var translate: Vector3 = Vector3(x: 0, y: 0, z: -10)
    @State private var rotate: Bool = true
    
    var body: some View {
        VStack {
            GraphicsViewController(
                width: 300, height: 300,
                object: object,
                translate: $translate,
                rotate: $rotate)
                .frame(width: 300, height: 300)
                .cornerRadius(10)

            Slider(value: $translate.x, in: -10...10, step: 0.1)
            Text(String(format: "X translate value: %.1f", translate.x))
            
            Slider(value: $translate.y, in: -10...10, step: 0.1)
            Text(String(format: "Y translate value: %.1f", translate.y))
            
            Slider(value: $translate.z, in: -20...20, step: 0.1)
            Text(String(format: "Z translate value: %.1f", translate.z))
            
            Toggle(isOn: $rotate, label: {
                Text("Rotate")
            })
        }.navigationBarTitle(Text(object.name), displayMode: .inline).padding()
        Spacer()
    }
}

