//
// Created by C Apple on 02/03/2021.
//

import UIKit

final class OrientationInfo: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
    }

    @Published var orientation: Orientation

    private var observer: NSObjectProtocol?

    init() {
        orientation =
                UIDevice.current.orientation.isLandscape
                ? .landscape : .portrait

        observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else { return }

            if device.orientation.isPortrait &&
               device.orientation.rawValue == 1 /* Home button at bottom */ {
                orientation = .portrait
            }
            else if device.orientation.isLandscape {
                orientation = .landscape
            }
        }
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}