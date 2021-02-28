//
//  DrawingStore.swift
//  DrawingBoard
//
//  Created by Student on 11/16/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import Foundation
import UIKit
class DrawingStore {
    var allDrawings = [Drawing]()
    let drawingArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("drawings.plist")
    }()
   
    init() {
        do {
            let data = try Data(contentsOf: drawingArchiveURL)
            let unarchiver = PropertyListDecoder()
            let drawings = try unarchiver.decode([Drawing].self, from: data)
            allDrawings =  drawings
        } catch {
            print("Error reading in saved items: \(error)")
        }
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(saveChanges), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createDrawing() -> Drawing {
        let newDrawing = Drawing(name: "",lines: [] )
        allDrawings.append(newDrawing)
        return newDrawing
    }

    func removeDrawing(_ drawing: Drawing) {
        if let index = allDrawings.firstIndex(of: drawing) {
            allDrawings.remove(at: index)
        }
    }
    
    func moveDrawing(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedDrawing = allDrawings[fromIndex]
        allDrawings.remove(at: fromIndex)
        allDrawings.insert(movedDrawing, at: toIndex)
    }
    
    
  @discardableResult @objc func saveChanges() -> Bool {
        print("Saving items to: \(drawingArchiveURL)")
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allDrawings)
            try data.write(to: drawingArchiveURL)
            print("Saved all of the items")
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
}




//the drawing is a collection of lines, save the collection of lines and redraw them when loading
//note to future me: Im glad you revisited the project
