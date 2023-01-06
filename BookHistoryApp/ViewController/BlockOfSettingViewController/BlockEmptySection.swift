//
//  BlockEmptySection.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/02.
//

import UIKit
import SnapKit

final class BlockEmptySectionView: UITableViewHeaderFooterView{
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(emptyView)
        emptyView.backgroundColor = .systemPink
        emptyView.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error occur")
    }
    
    
}
