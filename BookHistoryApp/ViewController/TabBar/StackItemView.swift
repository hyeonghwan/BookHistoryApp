//
//  StackItemView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/19.
//

import UIKit
import SnapKit


protocol StackItemViewDelegate: AnyObject {
    func handleTap(_ view: StackItemView)
}

class StackItemView: UIView {
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    
    private let higlightBGColor = UIColor.systemYellow
    
    
    static var newInstance: StackItemView {
        let instance = StackItemView()
        return instance
    }
    
    weak var delegate: StackItemViewDelegate?
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = UIColor.black
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutConfigure()
        self.addTapGesture()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    

    
    private func configure(_ item: Any?) {
        guard let model = item as? BottomStackItem else { return }
        self.titleLabel.text = model.title
        self.imageView.image = UIImage(systemName: model.image) ?? UIImage(systemName: "circle")
        self.isSelected = model.isSelected
    }
    
    
    private func updateUI(isSelected: Bool) {
        guard let model = item as? BottomStackItem else { return }
        model.isSelected = isSelected
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: options,
                       animations: {
            self.titleLabel.text = isSelected ? model.title : ""
            let color = isSelected ? self.higlightBGColor : .white
            isSelected ? self.showText() : self.hideText()
            self.backgroundColor = color
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }, completion: nil)
    }
    
}

//MARK: - Handle Gesture
extension StackItemView {
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
    }
    
}

//MARK: - Layout configure func
extension StackItemView {
    
    private func hideText() {
        self.snp.remakeConstraints{
            $0.width.equalTo(53)
            $0.height.equalTo(53)
        }
        
    }
    private func showText() {
        let titleSize = titleLabel.sizeThatFits(CGSize())

        self.snp.remakeConstraints{
            $0.width.equalTo(53 + titleSize.width)
            $0.height.equalTo(53)
        }
    }
    
    private func layoutConfigure() {
        self.backgroundColor = .purple
        self.layer.cornerRadius = 10
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        self.snp.makeConstraints{
            $0.width.equalTo(53)
            $0.height.equalTo(53)
        }
        
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(25)
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.centerY.equalTo(imageView.snp.centerY)
        }
    }
}
