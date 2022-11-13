//
//  CustomLayoutManager.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/09.
//

import Foundation
import UIKit


class LayoutManager: NSLayoutManager {

    var lineHeightMultiple: CGFloat = 1.6
    override init() {
        print("setExterLiansdf")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var font: UIFont {
        return UIFont.boldSystemFont(ofSize: 16)
    }

    private var lineHeight: CGFloat {
        let fontLineHeight = self.font.lineHeight
        let lineHeight = fontLineHeight * lineHeightMultiple
        return lineHeight
    }

    // Takes care only of the last empty newline in the text backing
    // store, or totally empty text views.
    override func setExtraLineFragmentRect(_ fragmentRect: CGRect, usedRect: CGRect, textContainer container: NSTextContainer) {
        print("setExterLiansdf")
        // This is only called when editing, and re-computing the
        // `lineHeight` isn't that expensive, so I do no caching.
        let lineHeight = self.lineHeight
        var fragmentRect = fragmentRect
        fragmentRect.size.height = lineHeight
        var usedRect = usedRect
        usedRect.size.height = lineHeight
        print("setExterLiansdf")
        super.setExtraLineFragmentRect(fragmentRect,
            usedRect: usedRect,
            textContainer: container)
    }
    
}
