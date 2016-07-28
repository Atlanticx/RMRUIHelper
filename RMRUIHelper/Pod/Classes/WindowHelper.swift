//
//  WindowHelper.swift
//
//  Created by Roman Churkin on 04/08/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

import UIKit


public extension UIWindow {
    
    class func keyWindowTransitToViewController(viewController: UIViewController)
    {
        UIApplication.sharedApplication().keyWindow?.transitToViewController(viewController)
    }
    
    func transitToViewController(viewController: UIViewController)
    {
        let currentSubviews = subviews
        insertSubview(viewController.view, belowSubview: rootViewController!.view)
        
        UIView.transitionWithView(self,
            duration: 0.4,
            options: [.CurveEaseInOut, .TransitionCrossDissolve],
            animations: { self.rootViewController = viewController },
            completion: { finished in
                // MARK: Обнаружилась проблема при переходе к ViewController с модальным отображением другого ViewController — последние не удаляются из window. Пришлось написать подпорку для очистки subviews.
                // TODO: Проверить профайлером на утечки ViewController
                currentSubviews.forEach({ $0.removeFromSuperview() })
        })
    }
    
}
