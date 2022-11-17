//
//  KRScrollView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/16.
//

import UIKit

class KRScrollView: UIScrollView {
    // This is a reference to the scroll view's content view
    var contentView: UIView? = nil
    // This is the content offset expressed as a ratio between 0
    // and 1, from the center, not the top left corner
    var contentOffsetRatio = CGPoint(x: 0.5, y: 0.5)
    
    override var contentSize: CGSize {
        didSet{
            print("self.contentSize: \(self.contentSize)")

        }
        
    }
    
    
    
    
    // When the content offset gets set, figure out what the
    // ratio is between 0 and 1
    override var contentOffset: CGPoint {
        didSet {
            print("self.layer : \(self.layer.bounds)")
            print("self.contentOffset : \(self.contentOffset)")
            let width = self.contentSize.width
            let height = self.contentSize.height
            let halfWidth = self.frame.size.width / 2.0
            let halfHeight = self.frame.size.height / 2.0
            let centerX = ((self.contentOffset.x + halfWidth)
                           / width)
            let centerY = ((self.contentOffset.y + halfHeight)
                           / height)
            self.contentOffsetRatio = CGPoint(
                          x: centerX, y: centerY)
        }
        willSet{
            
            
            if newValue.y == .infinity{
                print(newValue)
                let ratio = self.contentOffsetRatio
                self.determineNewContentOffsetForRatio(ratio: ratio)
            }
        }
    }
    func determineNewContentOffsetForRatio(ratio: CGPoint) {
        
        
        if var frame = self.contentView?.frame {
            // Adjust the frame to be zero based since it can have a
            // negative origin
            if frame.origin.x < 0 {
                frame = CGRectOffset(frame, -frame.origin.x, 0)
            }
            if frame.origin.y < 0 {
                frame = CGRectOffset(frame, 0, -frame.origin.y)
            }
        
            // Calculate the new content offset based off the
            // contentOffsetRatio
            var offsetX: CGFloat = ((ratio.x * self.contentSize.width)
                           - (self.frame.size.width / 2.0))
            var offsetY: CGFloat = ((ratio.y * self.contentSize.height)
                           - (self.frame.size.height / 2.0))
        
            // Create a field of view rect witch represents where
            // the scroll view will positioned with this new
            // content offset
            
            var fov = CGRectMake(
                           offsetX, offsetY,
                           self.frame.size.width,
                           self.frame.size.height)
            if fov.origin.x < 0 {
                fov = CGRectOffset(fov, -fov.origin.x, 0)
            }
            if fov.origin.y < 0 {
                fov = CGRectOffset(fov, 0, -fov.origin.y)
            }
        
            // If the new content offset is going to go outside the
            // bounds of the new frame, reset
            // the x or y coordinate to its maximum value
            let intersection = CGRectIntersection(fov, frame)
            if !CGSizeEqualToSize(intersection.size, fov.size) {
                if (CGRectGetMaxX(fov) > frame.size.width) {
                    offsetX = frame.size.width -  fov.size.width
                }
                if (CGRectGetMaxY(fov) > frame.size.height) {
                    offsetY = frame.size.height -  fov.size.height
                }
            }
        
            // Preventing negative content offsets
            offsetY = offsetY > 0.0 ? offsetY : 0.0;
            offsetX = offsetX > 0.0 ? offsetX : 0.0;
            
            print("scrollView bound : \(bounds)")
            print("contentView bound : \(contentView?.bounds)")
            self.contentOffset.x = offsetX
            self.contentOffset.y = offsetY
            
            self.layer.bounds.origin.x = offsetX
            self.layer.bounds.origin.y = offsetY
        }
    }
}
