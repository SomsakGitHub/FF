//
//  Button.swift
//  Marauders
//
//  Created by somsak on 22/1/2564 BE.
//

import Foundation
import UIKit

@IBDesignable class  ButtonIBDesignable: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.init (red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.init (red: 0, green: 122/255, blue: 255/255, alpha: 1) {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 20, height: 30) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var isCircular:Bool = false {
        didSet {
            if isCircular {
                layer.cornerRadius = layer.frame.size.width/2
            }
        }
    }
    
    @IBInspectable public var verticalGradient: Bool = true {
        didSet {
            updateUI()
        }
    }

    /// Start color of the gradient
    @IBInspectable public var startColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }

    /// End color of the gradient
    @IBInspectable public var endColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }

    private var gradientlayer = CAGradientLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }

    private func setupUI() {
        gradientlayer = CAGradientLayer()
        updateUI()
        layer.addSublayer(gradientlayer)
    }

    private func updateFrame() {
        gradientlayer.frame = bounds
    }

    private func updateUI() {
        gradientlayer.colors = [startColor.cgColor, endColor.cgColor]
        if verticalGradient {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientlayer.startPoint = CGPoint(x: 0, y: 0)
            gradientlayer.endPoint = CGPoint(x: 1, y: 0)
        }
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        if cornerRadius > 0 {
            layer.masksToBounds = true
        }
        updateFrame()
    }
}
