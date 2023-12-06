//
//  CustomSlider.swift
//  Battery Health
//
//  Created by Trung on 30/11/2023.
//

import UIKit

final class CustomSlider: UISlider {
    private let baseLayer = CALayer() // Step 3
    private let trackLayer = CAGradientLayer() // Step 7
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup() {
        clear()
        createBaseLayer() // Step 3
        createThumbImageView() // Step 5
        configureTrackLayer() // Step 7
        addUserInteractions() // Step 8
    }
    
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear 
    }
    
    // Step 3
    private func createBaseLayer() {

        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = CGColor(red: 33, green: 39, blue: 40, alpha: 0.1)
        baseLayer.frame = .init(x: 0, y: frame.height / 4, width: 345, height: frame.height / 2)
        baseLayer.cornerRadius = baseLayer.frame.height / 5
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    // Step 7
    private func configureTrackLayer() {

        let firstColor = UIColor(red: 243/255, green: 203/255, blue: 180/255, alpha: 1).cgColor
        let secondColor = UIColor(red: 255/255, green: 252/255, blue: 182/255, alpha: 1).cgColor
        let thirdColor = UIColor(red: 159/255, green: 239/255, blue: 146/255, alpha: 1).cgColor
        trackLayer.colors = [firstColor, secondColor, thirdColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: 32, height: frame.height / 2)
        trackLayer.cornerRadius = trackLayer.frame.height / 5
        layer.insertSublayer(trackLayer, at: 1)
    }
    
    // Step 8
    private func addUserInteractions() {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func valueChanged(_ sender: UISlider) {
        // Step 10
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // Step 9
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: thumbRectA.midX, height: frame.height / 2)
        // Step 10
        CATransaction.commit()
    }
    
    // Step 5
    private func createThumbImageView() {
        let thumbSize = (3 * frame.height) / 4
        let thumbView = ThumbView(frame: .init(x: 0, y: 0, width: thumbSize, height: thumbSize))
        thumbView.backgroundColor = .clear
        //thumbView.layer.cornerRadius = thumbSize / 1
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        // Step 6
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
}

// Step 4
final class ThumbView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 183 / 255, green: 122 / 255, blue: 231 / 255, alpha: 0)
        let middleView = UIView(frame: .init(x: frame.midX - 6, y: frame.midY - 6, width: 12, height: 12))
        middleView.backgroundColor = .clear
        middleView.layer.cornerRadius = 6
        addSubview(middleView)
    }
}

// Step 4
extension UIView {
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
