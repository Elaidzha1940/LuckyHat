//
//  ViewController.swift
//  LuckyHat
//
//  Created by Elaidzha Shchukin on 25.05.2023.
//

import UIKit


class ViewController: UIViewController {
    let fieldSize = CGSize(width: 30, height: 45) // Adjust the size of the field for different levels
    let cellSize = CGSize(width: 50, height: 50)
    let maxSum = 10
    
    var cells = [[UILabel]]()
    var selectedCells = [UILabel]()
    var lives = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createField()
    }
    
    func createField() {
        for row in 0..<Int(fieldSize.height) {
            var cellRow = [UILabel]()
            for col in 0..<Int(fieldSize.width) {
                let cell = createCell(row: row, col: col)
                cellRow.append(cell)
            }
            cells.append(cellRow)
        }
    }
    
    func createCell(row: Int, col: Int) -> UILabel {
        let cellFrame = CGRect(x: CGFloat(col) * cellSize.width, y: CGFloat(row) * cellSize.height, width: cellSize.width, height: cellSize.height)
        let cell = UILabel(frame: cellFrame)
        cell.textAlignment = .center
        cell.backgroundColor = UIColor.lightGray
        cell.text = "\(Int.random(in: 1...9))"
        cell.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        view.addSubview(cell)
        return cell
    }
    
    @objc func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard let selectedCell = gesture.view as? UILabel else { return }
        
        if selectedCells.isEmpty || isSelectedCellAdjacent(selectedCell) {
            selectedCell.backgroundColor = UIColor.blue
            selectedCells.append(selectedCell)
        } else {
            resetSelection()
        }
        
        if calculateSum() > maxSum {
            lives -= 1
            if lives == 0 {
                gameOver()
            }
            resetSelection()
        } else if calculateSum() == maxSum {
            removeSelectedCells()
        }
    }
    
    func isSelectedCellAdjacent(_ selectedCell: UILabel) -> Bool {
        let lastSelectedCell = selectedCells.last!
        let dx = abs(Int(lastSelectedCell.frame.origin.x / cellSize.width) - Int(selectedCell.frame.origin.x / cellSize.width))
        let dy = abs(Int(lastSelectedCell.frame.origin.y / cellSize.height) - Int(selectedCell.frame.origin.y / cellSize.height))
        
        return (dx == 0 && dy == 1) || (dx == 1 && dy == 0)
    }
    
    func calculateSum() -> Int {
        return selectedCells.reduce(0) { sum, cell in
            return sum + Int(cell.text!)!
        }
    }
    
    func resetSelection() {
        selectedCells.forEach { $0.backgroundColor = UIColor.lightGray }
        selectedCells.removeAll()
    }
    
    func removeSelectedCells() {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedCells.forEach { $0.alpha = 0 }
        }, completion: { _ in
            self.selectedCells.forEach { $0.removeFromSuperview() }
            self.selectedCells.removeAll()
        })
    }
    
    func gameOver() {
        // Game over logic
    }
}


