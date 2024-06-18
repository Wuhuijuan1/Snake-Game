//
//  GameVC.swift
//  Snake
//
//  Created by Wuhuijuan on 2023/4/20.
//

import UIKit
import RxSwift
import SnapKit


class GameVC: UIViewController {
    let foodView = FoodView()
    let snake = Snake(model: SnakeModel(width: 24, height: 24, direction: .right))
    var disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        view.addSubview(foodView)
        foodView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        foodView.createFood()
        
        view.addSubview(snake)
        snake.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindViewModel() {
        disposBag = DisposeBag()
        snake.model.updateUISubject.subscribe { [weak self] model in
            guard let header = model.element, let self = self, let food = self.foodView.foodPieceView else { return }
            let xOffset = header.x - food.model.centerX
            let yOffset = header.y - food.model.centerY
            let distance = CGFloat(sqrtf(Float(xOffset * xOffset + yOffset * yOffset)))
            if distance < header.width + food.model.width && distance < header.height * 0.5 + food.model.height * 0.5 {
                self.foodView.eatFood()
                self.snake.model.addModel()
            }
        }
        .disposed(by: disposBag)
        
        snake.model.gameOverSubject.subscribe { [weak self] score in
            guard let self = self else { return }
            self.endGame()
            let alert = UIAlertController(title: "Game Over", message: "The score of this game is \((score.element ?? 0) * 100)", preferredStyle: .alert)
            let again = UIAlertAction(title: "Again", style: .default) { [weak self] _ in
                self?.tryAgain()
            }
            let cancle = UIAlertAction(title: "Cancle", style: .cancel) { [weak self] _ in
                self?.quit()
            }
            alert.addAction(again)
            alert.addAction(cancle)
            self.present(alert, animated: true)
        }
        .disposed(by: disposBag)
    }

    func endGame() {
        snake.end()
        foodView.end()
    }
    
    func tryAgain() {
        snake.start()
        foodView.start()
        self.bindViewModel()
    }
    
    func quit() {
        self.navigationController?.popViewController(animated: true)
    }
}
