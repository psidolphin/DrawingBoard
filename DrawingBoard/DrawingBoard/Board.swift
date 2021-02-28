//
//  Board.swift
//  DrawingBoard
//
//  Created by Student on 11/14/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var currentLine: Line?
    var finishedLines = [Line]()
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10 // must be user defined
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        if let line = currentLine {
        UIColor.blue.setStroke()
            stroke(line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)
        setNeedsDisplay()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            finishedLines.append(line)
        }
        currentLine = nil
        setNeedsDisplay()
    }
    
    
}
