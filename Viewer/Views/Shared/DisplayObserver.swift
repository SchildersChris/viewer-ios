//
// Created by C Apple on 21/02/2021.
//

import Foundation

protocol DisplayObserver: class {
    func update(_ deltaTime: CFTimeInterval)
}
