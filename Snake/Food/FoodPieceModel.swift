//
//  FoodPieceModel.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/19.
//

import Foundation

struct FoodPieceModel {
    var centerX: CGFloat
    var centerY: CGFloat
    var width: CGFloat
    var height: CGFloat
    init(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
    }
}
