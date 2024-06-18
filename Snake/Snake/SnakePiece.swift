//
//  ASnake.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import UIKit

class SnakePiece: UIView {
    var model: SnakePieceModel
    var color: UIColor
    
    init(model: SnakePieceModel, color: UIColor = .black) {
        self.model = model
        self.color = color
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if model.isHead {
            UIColor.red.setFill()
        } else {
            color.setFill()
        }
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.3)
        path.fill()
    }
    
}
