//
//  ContentView.swift
//  Viewer
//
//  Created by C Apple on 11/02/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello world!").padding()
        GraphicsView(width: 300, height: 300)
            .frame(width: 300, height: 300)
            .cornerRadius(10)
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
