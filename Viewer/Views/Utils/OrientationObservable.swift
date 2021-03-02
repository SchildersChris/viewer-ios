//
// Created by C Apple on 01/03/2021.
//

import UIKit

class OrientationObservable {
    weak var observer: OrientationObserver?

    init(observer: OrientationObserver) {
        self.observer = observer

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(rotated),
                name: UIDevice.orientationDidChangeNotification,
                object: self)
    }

    @objc private func rotated() {
        observer?.rotated(orientation: UIDevice.current.orientation)
    }

    func stop() {
        NotificationCenter.default.removeObserver(
                self,
                name: UIDevice.orientationDidChangeNotification,
                object: self)
    }

    deinit {
        stop()
    }
}