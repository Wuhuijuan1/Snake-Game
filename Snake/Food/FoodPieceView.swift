//
//  FoodView.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import UIKit

class FoodPieceView: UIView {
    let model: FoodPieceModel
    
    init(model: FoodPieceModel) {
        self.model = model
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.setFill()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.5)
        path.fill()
    }
}



