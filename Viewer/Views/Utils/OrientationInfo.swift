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

    private var _observer: NSObjectProtocol?

    init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            orientation = .landscape
        }
        else {
            orientation = .portrait
        }

        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else { return }

            if device.orientation.isPortrait &&
               device.orientation.rawValue == 1 /* Home button at bottom*/ {
                orientation = .portrait
            }
            else if device.orientation.isLandscape {
                orientation = .landscape
            }
        }
    }

    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}