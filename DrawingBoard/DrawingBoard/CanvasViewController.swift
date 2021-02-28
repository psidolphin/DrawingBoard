//
//  CanvasViewController.swift
//  DrawingBoard
//
//  Created by Student on 11/19/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import Foundation
import UIKit
class CanvasViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var canvas: BoardView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var backgroundbutton: UIBarButtonItem!
    @IBOutlet var clearButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var drawing = Drawing(name: "", lines: nil)
    
    @IBAction func backgroundButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Change background color", message: "change background color", preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        let blueAction = UIAlertAction(title: "blue", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.blue})
        alertController.addAction(blueAction)
        let blackAction = UIAlertAction(title: "black", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.black})
        alertController.addAction(blackAction)
        let brownAction = UIAlertAction(title: "brown", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.brown})
        alertController.addAction(brownAction)
        let cyanAction = UIAlertAction(title: "cyan", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.cyan})
        alertController.addAction(cyanAction)
        let grayAction = UIAlertAction(title: "grey", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.gray})
        alertController.addAction(grayAction)
        let greenAction = UIAlertAction(title: "green", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.green})
        alertController.addAction(greenAction)
        let magentaAction = UIAlertAction(title: "magenta", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.magenta})
        alertController.addAction(magentaAction)
        let orangeAction = UIAlertAction(title: "orange", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.orange})
        alertController.addAction(orangeAction)
        let whiteAction = UIAlertAction(title: "white", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.white})
        alertController.addAction(whiteAction)
        let yellowAction = UIAlertAction(title: "yellow", style: .default, handler: {(alert: UIAlertAction!) in self.canvas.backgroundColor = UIColor.yellow})
        alertController.addAction(yellowAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Name the drawing", message: "", preferredStyle: .alert)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
        }
        
        let saveAction = UIAlertAction(title: "save", style: .default, handler: {(alert: UIAlertAction!) in
            self.drawing.name = alertController.textFields?[0].text ?? ""
            self.viewWillDisappear(true)
            
        })
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        self.canvas.finishedLines.removeAll()
        self.canvas.setNeedsDisplay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        drawing.lines = self.canvas.finishedLines
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
}
