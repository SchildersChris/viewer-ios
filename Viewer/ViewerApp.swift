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
    init() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }
        
    var body: some Scene {
        WindowGroup {
            ObjectListView()
        }
    }
}
