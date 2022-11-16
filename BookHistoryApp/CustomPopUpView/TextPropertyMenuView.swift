//
//  TextPropertyMenuView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit
import SnapKit

class TextPropertyMenuView: UIView {
    
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var keyDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.addTarget(self, action: #selector(keyDownTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemGray
        return button
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let buttonArr: [UIButton] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    @objc private func keyDownTapped(_ sender: UIButton){
        NotificationCenter.default.post(Notification(name: Notification.keyDown))
    }
}
private extension TextPropertyMenuView {
    
    func configure(){
        
        [scrollView,separatorLine,keyDownButton].forEach{
            self.addSubview($0)
        }
        
        scrollView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(44)
            $0.height.equalTo(44)
        }
        
        keyDownButton.snp.makeConstraints{
            $0.width.height.equalTo(44)
            $0.trailing.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints{
            $0.height.equalTo(22)
            $0.width.equalTo(1)
            $0.centerY.equalTo(keyDownButton.snp.centerY)
            $0.trailing.equalTo(keyDownButton.snp.leading)
        }
        
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        (1...3).forEach{ k in
            print(k)
            let button = UIButton()
            button.contentMode = .scaleAspectFit
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.backgroundColor = .systemPink
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints{
                $0.width.height.equalTo(44)
            }
        }
        
    }
    
}
