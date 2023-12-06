//
//  RoundedSlider.swift
//  Battery Health
//
//  Created by Trung on 01/12/2023.
//

import UIKit

final class RoundedSlider: UISlider {
    private let trackHeight: CGFloat = 40.0
    private let trackWidth: CGFloat = 341.0
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var customBounds = super.trackRect(forBounds: bounds)
        customBounds.size.height = trackHeight
        customBounds.size.width = trackWidth
        return customBounds
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        let trackHeight = rect.size.height
        let thumbHeight = thumbRect.size.height
        let yPosition = (trackHeight - thumbHeight) / 0.5 // Chia cho 3 thay vì 2
        
        thumbRect.origin.y = yPosition
        
        return thumbRect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let thumbView = subviews.first(where: { $0 is UIImageView }) {
            thumbView.tintColor = UIColor.clear
        }
    }
}
