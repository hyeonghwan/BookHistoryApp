//
//  PlanCell.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PlanCell: UITableViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var onData: AnyObserver<PlanDataModel>?
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAutoLayout()
        settupBinding()
        self.contentView.backgroundColor = .systemCyan
    }
    
    private func settupBinding(){
        let dataPipe = PublishSubject<PlanDataModel>()
        
        onData = dataPipe.asObserver()
        
        dataPipe
            .asDriver(onErrorJustReturn: PlanDataModel())
            .drive(onNext: {
                self.label.text = $0.title
            })
            .disposed(by: disposeBag)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))

    }
    
    
    private func addAutoLayout(){
        
        self.contentView.addSubview(label)
        
        label.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error")
    }
}
