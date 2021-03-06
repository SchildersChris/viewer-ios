//
//  ContentView.swift
//  Viewer
//
//  Created by C Apple on 11/02/2021.
//

import SwiftUI

struct ObjectListView: View {
    @ObservedObject private var viewModel = ObjectViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                Group {
                    List(viewModel.objects, id: \.id) { object in
                        NavigationLink(destination: ObjectDetailView(object: object)
                                .navigationBarTitle(Text(object.name), displayMode: .inline)
                        ) {
                            Image(systemName: "move.3d")
                            Text(object.name)
                        }
                    }.onAppear {
                        viewModel.loadObjects()
                    }
                }.navigationBarTitle("Objects")
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
