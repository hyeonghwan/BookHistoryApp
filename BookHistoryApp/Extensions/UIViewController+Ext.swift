//
//  UIViewController+Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/02.
//

import UIKit
extension UIViewController {
    func setLeftAlignTitleView(font: UIFont, text: String, textColor: UIColor) {
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 22))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        label.font = font
        label.text = text
        
        let leftButtonWidth: CGFloat = 35 // left padding
        let rightButtonWidth: CGFloat = 75 // right padding
        let width = view.frame.width - leftButtonWidth - rightButtonWidth
        let offset = (rightButtonWidth - leftButtonWidth) / 2
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -offset),
            label.widthAnchor.constraint(equalToConstant: width)
        ])
        
        self.navigationItem.titleView = container
        
        
    }
}
