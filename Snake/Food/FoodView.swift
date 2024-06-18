//
//  FoodView.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import UIKit

class FoodView: UIView {
    let width: CGFloat = 24.0
    let height: CGFloat = 24.0
    var foodPieceView: FoodPieceView?
    var timer: Timer?
    
    init() {
        super.init(frame: CGRect.zero)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(startTimer),
            userInfo: nil,
            repeats: true)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startTimer() {
        if foodPieceView != nil {
            return
        }
        createFood()
    }
    
    func createFood() {
        let width = self.bounds.width
        let height = self.bounds.height
        if width == 0 || height == 0 {
            return
        }

        let centerX = CGFloat(arc4random()%UInt32(width - self.width)) + self.width * 0.5
        let centerY = CGFloat(arc4random()%UInt32(height - self.height)) + self.height * 0.5

        let foodPieceView = FoodPieceView(model: FoodPieceModel(centerX: centerX, centerY: centerY, width: self.width, height: self.height))
        self.foodPieceView = foodPieceView
        addSubview(foodPieceView)
        foodPieceView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(centerX - self.width * 0.5)
            make.top.equalToSuperview().offset(centerY - self.height * 0.5)
            make.height.equalTo(self.height)
            make.width.equalTo(self.width)
        }
    }
    
    func eatFood() {
        guard foodPieceView != nil else { return }
        self.foodPieceView?.removeFromSuperview()
        self.foodPieceView = nil
    }
    
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(startTimer),
            userInfo: nil,
            repeats: true)
    }
    
    func end() {
        timer?.invalidate()
        timer = nil
    }
}
