//
//  BlockOfAttachmentSettingVC.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/31.
//

import UIKit

final class BlockOfSettingVC: UIViewController{
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "작업"
        label.textColor = .label
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneButton(_:)), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.estimatedRowHeight = 30
        table.dataSource = self
        table.delegate = self
        table.isScrollEnabled = false
        table.sectionHeaderHeight = 20
        table.register(BlockLogCell.self, forCellReuseIdentifier: BlockLogCell.identify)
        table.register(BlockTaskCell.self, forCellReuseIdentifier: BlockTaskCell.identify)
        return table
    }()
    
    //
    
    
    let firstSection: [String] = ["trash" , "square.on.square" , "arrow.down", "link"]
    let secondSection = ["arrow.turn.up.right"]
    let thirdSection = ["text.bubble" , "captions.bubble" ]
    let forthSection = ["paintpalette"]
    
    let firstTitle: [String] = ["삭제", "복제", "아래로삽입", "블록 링크 복사"]
    let secondTitle = [ "옮기기"]
    let thirdTitle = [ "댓글", "캡션"]
    let forthTitle = [ "색"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.tableView.backgroundColor = .tertiarySystemGroupedBackground
        
        addAutoLayout()
    }
    
    func addAutoLayout(){
        self.view.addSubview(titleLable)
        self.view.addSubview(doneButton)
        self.view.addSubview(tableView)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 16),
         titleLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)].forEach{
            $0.isActive = true
        }
        
        [doneButton.widthAnchor.constraint(equalToConstant: 33),
         doneButton.heightAnchor.constraint(equalToConstant: 33),
         doneButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
         doneButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 8)].forEach{
            $0.isActive = true
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        [tableView.topAnchor.constraint(equalTo: titleLable.bottomAnchor,constant: 16),
         tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)].forEach{
            $0.isActive = true
        }
    }
    
    @objc func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}

extension BlockOfSettingVC: UITableViewDelegate{
    
    
}
extension BlockOfSettingVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockTaskCell.identify, for: indexPath) as? BlockTaskCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets()
        cell.selectionStyle = .none

        switch indexPath.section{
        case 0:
            cell.settingComponent(firstSection[indexPath.row], firstTitle[indexPath.row])
            return cell
        case 1:
            cell.settingComponent(secondSection[indexPath.row], secondTitle[indexPath.row])
            return cell
        case 2:
            cell.settingComponent(thirdSection[indexPath.row], thirdTitle[indexPath.row])
            return cell
        case 3:
            cell.settingComponent(forthSection[indexPath.row], forthTitle[indexPath.row])
            return cell
        case 4:
            let logCell = BlockLogCell(style: .default, reuseIdentifier: BlockLogCell.identify)
            logCell.settingLog("형환 님이 편집함", "2023 - 01 - 01 ")
            return logCell
        default:
            return cell
        }
        
    }
}
