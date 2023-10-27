//
//  ViewController.swift
//  Battery Health
//
//  Created by Trung on 18/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView80: UIImageView!
    
    @IBOutlet weak var picked80: UIImageView!
    
    @IBOutlet weak var imageview90: UIImageView!
    
    @IBOutlet weak var picked90: UIImageView!
    
    @IBOutlet weak var imageView100: UIImageView!
    
    @IBOutlet weak var picked100: UIImageView!
    
    @IBOutlet weak var imageBG: UIImageView!
    
    @IBOutlet weak var chargestateBG: UIImageView!
    
    
    @IBOutlet weak var pickingBG: UIImageView!
    
    
    @IBOutlet weak var settingButton: UIImageView!
    
    
    @IBOutlet weak var batteryStatusLabel: UILabel!
    
    
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
    
    @IBOutlet weak var alarmSetUpBG: UIImageView!
    
    
    
    @IBOutlet weak var bellButton: UIImageView!
    
    
    @IBOutlet weak var melodyButton: UIImageView!
    
    
    @IBOutlet weak var sirenButton: UIImageView!
    
    
    
    
    public var alarmPercentage: Int = 80
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayoutView()
        
        setUpGestureforimgs()
        
        
        updateBatteryPercentage()
        updateBatteryState()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
    @objc func batteryLevelDidChange() {
        updateBatteryPercentage()
    }
    @objc func batteryStateDidChange() {
        updateBatteryState()
    }
    func updateBatteryState() {
        let batteryState = UIDevice.current.batteryState
        switch batteryState {
        case .unknown:
            print("Trạng thái sạc không xác định")
        case .unplugged:
            chargestateBG.image = UIImage(named: "Charging State-Unplugged")
        case .charging:
            chargestateBG.image = UIImage(named: "Battery State - Charging")
        case .full:
            print("Sạc đầy")
        @unknown default:
            print("Trạng thái sạc không xác định")
        }
    }
    func updateBatteryPercentage() {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        let batteryLevel = device.batteryLevel
        
        if batteryLevel >= 0 {
            let batteryPercentage = Int(batteryLevel * 100)
            
            batteryLevelLabel.text = "\(batteryPercentage)%"
            
            if batteryPercentage >= 80 && batteryPercentage <= 100 {
                batteryStatusLabel.text = "High"
            } else if batteryPercentage > 20 && batteryPercentage < 80 {
                batteryStatusLabel.text = "Middle"
            } else if batteryPercentage <= 20 {
                batteryStatusLabel.text = "Low"
            }
        } else {
            batteryLevelLabel.text = "N/A"
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    func setUpLayoutView() {
        imageBG.layer.borderWidth = 0.1
        imageBG.layer.cornerRadius = 32
        alarmSetUpBG.layer.borderWidth = 0.1
        alarmSetUpBG.layer.cornerRadius = 32
        chargestateBG.layer.borderWidth = 0.1
        chargestateBG.layer.cornerRadius = 10
        pickingBG.clipsToBounds = true
        pickingBG.layer.cornerRadius = 32
        picked80.layer.cornerRadius = 32
        picked80.layer.maskedCorners = [.layerMinXMaxYCorner]
        picked80.clipsToBounds = true
        imageView80.layer.cornerRadius = 32
        imageView80.layer.maskedCorners = [.layerMinXMaxYCorner]
        imageView80.layer.borderColor = CGColor(red: 27, green: 30, blue: 31, alpha: 1)
        imageView80.clipsToBounds = true
        picked100.layer.cornerRadius = 32
        picked100.layer.maskedCorners = [.layerMaxXMaxYCorner]
        picked100.clipsToBounds = true
        imageView100.layer.cornerRadius = 32
        imageView100.layer.maskedCorners = [.layerMaxXMaxYCorner]
        imageView100.layer.borderColor = CGColor(red: 27, green: 30, blue: 31, alpha: 1)
        imageView100.clipsToBounds = true
        
    }
    func setUpGestureforimgs(){
        let tapGesture80 = UITapGestureRecognizer(target: self, action: #selector(didTap80))
        imageView80.addGestureRecognizer(tapGesture80)
        imageView80.isUserInteractionEnabled = true
        let tapGesture90 = UITapGestureRecognizer(target: self, action: #selector(didTap90))
        imageview90.addGestureRecognizer(tapGesture90)
        imageview90.isUserInteractionEnabled = true
        let tapGesture100 = UITapGestureRecognizer(target: self, action: #selector(didTap100))
        imageView100.addGestureRecognizer(tapGesture100)
        imageView100.isUserInteractionEnabled = true
        let tapGestureBell = UITapGestureRecognizer(target: self, action: #selector(didTapBell))
        bellButton.addGestureRecognizer(tapGestureBell)
        bellButton.isUserInteractionEnabled = true
        let tapGestureMelody = UITapGestureRecognizer(target: self, action: #selector(didTapMelody))
        melodyButton.addGestureRecognizer(tapGestureMelody)
        melodyButton.isUserInteractionEnabled = true
        let tapGestureSiren = UITapGestureRecognizer(target: self, action: #selector(didTapSiren))
        sirenButton.addGestureRecognizer(tapGestureSiren)
        sirenButton.isUserInteractionEnabled = true
    }
}
extension ViewController{
    @objc func didTap80(){
        imageView80.image = UIImage(named: "80picked")
        imageview90.image = UIImage(named: "90")
        imageView100.image = UIImage(named: "100")
        picked80.isHidden = false
        picked90.isHidden = true
        picked100.isHidden = true
        alarmPercentage = 80
        print(alarmPercentage)
    }
    @objc func didTap90(){
        imageView80.image = UIImage(named: "80")
        imageview90.image = UIImage(named: "90picked")
        imageView100.image = UIImage(named: "100")
        picked80.isHidden = true
        picked90.isHidden = false
        picked100.isHidden = true
        alarmPercentage = 90
        print(alarmPercentage)
    }
    @objc func didTap100(){
        imageView80.image = UIImage(named: "80")
        imageview90.image = UIImage(named: "90")
        imageView100.image = UIImage(named: "100picked")
        picked80.isHidden = true
        picked90.isHidden = true
        picked100.isHidden = false
        alarmPercentage = 100
        print(alarmPercentage)
    }
    @objc func didTapBell(){
        bellButton.image = UIImage(named: "bellButtonPicked")
        melodyButton.image = UIImage(named: "melodyButton")
        sirenButton.image = UIImage(named: "sirenButton")
    }
    @objc func didTapMelody(){
        bellButton.image = UIImage(named: "bellButton")
        melodyButton.image = UIImage(named: "melodyButtonPicked")
        sirenButton.image = UIImage(named: "sirenButton")
    }
    @objc func didTapSiren(){
        bellButton.image = UIImage(named: "bellButton")
        melodyButton.image = UIImage(named: "melodyButton")
        sirenButton.image = UIImage(named: "sirenButtonPicked")
    }
}

