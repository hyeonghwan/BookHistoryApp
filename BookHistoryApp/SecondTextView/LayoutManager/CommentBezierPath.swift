//
//  CommentBezierPath.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/04.
//

import UIKit


class CommentBlockPath{
    
    var commentPath: UIBezierPath?
    
    var rect: CGRect?
    
    init(_ rect: CGRect) {
        self.rect = rect
        self.commentPath = UIBezierPath(rect: rect)
    }
    
}
