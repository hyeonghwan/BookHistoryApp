//
//  DotView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import UIKit

final class DotView: UIView{
    
    override var bounds: CGRect{
        didSet{
            self.layer.cornerRadius = self.bounds.width / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
extension DotView {
    static func getDotArray(_ number: Int) -> [DotView]{
        
        var dots: [DotView] = []
        
        for _ in 0..<number {
            dots.append(DotView(frame: .zero))
        }
        return dots
    }
}
