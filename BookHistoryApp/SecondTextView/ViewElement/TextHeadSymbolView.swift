//
//  TextHeadSymbolView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/21.
//

import UIKit
import SnapKit


final class TextHeadSymbolView: UIView{
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "•"    //◦•◙
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
}
