//
//  UIUtil.swift
//  MediaPicker
//
//  Created by Ray Chen on 2021/2/22.
//
import Foundation
import UIKit

class UIUtil {
    
    static func setBackground(delegate: AnyObject) {
        let background = UIImage(named: "bg")

        var imageView : UIImageView!
        imageView = UIImageView(frame: delegate.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = delegate.view.center
        delegate.view.addSubview(imageView)
        delegate.view.sendSubviewToBack(imageView)
    }
    
    static func UIColorRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func UIColorRGB(r: UInt, g: UInt, b: UInt) -> UIColor {
           return UIColor(
               red: CGFloat(r) / 255.0,
               green: CGFloat(g) / 255.0,
               blue: CGFloat(b) / 255.0,
               alpha: CGFloat(1.0)
           )
       }

    static func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)

        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    
    static func popAlert(delegate: AnyObject, title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
        delegate.present(alertView, animated: true, completion: nil)
    }

}

extension UIImage {
    func toCircle() -> UIImage {
        let shotest = min(self.size.width, self.size.height)
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: outputRect)
        context.clip()
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
