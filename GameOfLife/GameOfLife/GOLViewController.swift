//
//  GOLViewController.swift
//  GameOfLife
//
//  Created by Lambda_School_Loaner_148 on 6/26/20.
//  Copyright © 2020 Diante Lewis-Jolley. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    //MARK: - Properties
    var grid: Grid!
    var settingsVC: SettingsViewController!
    var timer = Timer()
    var isRunning = false
    let presetView = UIView()
    var presetTableView = UITableView()
    
    
    var label = UILabel()
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setBackgroundGradient()
        grid = Grid(width: self.view.frame.width, height: self.view.frame.height, view: self.view)
        settingsVC = SettingsViewController(grid: grid)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name: .generationChanged, object: nil)
        configurePresetBar()
        setupPreset()
        setupTableView()
        configureCurrentPresetLabel()
        configurePresets()
        configureCurrentPresetView(index: 0)
    }
    
    @objc func updateTitle(_ notification: NSNotification ) {
        if let dict = notification.userInfo {
            if let id = dict["generations"] as? Int {
                if id == 0{
                    title = "Game of Life"
                } else {
                    title = "\(id) Generations"
                }
            }
        }
    }
    @IBAction func buttonpressed(_ sender: UIBarButtonItem) {
        if isRunning == false {
            isRunning = true
            sender.image = UIImage(systemName: "pause.circle")
            nextButton.isEnabled = false
        } else {
            isRunning = false
            sender.image = UIImage(systemName: "play.circle")
            nextButton.isEnabled = true
        }
        grid.configureTimer()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        if isRunning == false {
            grid.computeNext()
            grid.generations += 1
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        present(settingsVC, animated: true)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        grid.resetGame()
    }
    
    func configureCurrentPresetLabel() {
        label.text = "Current Brush: Dot"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 5),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
    }
    
    func configureCurrentPresetView(index: Int) {
        if grid.currentPreset != nil { grid.currentPreset.removeFromSuperview() }
        let selectedPreset = grid.presets[index]
        let preset = ShapePreset(size: selectedPreset.size, cellWidth: selectedPreset.cellWidth, brushType: selectedPreset.currentBrush)
        grid.currentPreset = preset
        preset.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preset)
        
        NSLayoutConstraint.activate([
            preset.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            preset.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -preset.frame.width / 2)
        ])
        
        label.text = "Current Brush: " + grid.currentPreset.currentBrush.rawValue.capitalized
    }
    
    
    
    func configurePresetBar() {
        presetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presetView)
        presetView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            presetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            presetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presetView.topAnchor.constraint(equalTo: grid.screenArray[24][24].bottomAnchor)
        ])
    }
    
    func setupPreset() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.presetView.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.presetView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.presetView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.presetView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        self.presetTableView = tableView
    }
    
    func setupTableView() {
        self.presetTableView.dataSource = self
        self.presetTableView.delegate = self
        self.presetTableView.allowsSelection = true
        self.presetTableView.register(PresetCell.self, forCellReuseIdentifier: "PresetCell")
        presetTableView.backgroundColor = .clear
    }
    
    
    
    func configurePresets() {
        grid.presets.append(ShapePreset(size: 1, cellWidth: grid.cellSize, brushType: .dot))
        grid.presets.append(ShapePreset(size: 2, cellWidth: grid.cellSize, brushType: .block))
        grid.presets.append(ShapePreset(size: 3, cellWidth: grid.cellSize, brushType: .blinker))
        grid.presets.append(ShapePreset(size: 3, cellWidth: grid.cellSize, brushType: .glider))
        grid.presets.append(ShapePreset(size: 3, cellWidth: grid.cellSize, brushType: .rPentomino))
        grid.presets.append(ShapePreset(size: 4, cellWidth: grid.cellSize, brushType: .beacon))
        grid.presets.append(ShapePreset(size: 1, cellWidth: grid.cellSize, brushType: .random))
    }
    
    func setBackgroundGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.gray.cgColor, UIColor.systemBlue.cgColor]
        layer.startPoint = CGPoint(x: 0,y: 0)
        layer.endPoint = CGPoint(x: 1,y: 1)
        view.layer.addSublayer(layer)
        
    }
    
}

extension GameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return grid.presets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetCell", for: indexPath) as! PresetCell
        
        cell.set(preset: grid.presets[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureCurrentPresetView(index: indexPath.row)

        
        if indexPath.row == 6 {
        grid.resetGrid(grid: grid.screenArray)
            for x in 0...24 {
                for y in 0...24 {
                    let rand = Int.random(in: 0...4)
                    if rand == 1 {
                        grid.screenArray[x][y].makeAlive()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
