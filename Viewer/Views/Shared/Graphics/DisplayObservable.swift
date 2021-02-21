//
// Created by C Apple on 21/02/2021.
//

import UIKit

class DisplayObservable {
    weak var observer: DisplayObserver?
    private var display: CADisplayLink? = nil
    private var lastTime: CFTimeInterval = 0.0

    init(observer: DisplayObserver) {
        self.observer = observer
        guard display == nil else { return }

        display = CADisplayLink(target: self, selector: #selector(update))
        display?.add(to: .main, forMode: .common)
        lastTime = 0.0
    }

    @objc private func update() {
        guard let display = display else {return }

        let currentTime = display.timestamp
        let delta: CFTimeInterval = currentTime - lastTime
        lastTime = currentTime

        observer?.update(delta)
    }

    func stop() {
        display?.remove(from: .main, forMode: .common)
        display?.invalidate()
        display = nil

        lastTime = 0.0
    }

    deinit {
        stop()
    }
}

