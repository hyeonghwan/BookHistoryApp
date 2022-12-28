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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var onData: AnyObserver<PlanDataModel>?
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAutoLayout()
        settupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error")
    }
    
    private func settupBinding(){
        let dataPipe = PublishSubject<PlanDataModel>()
        
        onData = dataPipe.asObserver()
        
        dataPipe
            .asDriver(onErrorJustReturn: PlanDataModel())
            .drive(onNext: {
                self.titleLabel.text = $0.title
                self.contentLabel.text = $0.content
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))

    }
    
    
    private func addAutoLayout(){
        self.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
        contentView.addSubview(contentLabel)
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 8
        
        titleLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
        }
        separatorLine.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(separatorLine.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
        }
        
    }
}
