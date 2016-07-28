//
// Created by Roman Churkin on 16/06/15.
// Copyright (c) 2015 RedMadRobot. All rights reserved.
//

import UIKit


public extension UIImage {

    class func imageNamed(named: String, tintColor: UIColor) -> UIImage?
    {
        let image = UIImage(named: named)
        return image?.imageTintedWithColor(tintColor)
    }

    func imageTintedWithColor(color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
        
        color.set()
        
        let rect = CGRect(origin: CGPointZero, size: self.size)
        UIRectFillUsingBlendMode(rect, CGBlendMode.Screen)
        drawInRect(rect, blendMode: CGBlendMode.DestinationIn, alpha: 1.0)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();

        return image
    }
}
