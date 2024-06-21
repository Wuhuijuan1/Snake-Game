//
//  GameStartVC.swift
//  Snake
//
//  Created by Wuhuijuan on 2024/6/18.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        installUI()
    }
    
    
    func installUI() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brown,
            NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 56)] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSAttributedString(string: "Snake", attributes: attributes)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(56)
        }
        
        let playBtn = UIButton()
        playBtn.addTarget(self, action: #selector(gotoGameView), for: .touchUpInside)
        playBtn.titleLabel?.numberOfLines = 0
        playBtn.titleLabel?.textAlignment = .center
        playBtn.setTitleColor(.white, for: .normal)
        playBtn.backgroundColor = .blue
        playBtn.layer.cornerRadius = 24
        playBtn.clipsToBounds = true
        playBtn.setTitle("Play", for: .normal)
        playBtn.titleLabel?.font = .systemFont(ofSize: 28)
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(300)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
        }
    }
    
    @objc func gotoGameView() {
        let viewController = GameVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
