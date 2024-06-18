//
//  SnakePieceModel.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import Foundation

class SnakePieceModel: NSObject {
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var isHead = false
    var preItem: SnakePieceModel?
    var lastItem: SnakePieceModel?
    var direction: Direction = .right
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, isHead: Bool = false) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.isHead = isHead
    }
}
