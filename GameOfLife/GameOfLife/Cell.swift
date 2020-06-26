//
//  Cell.swift
//  GameOfLife
//
//  Created by Lambda_School_Loaner_148 on 6/26/20.
//  Copyright © 2020 Diante Lewis-Jolley. All rights reserved.
//

import UIKit

class Cell: UIView {
    var grid: Grid?
    var isAlive: Bool = false
    var color: UIColor{
        switch Settings.shared.cellColor {
            
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        case .red:
            return .systemRed
        case .black:
            return .black
        case .random:
            return UIColor().getRandomColor()
        }
    }
    
    
    init(frame: CGRect, isAlive: Bool = false ) {
        super.init(frame: frame)
        self.isAlive = isAlive
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(colorChanged), name: .didChangeCellColor, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func colorChanged() {
        if isAlive { backgroundColor = color }
    }
    
    func configureView() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.20)
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func makeDead() {
        self.isAlive = false
        self.backgroundColor = UIColor(white: 1, alpha: 0.20)
    }
    
    func makeAlive() {
        isAlive = true
        backgroundColor = color
    }
    
    func getCoordinates() -> (x: Int, y: Int)? {
        for x in 0...24 {
            for y in 0...24 {
                if grid?.screenArray[x][y] == self {
                    return (x: x, y: y)
                }
            }
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let preset = grid?.currentPreset else { return }
        guard let coordinates = getCoordinates() else { return }
        if preset.box.count == 1 {
            if isAlive == false {
                makeAlive()
            } else {
                makeDead()
            }
        } else if ((preset.box.count * preset.box.count) / 2) == 2 {
            checkFor4(coordinates: coordinates)
        } else if ((preset.box.count * preset.box.count) / 2) == 4 {
            checkFor9(coordinates: coordinates)
        } else if ((preset.box.count * preset.box.count) / 2) == 8 {
            checkFor16(coordinates: coordinates)
        }
    }
    
    func checkFor4(coordinates: (x: Int, y: Int)) {
        let rows = 25

        for i in coordinates.x...coordinates.x+1 {
            for j in coordinates.y...coordinates.y+1 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x ][j - coordinates.y].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].makeAlive()
                } else {
                    grid?.screenArray[i][j].makeDead()
                }
            }
        }
    }
    
    func checkFor16(coordinates: (x: Int, y: Int)) {
        let rows = 25
        
        for i in coordinates.x-1...coordinates.x+2 {
            for j in coordinates.y-1...coordinates.y+2 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x + 1][j - coordinates.y + 1].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].makeAlive()
                } else {
                    grid?.screenArray[i][j].makeDead()
                }
            }
        }
    }
    
    func checkFor9(coordinates: (x: Int, y: Int)) {
        let rows = 25
        
        for i in coordinates.x-1...coordinates.x+1 {
            for j in coordinates.y-1...coordinates.y+1 {
                if ((i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0)) {
                    continue
                }
                
                guard let presetCellIsActive = grid?.currentPreset.box[i - coordinates.x + 1][j - coordinates.y + 1].isAlive else { return }
                if presetCellIsActive {
                    grid?.screenArray[i][j].makeAlive()
                } else {
                    grid?.screenArray[i][j].makeDead()
                }
            }
        }
    }
}

import UIKit

extension UIColor {
    func getRandomColor() -> UIColor {
        let randomNum = Int.random(in: 1...4)
        switch randomNum {
        case 1:
            return UIColor.yellow
        case 2:
             return UIColor.red
        case 3:
            return UIColor.blue
        case 4:
            return UIColor.green
        default:
            return UIColor.black
        }
    }
}
