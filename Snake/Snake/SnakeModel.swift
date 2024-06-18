//
//  SnakeModel.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/18.
//

import UIKit
import RxSwift

enum Direction {
    case top, left, bottom, right
}

class SnakeModel {
    var header: SnakePieceModel {
        var header = self.dataSource[0]
        for model in self.dataSource {
            if model.isHead {
                header = model
                break
            }
        }
        return header
    }
    @RxObservable var dataSource: [SnakePieceModel] = []
    var width: CGFloat
    var height: CGFloat
    var direction: Direction {
        didSet {
            updateDataSourceSubject.onNext(self.direction)
            if self.direction != self.preDirection {
                self.direction = self.preDirection ?? .right
            }
        }
    }
    var preDirection: Direction?
    
    init(width: CGFloat, height: CGFloat, direction: Direction) {
        self.width = width
        self.height = height
        self.direction = direction
        self.dataSource = [SnakePieceModel(x: 40 + width, y: 100, width: width, height: height, isHead: true), SnakePieceModel(x: 40, y: 100, width: width, height: height, isHead: false)]
    }
    
    let updateDataSourceSubject = PublishSubject<Direction>()
    let updateUISubject = PublishSubject<SnakePieceModel>()
    let gameOverSubject = PublishSubject<Int>()
    
    func addModel() {
        guard let last = dataSource.last else { return }
        var x = last.x
        var y = last.y
        switch last.direction {
        case .top:
            y += last.height
        case .bottom:
            y -= last.height
        case .left:
            x += last.width
        case .right:
            x -= last.width
        }
        let model = SnakePieceModel(x: x, y: y, width: width, height: height)
        model.direction = last.direction
        model.preItem = last
        last.lastItem = model
        dataSource.append(model)
    }
}
