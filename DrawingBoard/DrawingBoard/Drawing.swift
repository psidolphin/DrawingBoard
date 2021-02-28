//
//  Drawing.swift
//  DrawingBoard
//
//  Created by Student on 11/16/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import Foundation
import UIKit

class Drawing: NSObject, Codable {
    var name: String
    var lines: [Line]
    let drawingKey: String
    

    init(name:String, lines: [Line]?) {
        self.name = name
        self.lines = [Line]()
        self.drawingKey = UUID().uuidString
        
    }
    
    static func ==(lhs: Drawing, rhs: Drawing) -> Bool {
        return lhs.name == rhs.name && lhs.lines == rhs.lines
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        drawingKey = aDecoder.decodeObject(forKey: "drawingKey") as! String
        lines = aDecoder.decodeObject(forKey:"lines") as! [Line]
        super.init()
    }
    
}
