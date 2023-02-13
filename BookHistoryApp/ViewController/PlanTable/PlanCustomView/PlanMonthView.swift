//
//  PlanMonthView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/28.
//

import UIKit
import SnapKit

class PlanMonthView: UIScrollView{
    
    private lazy var lineContainer: LineContainerView = {
        let view = LineContainerView(frame: .zero)
        
        print("view bounds : \(view.bounds)")
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var dotViewArr: [DotView] = {
        let dots = DotView.getDotArray(12)
        return dots
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = CGFloat(140)
        tableView.register(PlanCell.self, forCellReuseIdentifier: PlanCell.identify)
        return tableView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    private func addAutoLayout(){

        self.addSubview(contentView)
        
        
        
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalToSuperview().priority(.low)
        }
        
        contentView.addSubview(lineContainer)
        contentView.addSubview(tableView)
        
        lineContainer.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2000).priority(.low)
            $0.width.equalTo(30)
        }
        
        tableView.snp.makeConstraints{
            $0.leading.equalTo(lineContainer.snp.trailing).offset(50)
            $0.top.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(2000).priority(.low)
        }
        
        
        dotViewArr.forEach{
            lineContainer.addSubview($0)
        }
        
        addDotViewArray(dotViewArr)
    }
    
    
    private func addDotViewArray(_ dotArr: [DotView]){
        
        dotArr.first!.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(105)
        }
        
        for current in 1..<dotArr.count - 1{
            let before = current - 1
            dotArr[current].snp.makeConstraints{
                $0.width.height.equalTo(30)
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(dotArr[before].snp.bottom).offset(110)
            }
        }
        
        dotArr.last!.snp.makeConstraints{
            let beforeFromLast = dotArr.count - 2
            $0.width.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(dotArr[beforeFromLast].snp.bottom).offset(110)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
}
