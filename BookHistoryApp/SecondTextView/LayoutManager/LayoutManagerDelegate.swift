//
//  LayoutManagerDelegate.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/05.
//

import UIKit
import SubviewAttachingTextView



class LayoutManagerDelegate: NSObject, NSLayoutManagerDelegate {
    
    weak var subviewAttachmentBehavior: SubviewAttachingTextViewBehavior?
    weak var textView: UITextView?
    
    init(_ dependency: DelegateDependency) {
        self.subviewAttachmentBehavior = dependency.attachmentBehavior
        self.textView = dependency.textView
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 10
    }
    
    
    // MARK: SubviewAttachingTextViewBehavior -> layoutAttachedSubviews()
    public func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            self.subviewAttachmentBehavior?.layoutAttachedSubviews()
        }
    }
    
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>,
                       lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
                       baselineOffset: UnsafeMutablePointer<CGFloat>,
                       in textContainer: NSTextContainer,
                       forGlyphRange glyphRange: NSRange) -> Bool {
        
        guard let textView = self.textView else { return false}
        
        
        let paragraphRange = (textView.textStorage.string as NSString).paragraphRange(for: glyphRange)
        
        
        if let commentBlockPath = textView.textStorage.attribute(.comment, at: paragraphRange.location, effectiveRange: nil) as? CommentBlockPath{
            
            guard var commentPath = commentBlockPath.commentPath else {return false}
            guard var commentFrame = commentBlockPath.rect else {return false}
            
            
            var addpath = CGRect(x: commentFrame.origin.x,
                                 y: commentFrame.origin.y,
                                 width: commentFrame.size.width,
                                 height: commentFrame.size.height )
            
            commentPath = UIBezierPath(rect: addpath)
            
            
            if (lineFragmentRect.pointee.origin.y + lineFragmentRect.pointee.size.height) > (addpath.size.height + addpath.origin.y){
                
                print("commentBlockPath.rect : \(commentBlockPath.rect)")
                textView.textContainer.exclusionPaths = textView.textContainer.exclusionPaths.map{
                    if $0 == commentPath{
                        addpath.size.height += 20
                        commentBlockPath.rect = addpath
                        commentBlockPath.commentPath = UIBezierPath(rect: addpath)
                        return commentBlockPath.commentPath!
                    }
                    return $0
                }
            }else{
                print("notComment -----")
            }
            return false
        }
        return false
        
    }
}
