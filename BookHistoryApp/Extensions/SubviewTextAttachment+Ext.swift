//
//  SubviewTextAttachment+Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/31.
//

import UIKit
import SubviewAttachingTextView
import SnapKit


enum SubViewAttachmentContiner {
    case defaultContainer
    
    fileprivate static func buttonConfiguration(_ button: UIButton,
                                                _ target: NSAttachmentSettingProtocol,
                                                _ containerView: UIView) {
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(target, action: #selector(target.blockSubViewAttachmentHandler(_:)), for: .touchUpInside)
        button.tintColor = .systemPink
        containerView.addSubview(button)
    }
    
    fileprivate static func addAutoLayout(_ button: UIButton, _ containerView: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        [ button.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 12),
          button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -12),
          button.widthAnchor.constraint(equalToConstant: 33),
          button.heightAnchor.constraint(equalToConstant: 33)].forEach{
            $0.isActive = true
        }
    }
    
    fileprivate static func cotentViewAddAutolayout(_ view: UIView, _ containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        [view.topAnchor.constraint(equalTo: containerView.topAnchor),
         view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)].forEach{
            $0.isActive = true
        }
    }
    
    static func settingContainer(_ target: NSAttachmentSettingProtocol,_ contentView: UIView, size: CGSize?) -> SubviewTextAttachment{
        
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1
            return view
        }()
        
        containerView.addSubview(contentView)
        cotentViewAddAutolayout(contentView, containerView)
        
        let button = UIButton()
        buttonConfiguration(button, target, contentView)
        addAutoLayout(button, contentView)
        
        
        if let size = size{
            return SubviewTextAttachment(view: containerView, size: size)
        }else {
            return SubviewTextAttachment(view: containerView)
        }
    }
}
