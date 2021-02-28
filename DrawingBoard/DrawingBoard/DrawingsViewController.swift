//
//  DrawingsViewController.swift
//  DrawingBoard
//
//  Created by Student on 12/13/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import UIKit

class DrawingsViewController: UITableViewController {
    
    var drawingStore: DrawingStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func addNewDrawing() -> Int? {
        let newDrawing = drawingStore.createDrawing()
        
        if let index = drawingStore.allDrawings.firstIndex(of: newDrawing) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
            return index
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawingStore.allDrawings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawingCell", for: indexPath) as! DrawingCell
        let drawing = drawingStore.allDrawings[indexPath.row]
        cell.nameLabel.text = drawing.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let drawing = drawingStore.allDrawings[indexPath.row]
            drawingStore.removeDrawing(drawing)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        drawingStore.moveDrawing(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDrawing":
            if let row = tableView.indexPathForSelectedRow?.row {
                let drawing = drawingStore.allDrawings[row]
                let canvasViewController = segue.destination as! CanvasViewController
                canvasViewController.drawing = drawing
                canvasViewController.canvas.finishedLines = drawing.lines
                for line in canvasViewController.canvas.finishedLines {
                    canvasViewController.canvas.stroke(line)
                }
                canvasViewController.canvas.setNeedsDisplay()
            }
        case "addDrawing": 
            if let row = addNewDrawing() {
                let drawing = drawingStore.allDrawings[row]
                let canvasViewController = segue.destination as! CanvasViewController
                canvasViewController.drawing = drawing
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    }


  


