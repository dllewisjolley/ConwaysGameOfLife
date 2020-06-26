//
//  Grid.swift
//  GameOfLife
//
//  Created by Lambda_School_Loaner_148 on 6/26/20.
//  Copyright © 2020 Diante Lewis-Jolley. All rights reserved.
//

import UIKit

class Grid {
    
    var screenArray = [[Cell]]()
    var nextArray = [[Cell]]()
    var timer: Timer = Timer()
    var width: CGFloat!
    var height: CGFloat!
    var view: UIView!
    var cellSize: CGFloat!
    var currentPreset: ShapePreset!
    var presets: [ShapePreset] = []
    var generations = 0 {
        didSet{
            NotificationCenter.default.post(name: .generationChanged, object: nil, userInfo: ["generations": generations])
        }
    }
    var speed: Float = 0.3 {
        didSet{
            if timer.isValid {
            speedChanged()
            }
        }
    }
    
    init(width: CGFloat, height: CGFloat, view: UIView) {
        self.width = width
        self.height = height
        self.view = view
        self.cellSize = width / 25
        self.screenArray = setupGrid(width: width, height: height, view: view)
        self.nextArray = setupGrid(width: width, height: height, view: view, isNext: true)
        
    }
    

    
    
    func setupGrid(width: CGFloat, height: CGFloat, view: UIView, isNext: Bool = false) -> [[Cell]] {
        
        var grid = [[Cell]]()
        var gridColumn = [Cell]()
        for j in 0...24 {
            for i in 0...24 {
                let cell = Cell(frame: CGRect(x: width / 25 * CGFloat(j), y: height / 2 - width / 2 + width / 25 * CGFloat(i), width: width / 25, height: width / 25), isAlive: false)
                cell.grid = self
                if !isNext { view.addSubview(cell) }
                gridColumn.append(cell)
            }
            grid.append(gridColumn)
            gridColumn.removeAll()
        }
        return grid
    }
    
    func resetGame() {
        timer.invalidate()
        view.isUserInteractionEnabled = true
        resetGrid(grid: screenArray)
        generations = 0
    }
    
    func resetGrid(grid: [[Cell]]) {
        for x in 0...24 {
            for y in 0...24 {
                grid[x][y].makeDead()
            }
        }
    }
    
    func draw() {
        for x in 0...24 {
            for y in 0...24 {
                nextArray[x][y].isAlive ? screenArray[x][y].makeAlive() : screenArray[x][y].makeDead()
            }
        }

    }

    
    func computeNext(){
        resetGrid(grid: nextArray)
        
        for x in 0...24 {
            for y in 0...24 {
                let state = screenArray[x][y].isAlive
                let neighbors = countNeighbors(x: x, y: y)
                
                if state == true {
                    if neighbors == 2 || neighbors == 3 {
                        nextArray[x][y].makeAlive()
                    } else {
                        nextArray[x][y].makeDead()
                    }
                } else {
                    if neighbors == 3 {
                        nextArray[x][y].makeAlive()
                    }
                }
            }
        }
        draw()
        
    }
    
    func countNeighbors( x: Int, y: Int) -> Int{
        var count = 0
        let rows = 25
        
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if (i == x && j == y) || (i >= rows) || (j >= rows) || ( i < 0 ) || (j < 0) {
                    continue
                }
                if screenArray[i][j].isAlive { count += 1}
            }
        }
        return count
    }
    
    
    func configureTimer() {
        
        if timer.isValid {
            timer.invalidate()
            view.isUserInteractionEnabled = true
            
        } else {
            view.isUserInteractionEnabled = false
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(speed), repeats: true, block: { (timer) in
                self.run()
            })
        }
    }
    
    func speedChanged(){
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(speed), repeats: true, block: { (timer) in
            self.run()
        })
    }
    
    func run(){
        generations += 1
        computeNext()
    }
}

extension Notification.Name {
    static let didChangeCellColor = Notification.Name("didChangeCellColor")
    static let generationChanged = Notification.Name("generationChanged")
    static let gameReset = Notification.Name("gameReset")
}
