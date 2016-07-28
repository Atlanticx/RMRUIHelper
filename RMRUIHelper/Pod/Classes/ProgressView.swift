//
//  ProgressView.swift
//  RMRUIHelper
//
//  Created by Roman Churkin on 11/01/16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import UIKit


@IBDesignable
public class ProgressView: UIView {
    
    // MARK: - Свойства
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    public var progressBackgroundColor: UIColor? {
        get {
            if let color = backgroundLayer.strokeColor {
                return UIColor(CGColor: color)
            } else {
                return nil
            }
        }
        set {
            backgroundLayer.strokeColor = newValue?.CGColor
        }
    }
    
    public var progress: Double {
        get {
            return Double(progressLayer.strokeEnd)
        }
        set {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    
    // MARK: - Жизненный цикл View
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        configure()
    }
    
    override public func tintColorDidChange()
    {
        progressLayer.strokeColor = tintColor.CGColor
    }
    
    override public func layoutSubviews()
    {
        let bounds = self.bounds
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        
        let maxX = CGRectGetMaxX(bounds)
        let midY = CGRectGetMidY(bounds)
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(midY, midY))
        bezierPath.addLineToPoint(CGPointMake(maxX-midY, midY))
        
        let path = bezierPath.CGPath
        backgroundLayer.path = path
        progressLayer.path = path
        
        let lineWidth = CGRectGetHeight(bounds)
        backgroundLayer.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
    }
    
    override public func prepareForInterfaceBuilder()
    {
        progress = 0.25
    }
    
    
    // MARK: - Приватные функции
    
    private func configure()
    {
        clipsToBounds = true
        
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.strokeColor = UIColor.groupTableViewBackgroundColor().CGColor
        
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = tintColor.CGColor
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        
        configureAppearance()
    }
    
    
    // MARK: - Публичные функции
    
    /// Наследники могут переопределить этот метод для стилизации компонента
    public func configureAppearance()
    {
        // do nothing
    }
    
}
