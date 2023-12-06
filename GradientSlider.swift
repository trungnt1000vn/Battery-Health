//
//  GradientSlider.swift
//  Battery Health
//
//  Created by Trung on 23/11/2023.
//

import Foundation
import UIKit

class GradientSlider: UISlider{
    @IBInspectable var thickness: CGFloat = 20 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var sliderThumbImage: UIImage? {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        let minTrackStartColor = UIColor.red
        let minTrackEndColor = UIColor.blue
        
        do {
            self.setMinimumTrackImage(try self.gradientImage(
                size: self.trackRect(forBounds: self.bounds).size,
                colorSet: [minTrackStartColor.cgColor, minTrackEndColor.cgColor]),
                                      for: .normal)
            self.setThumbImage(sliderThumbImage, for: .normal)
        } catch {
            self.minimumTrackTintColor = minTrackStartColor
        }
    }
    
    func gradientImage(size: CGSize, colorSet: [CGColor]) throws -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.cornerRadius = size.height / 2
        gradientLayer.masksToBounds = false
        gradientLayer.colors = colorSet
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage
    }
}
