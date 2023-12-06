//
//  BatteryProgressView.swift
//  Battery Health
//
//  Created by Trung on 03/11/2023.
//

import UIKit

class BatteryProgressView: UIView{
    private let firstLayer = CAShapeLayer()
    private let secondLayer = CAShapeLayer()
    
    private let percentLabel = UILabel()
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let twopi: CGFloat = .pi*2
    private var offset: CGFloat = 0.0
    
    var showSingleWave = false
    
    private var start = false
    
    
    var progress: CGFloat = 0.3
    var waveHeight: CGFloat = 0.0
    

    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension BatteryProgressView {
    private func setupViews() {
        bounds = CGRect(x: 0.0, y: 0.0, width: 180, height: 180)
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 90
        
        waveHeight = 8.0
        
        firstColor = .green
        secondColor = .green.withAlphaComponent(0.4)
        
        
        createFirstLayer()
        
        
        if !showSingleWave{
            createSecondLayer()
        }
    }
    private func createFirstLayer(){
        firstLayer.frame = bounds
        firstLayer.anchorPoint = .zero
        firstLayer.fillColor = firstColor.cgColor
        layer.addSublayer(firstLayer)
    }
    private func createSecondLayer(){
        secondLayer.frame = bounds
        secondLayer.anchorPoint = .zero
        secondLayer.fillColor = secondColor.cgColor
        layer.addSublayer(secondLayer)
    }
    func setupProgress(_ pr: CGFloat){
        progress = pr

        let top: CGFloat = bounds.size.height - (pr * bounds.size.height)
        firstLayer.setValue(180-top, forKeyPath: "position.y")
        secondLayer.setValue(180-top, forKeyPath: "position.y")
        
        if !start {
            DispatchQueue.main.async{
                self.startAnim()
            }
        }
        
    }
    private func startAnim(){
        start = true
        waterWaveAnim()
    }
    
    private func waterWaveAnim(){
        let w = bounds.size.width
        let h = bounds.size.height
        
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        
        let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * twopi / w)))
        var originOffsetY: CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0.0, y: startOffsetY), transform: .identity)
        bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1){
            originOffsetY = waveHeight * CGFloat(sinf(Float(twopi / w * i + offset * twopi / w)))
            bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
        }
        bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
        bezier.addLine(to: CGPoint(x: w*1000, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
        bezier.close()
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w*0.5
        anim.toValue = -w - w*0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        
        firstLayer.fillColor = firstColor.cgColor
        firstLayer.path = bezier.cgPath
        firstLayer.add(anim, forKey: nil)
        
        if !showSingleWave {
            let bezier = UIBezierPath()
            
            let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * twopi / w)))
            var originOffsetY: CGFloat = 0.0
            
            bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
            
            for i in stride(from: 0.0, to: w*1000, by: 1){
                originOffsetY = waveHeight * CGFloat(cosf(Float(twopi / w * i + offset * twopi / w)))
                bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
            }
            
            bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
            bezier.addLine(to: CGPoint(x: w*1000, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
            bezier.close()
            
            secondLayer.fillColor = secondColor.cgColor
            secondLayer.path = bezier.cgPath
            secondLayer.add(anim, forKey: nil)
        }
        
    }
}
