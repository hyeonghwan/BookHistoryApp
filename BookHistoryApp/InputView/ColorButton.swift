//
//  ColorButton.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/19.
//

import UIKit


class ColorButton: UIButton {

    
    lazy var colorContextView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy var contextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private var contextColor: Color?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }
    
    func configureSubViews(_ viewColor: UIColor,_ labelColor: Color) {
       
        self.addSubview(colorContextView)
        self.addSubview(contextLabel)
        
        
        colorContextView.frame = CGRect(x: 8, y: 20, width: 25, height: 25)
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.textColor = .white
        label.text = "가"
        label.sizeToFit()
        colorContextView.addSubview(label)
        
        label.center = CGPointMake(colorContextView.frame.size.width / 2 , colorContextView.frame.size.height / 2)
        
        colorContextView.backgroundColor = viewColor
        
        
        contextLabel.text = labelColor.rawValue
        
        contextLabel.sizeToFit()
        
        contextLabel.frame = CGRect(x: colorContextView.frame.origin.x + colorContextView.frame.width + 10,
                                    y: colorContextView.frame.origin.y,
                                    width: contextLabel.bounds.width, height: contextLabel.bounds.height)
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    
}
