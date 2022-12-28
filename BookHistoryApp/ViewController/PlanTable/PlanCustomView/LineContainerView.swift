//
//  LineContainerView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import UIKit


final class LineContainerView: UIView{
    

    
    override var bounds: CGRect{
        didSet{
            print("boundsSet : \(bounds)")
            self.makeDashedBorderLine(color: .gray, strokeLength: NSNumber(value: 100), gapLength: NSNumber(value: 40), width: 2, orientation: .vertical)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
      
        
    }
    
}

extension UIView{

    enum dashedOrientation {
        case horizontal
        case vertical
    }
    
    func makeDashedBorderLine(color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat, orientation: dashedOrientation) {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        if orientation == .vertical {
            path.addLines(between: [CGPoint(x: self.bounds.midX, y: self.bounds.minY),
                                    CGPoint(x: self.bounds.midX, y: self.bounds.maxY)])
        } else if orientation == .horizontal {
            path.addLines(between: [CGPoint(x: self.bounds.minX, y: self.bounds.midY),
                                    CGPoint(x: self.bounds.maxX, y: self.bounds.midY)])
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

}
