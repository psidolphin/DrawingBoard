//
//  BoardView.swift
//  DrawingBoard
//
//  Created by Student on 11/14/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//  Code is from Chapters 18 and 19 of the 6th edition of the big nerd ranch guide 


import UIKit
class BoardView: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
   
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BoardView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(tapRecognizer)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(BoardView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BoardView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
   
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = line.width
        path.lineCapStyle = .square
        path.move(to: line.points[0])
        for point in line.points.dropFirst() {
            path.addLine(to: point)
        }
        path.stroke()
    }
    
   
    
    
    
    override func draw(_ rect: CGRect) {
        for line in finishedLines {
            UIColor.black.setStroke()
            stroke(line)
        }
        UIColor.blue.setStroke()
        for (_, line) in currentLines {
            stroke(line)
        }
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            UIColor.green.setStroke()
            stroke(selectedLine)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            var newLine = Line()
            newLine.points.append(location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.points.append(touch.location(in: self))
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.points.append(touch.location(in: self))
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }
 
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            for p in line.points {
                let x = p.x
                let y = p.y
                if hypot(x - point.x, y - point.y) < 20 {
                    return index
                }
            }
        }
        return nil
        }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        setNeedsDisplay()
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            becomeFirstResponder()
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(BoardView.deleteLine(_:)))
            let thicknessUp = UIMenuItem(title: "thickness + 1", action: #selector(BoardView.thicknessUp(_:)))
            let thicknessDown = UIMenuItem(title: "thickness - 1", action: #selector(BoardView.thicknessDown(_:)))
            menu.menuItems = [deleteItem, thicknessUp, thicknessDown]
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        if let index = selectedLineIndex {
                if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                    for i in 0..<finishedLines[index].points.count {
                        finishedLines[index].points[i].x += translation.x
                        finishedLines[index].points[i].y += translation.y
                    }
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                currentLines.removeAll()
                setNeedsDisplay()
            }
        } else {
            return
        }
    }

    @objc func thicknessUp(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            var line = finishedLines.remove(at: index)
            line.width += 1
            stroke(line)
            finishedLines.append(line)
            setNeedsDisplay()
        }
    }
  
    @objc func thicknessDown(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            var line = finishedLines.remove(at: index)
            if line.width > 1 {
                line.width -= 1
                stroke(line)
                finishedLines.append(line)
                setNeedsDisplay()
            }else {
                line.width = 1
                stroke(line)
                finishedLines.append(line)
                setNeedsDisplay()
            }
        }
    }
}
