//
//  ViewController.swift
//  Battery Health
//
//  Created by Trung on 18/10/2023.
//

import UIKit
import AVFoundation
import QuartzCore
import CoreHaptics


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
    
    
    @IBOutlet weak var setalarmButton: UIImageView!
    
    @IBOutlet weak var bellButton: UIImageView!
    
    
    @IBOutlet weak var melodyButton: UIImageView!
    
    
    @IBOutlet weak var sirenButton: UIImageView!
    
    
    @IBOutlet weak var notiBG: UIImageView!
    
    
    @IBOutlet weak var vibrateBG: UIImageView!
    
    
    @IBOutlet weak var switchNoti: UISwitch!
    
    
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    
    @IBOutlet weak var analyticBG: UIImageView!
    
    
    
    
    var audioPlayer: AVAudioPlayer?
    var audioPlayerVolume: Float = 0.0
    
    var isVibrate: Bool = false
    
    public var alarmPercentage: Int = 80
    
    let batteryProgressView = BatteryProgressView()
    
    
    var timer: Timer?
    
    var mp3play: String = "Bell"
    var customSlider = CustomSlider()

    var imgViewSlider = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let batteryLevel = device.batteryLevel
        
        setUpLayoutView()
        setUpGestureforimgs()
        scrollView.addSubview(batteryProgressView)
        batteryProgressView.setupProgress(1 - CGFloat(batteryLevel))
        updateBatteryPercentage()
        updateBatteryState()
        audioPlayerVolume = 0.5
        vibrateDevice()
        scrollView.addSubview(customSlider)
        scrollView.addSubview(imgViewSlider)
        customSlider.addTarget(self, action: #selector(volumeSliderValueChanged(_ :)), for: .valueChanged)
//        volumeSlider.addTarget(self, action: #selector(volumeSliderValueChanged(_:)), for: .valueChanged)
        vibrateSwitch.addTarget(self, action: #selector(vibrationSwitchChange(_ :)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            setalarmButton.isHidden = true
        case .charging:
            chargestateBG.image = UIImage(named: "Battery State - Charging")
            setalarmButton.isHidden = false
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
        print(batteryLevel)
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
    @objc func volumeSliderValueChanged(_ sender: UISlider) {
        audioPlayerVolume = sender.value
    }
    func playBellSound(ringtone: String) {
        guard let url = Bundle.main.url(forResource: ringtone, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = audioPlayerVolume
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
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
        notiBG.clipsToBounds = true
        notiBG.layer.cornerRadius = 32
        vibrateBG.clipsToBounds = true
        vibrateBG.layer.cornerRadius = 32
        analyticBG.clipsToBounds = true
        analyticBG.layer.cornerRadius = 32
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
        batteryProgressView.translatesAutoresizingMaskIntoConstraints = false
        batteryProgressView.backgroundColor = UIColor.clear
        batteryProgressView.frame.origin = CGPoint(x: 43, y: 197)
        customSlider.frame.origin = CGPoint(x: 34, y: 1060)
        customSlider.frame.size = CGSize(width: 383, height: 100)
        imgViewSlider.frame.size = CGSize(width: 24, height: 24)
        imgViewSlider.frame.origin = CGPoint(x: 43, y: 1096)
        imgViewSlider.image = UIImage(named: "speakerslider")
        imgViewSlider.contentMode = .scaleAspectFit
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
        let tapGestureAlarm = UITapGestureRecognizer(target: self, action: #selector(didTapSetAlarm))
        setalarmButton.addGestureRecognizer(tapGestureAlarm)
        setalarmButton.isUserInteractionEnabled = true
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
        if (isVibrate){
//            playBellSound(ringtone: "Bell")
//            mp3play = "Bell"
            vibrateDevice()
        }
        else {
            playBellSound(ringtone: "Bell")
            mp3play = "Bell"
        }
    }
    @objc func didTapMelody(){
        bellButton.image = UIImage(named: "bellButton")
        melodyButton.image = UIImage(named: "melodyButtonPicked")
        sirenButton.image = UIImage(named: "sirenButton")
        if (isVibrate){
//            playBellSound(ringtone: "Melody")
//            mp3play = "Melody"
            vibrateDevice()
        }
        else {
            playBellSound(ringtone: "Melody")
            mp3play = "Melody"
        }
    }
    @objc func didTapSiren(){
        bellButton.image = UIImage(named: "bellButton")
        melodyButton.image = UIImage(named: "melodyButton")
        sirenButton.image = UIImage(named: "sirenButtonPicked")
        if (isVibrate){
//            playBellSound(ringtone: "Siren")
//            mp3play = "Siren"
            vibrateDevice()

        }
        else {
            playBellSound(ringtone: "Siren")
            mp3play = "Siren"
        }
    }
    @objc func didTapSetAlarm(){
        setalarmButton.isHidden = true
        
        // Kiểm tra giá trị của alarmPercentage và mp3play
        print("alarmPercentage: \(alarmPercentage), mp3play: \(mp3play )")
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkBatteryLevelForAlarm), userInfo: nil, repeats: true)
        }
    }
    @objc func checkBatteryLevelForAlarm() {
        let currentBatteryLevel = Int(UIDevice.current.batteryLevel * 100)
        
        if currentBatteryLevel == alarmPercentage {
            print("Playing bell sound...")
            playBellSound(ringtone: mp3play )
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func vibrationSwitchChange(_ sender: UISwitch){
        if sender.isOn {
            isVibrate = true
            print(isVibrate)
        }
        else {
            isVibrate = false
            print(isVibrate)
        }
    }
    func vibrateDevice(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
        
            let engine = try CHHapticEngine()
            try engine.start()
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 10.0)
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            
            let player = try engine.makePlayer(with: pattern)
            
            try player.start(atTime: 0)
            
        } catch {
            print("Không thể tạo hoặc chơi rung lâu: \(error)")
        }
    }
    
    
    
}
