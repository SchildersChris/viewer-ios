//
//  ObjectDetailView.swift
//
//  Created by C Apple on 12/02/2021.
//

import SwiftUI

struct ObjectDetailView: View {
    @ObservedObject private var viewModel: ObjectDetailViewModel
    @EnvironmentObject var orientationInfo: OrientationInfo

    @State private var translate: (x: Float, y: Float, z: Float) = (x: 0, y: 0, z: -10)
    @State private var rotate: Bool = true

    init (id: String) {
        viewModel = ObjectDetailViewModel(id: id)
    }

    var body: some View {
        Group {
            GraphicsView(
                object: $viewModel.object,
                translate: $translate,
                rotate: $rotate)
                .ignoresSafeArea()
                .navigationBarHidden(orientationInfo.orientation == .landscape)

            if orientationInfo.orientation == .portrait {
                VStack {
                    Slider(value: $translate.x, in: -10...10, step: 0.1)
                    Text(String(format: "X translate value: %.1f", translate.x))

                    Slider(value: $translate.y, in: -10...10, step: 0.1)
                    Text(String(format: "Y translate value: %.1f", translate.y))

                    Slider(value: $translate.z, in: -20...20, step: 0.1)
                    Text(String(format: "Z translate value: %.1f", translate.z))
                    /**
                        Following warning is show in the Console when running:
                         invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. This message will only appear once per execution.

                        This warning can be ignored: https://stackoverflow.com/questions/60155947/swiftui-usage-of-toggles-console-logs-invalid-mode-kcfrunloopcommonmodes
                     */
                    Toggle(isOn: $rotate, label: {
                        Text("Rotate")
                    })
                }.padding()
            }
        }.onAppear {
            viewModel.loadObject()
        }
    }
}

