//
//  Snake.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import UIKit
import RxSwift
import RxCocoa

class Snake: UIView {
    var model: SnakeModel
    var didSendGameOverMsg = false
    
    init(model: SnakeModel) {
        self.model = model
        
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        setupUI()
        self.start()
    }
    var timer: Timer?
    var disposeBag = DisposeBag()
    let panDisposeBag = DisposeBag()
    var startLocation = CGPoint.zero

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        model.dataSource.forEach { model in
            let snakeView = SnakePiece(model: model)
            UIView.animate(withDuration: 0.25) {
                snakeView.draw(CGRect(x: model.x - model.width * 0.5, y: model.y - model.height * 0.5, width: model.width, height: model.height))

            }
        }
    }
    
    @objc func startTimer() {
        model.updateDataSourceSubject.onNext(self.model.direction)
    }
    
    func addBody() {
        self.model.addModel()
    }

    func start() {
        didSendGameOverMsg = false
        let model = SnakeModel(width: self.model.width, height: self.model.height, direction: .right)
        for index in model.dataSource.indices {
            if index > 0 {
                model.dataSource[index].preItem = model.dataSource[index - 1]
            }
            
            if index < model.dataSource.count - 1 {
                model.dataSource[index].lastItem = model.dataSource[index + 1]
            }
        }
        self.model = model
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.3,
            target: self,
            selector: #selector(startTimer),
            userInfo: nil,
            repeats: true)
        bindViewModel()
    }
    
    func end() {
        self.timer?.invalidate()
        self.timer = nil
    }
}


extension Snake {
    func setupUI() {
        let pan = UIPanGestureRecognizer()
        self.addGestureRecognizer(pan)
        pan.rx.event.subscribe { [weak self] gesture in
            guard let pan = gesture.element, let self = self else { return }
            let location = pan.location(in: self)
            let state = pan.state
            switch state {
            case .began:
                self.startLocation = location
            case .ended:
                let xOffset = location.x - self.startLocation.x
                let yOffset = location.y - self.startLocation.y
                var dir: Direction = .left
            
                if abs(xOffset) < abs(yOffset) {
                    dir = yOffset > 0 ? .bottom : .top
                } else {
                    dir = xOffset > 0 ? .right : .left
                }
                if self.model.preDirection == dir {
                    return
                }
                self.model.direction = dir
            case .possible, .changed, .cancelled, .failed:
                break
            @unknown default:
                break
            }
        }
        .disposed(by: panDisposeBag)
        
    }
    
    func bindViewModel() {
        disposeBag = DisposeBag()
        model.updateDataSourceSubject.subscribe { [weak self] dir in
            guard let self = self else { return }
            let header = self.model.header
            let headerCopy = SnakePieceModel(x: header.x, y: header.y, width: header.width, height: header.height)
           

            switch dir {
            case .top:
                header.y -= header.height
            case .bottom:
                header.y += header.height
            case .left:
                header.x -= header.width
            case .right:
                header.x += header.width
            }
            if let lastItem = header.lastItem {
                let xOffset = lastItem.x - header.x
                let yOffset = lastItem.y - header.y
                if xOffset == 0 && yOffset == 0 {
                    self.model.header.x = headerCopy.x
                    self.model.header.y = headerCopy.y
                    return
                }
            }
            
            if (header.x < 0 || header.x > self.bounds.width || header.y < 0 || header.y > self.bounds.height) && self.didSendGameOverMsg == false  {
                self.model.gameOverSubject.onNext(self.model.dataSource.count)
                self.didSendGameOverMsg = true
                return
            }
            
            header.direction = dir
            updateEachSnakePieceModel()
            self.model.updateUISubject.onNext(header)
            self.model.preDirection = dir
            setNeedsDisplay()
        }
        .disposed(by: disposeBag)
        
        model.$dataSource.rsp.subscribe { [weak self] _ in
            self?.setNeedsDisplay()
        }
        .disposed(by: disposeBag)
    }

    func updateEachSnakePieceModel() {
        self.model.dataSource.forEach { model in
            if let preModel = model.preItem {
                let xOffset = preModel.x - model.x
                let yOffset = preModel.y - model.y
                if xOffset == 0 || yOffset == 0 {
                    model.x += xOffset * 0.5
                    model.y += yOffset * 0.5
                    if xOffset != 0 && xOffset < 0 {
                        model.direction = .left
                    } else if xOffset != 0 && xOffset > 0 {
                        model.direction = .right
                    } else if yOffset != 0 && yOffset < 0 {
                        model.direction = .top
                    } else if yOffset != 0 && yOffset > 0 {
                        model.direction = .bottom
                    }
                } else {
                    switch preModel.direction {
                    case .top, .bottom:
                        let xOffset = preModel.x - model.x
                        model.x += xOffset
                        model.direction = xOffset > 0 ? .right : .left
                    case .left, .right:
                        let yOffset = preModel.y - model.y
                        model.y += yOffset
                        model.direction = yOffset > 0 ? .bottom : .top
                    }
                }
            }
        }
    }
}
