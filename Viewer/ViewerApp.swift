//
//  ViewerApp.swift
//  Viewer
//
//  Created by C Apple on 11/02/2021.
//
import UIKit
import SwiftUI

@main
struct ViewerApp: App {

    var body: some Scene {
        WindowGroup {
            ObjectListView()
                .environmentObject(OrientationInfo())
        }
    }
}
