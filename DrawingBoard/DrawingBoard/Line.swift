//
//  Line.swift
//  DrawingBoard
//
//  Created by Student on 11/14/20.
//  Copyright © 2020 Jareds apps. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


struct Line: Equatable, Codable {
    var points = [CGPoint]()
    var width = CGFloat(8)
}


