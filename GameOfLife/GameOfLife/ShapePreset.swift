//
//  ShapePreset.swift
//  GameOfLife
//
//  Created by Lambda_School_Loaner_148 on 6/26/20.
//  Copyright © 2020 Diante Lewis-Jolley. All rights reserved.
//

import UIKit

enum BrushType: String {
    case dot
    case block
    case blinker
    case glider
    case beacon
    case rPentomino
    case random

}

class ShapePreset: UIView {

    var cellWidth: CGFloat
    var box = [[Cell]]()
    var size: Int
    init( size: Int, cellWidth: CGFloat, brushType: BrushType) {
        self.size = size
        self.currentBrush = brushType
        self.cellWidth = cellWidth
        super.init(frame: CGRect(x: 0, y: 0, width: Int(cellWidth) * size, height: Int(cellWidth) * size))
        self.backgroundColor = .white
        box = setupPresetGrid()
        setupPreset()
        
    }
    var currentBrush: BrushType = .dot
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPresetGrid() -> [[Cell]] {
        
        var grid = [[Cell]]()
        var gridColumn = [Cell]()
        for j in 0...(size - 1) {
            for i in 0...(size - 1) {
                let cell = Cell(frame: CGRect(x: cellWidth * CGFloat(j), y: cellWidth * CGFloat(i), width: cellWidth, height: cellWidth))

                cell.isUserInteractionEnabled = false
                addSubview(cell)
                
                gridColumn.append(cell)
            }
            grid.append(gridColumn)
            gridColumn.removeAll()
        }
        return grid
    }
    
    func setupPreset() {
        if currentBrush == .dot {
            box[0][0].makeAlive()
        }
        switch currentBrush {

        case .dot:
            box[0][0].makeAlive()
        case .blinker:
            box[1][0].makeAlive()
            box[1][1].makeAlive()
            box[1][2].makeAlive()
        case .glider:
            box[1][0].makeAlive()
            box[2][1].makeAlive()
            box[0][2].makeAlive()
            box[1][2].makeAlive()
            box[2][2].makeAlive()
        case .beacon:
            box[0][0].makeAlive()
            box[1][0].makeAlive()
            box[0][1].makeAlive()
            box[3][2].makeAlive()
            box[2][3].makeAlive()
            box[3][3].makeAlive()
        case .block:
            box[0][0].makeAlive()
            box[0][1].makeAlive()
            box[1][0].makeAlive()
            box[1][1].makeAlive()
        case .rPentomino:
            box[1][0].makeAlive()
            box[2][0].makeAlive()
            box[0][1].makeAlive()
            box[1][1].makeAlive()
            box[1][2].makeAlive()

            
            
        case .random:
            print("random")
        }
        
    }
    
    
    
}
