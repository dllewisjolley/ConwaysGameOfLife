//
//  Settings.swift
//  GameOfLife
//
//  Created by Lambda_School_Loaner_148 on 6/26/20.
//  Copyright © 2020 Diante Lewis-Jolley. All rights reserved.
//

import UIKit

enum CellColor: Int {
    case green = 1
    case blue
    case red
    case black
    case random
}

class Settings{

    static let shared = Settings()
    var cellColor: CellColor = .black {
        didSet{
            NotificationCenter.default.post(name: .didChangeCellColor, object: nil)
        }
    }

}
