//
//  ViewController.swift
//  SWHFireFlySyncronisation
//
//  Created by Simon J Whitehouse on 27/09/2015.
//  Copyright © 2015 co.swhitehouse. All rights reserved.
//

import UIKit

class SWHFireFlyViewController: UIViewController {
    
    /// array that holds the flys
    var flies = Array<Array<SWHFlyView>>()
    
    /// ellpased timer
    var ellapsedTimer: Timer?
    
    /// time as double - sets the time label text
    var ellapsedTime: Double = 0.0 {
        didSet  {
            timeLabel.text = "\(Int(ellapsedTime * 100) / 100)"
        }
    }
    
    /// switch that determines whether or not to show fly count labels
    @IBOutlet weak var showFlyCounterLabelSwitch: UISwitch!
    
    /// label to show ellpased time
    @IBOutlet weak var timeLabel: UILabel!
    
    /// number of flys per row
    static let NumberOfFlysPerRow = 10
    
    /// sentive period
    static let SensitivePeriod = 7.0
    
    /// size of each fly
    static let FlyHeight = ((300) - CGFloat((SWHFireFlyViewController.NumberOfFlysPerRow - 1) * 5)) / CGFloat(SWHFireFlyViewController.NumberOfFlysPerRow)
    
    /// holds the fly array
    @IBOutlet weak var flyContainer: UIView! {
        didSet {
            flyContainer.layer.borderColor = UIColor.white.cgColor
            flyContainer.layer.borderWidth = 2
        }
    }
    
    /// view did load - sets up the fly array and starts
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buildFlies()
    }
    
    /// creates a two dimensional array of flys and triggers the timers
    func buildFlies() {
        var startOriginX: CGFloat = 0.0
        var startOriginY: CGFloat = 0.0
        
        let flyHeight = SWHFireFlyViewController.FlyHeight
        
        for y in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
            flies.append([SWHFlyView]())
            for x in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
                let newFly = SWHFlyView(frame: CGRect(x: startOriginX, y: startOriginY, width: flyHeight, height: flyHeight))
                flyContainer.addSubview(newFly)
                newFly.configure()
                startOriginX += flyHeight + 5
                newFly.delegate = self
                flies[y].append(newFly)
            }
            
            startOriginX = 0
            startOriginY += flyHeight + 5
            
        }
        
        ellapsedTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerTicked(timer:)), userInfo: nil, repeats: true)
    }
    
    /// increased the ellapsed time
    @objc
    func timerTicked(timer: Timer) {
        ellapsedTime += 0.1
    }
    
    /// resets the fly array and timers
    @IBAction func resetButton(sender: UIButton) {
        for y in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
            for x in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
                let fly = flies[y][x]
                fly.resetTimer()
            }
        }
        
        flies = Array<Array<SWHFlyView>>()
        ellapsedTime = 0.0
        buildFlies()
    }
    
    /// turns on/off the fly counters
    @IBAction func showFlyCounterLabelSwitchValueChanged(sender: AnyObject) {
        showFlyCounterLabelSwitch.setOn(showFlyCounterLabelSwitch.isOn, animated: true)
        for y in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
            for x in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
                let fly = flies[y][x]
                fly.label?.isHidden = !showFlyCounterLabelSwitch.isOn
            }
        }
    }
}

extension SWHFireFlyViewController: SWHFlyViewDelegate {
    
    /// updates the neighbouring flys when one flashes
    func fireFlyFlashed(fly: SWHFlyView) {
        for y in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
            for x in 0..<SWHFireFlyViewController.NumberOfFlysPerRow {
                let arrayFly = flies[y][x]
                if arrayFly == fly {
                    if y > 0 {
                        if x > 0 {
                            let nextFly = flies[y-1][x-1]
                            if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                                nextFly.resetTimer()
                            }
                        }
                        
                        let nextFly = flies[y-1][x]
                        if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                            nextFly.resetTimer()
                        }
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow  {
                            let nextFly = flies[y-1][x+1]
                            if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                                nextFly.resetTimer()
                            }
                        }
                    }
                    
                    if y+1 < SWHFireFlyViewController.NumberOfFlysPerRow {
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow  {
                            let nextFly = flies[y+1][x+1]
                            if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                                nextFly.resetTimer()
                            }
                        }
                        
                        let nextFly = flies[y+1][x]
                        if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                            nextFly.resetTimer()
                        }
                        
                        if x-1 > 0 {
                            let nextFly = flies[y+1][x-1]
                            if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                                nextFly.resetTimer()
                            }
                        }
                    }
                    
                    if x+1 < SWHFireFlyViewController.NumberOfFlysPerRow  {
                        let nextFly = flies[y][x+1]
                        if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                            nextFly.resetTimer()
                        }
                    }
                    
                    if x-1 > 0 {
                        let nextFly = flies[y][x-1]
                        if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                            nextFly.resetTimer()
                        }
                    }
                    
                    return // return here as we have found index
                }
            }
        }
    }
}

/// shw fly view delegate - fire fly flashed to update neighbours
protocol SWHFlyViewDelegate {
    func fireFlyFlashed(fly: SWHFlyView)
}

/// simple view that controls the fly state
class SWHFlyView: UIView {
    
    /// timer for the fly to flash
    var flashTimer: Timer?
    
    /// view that goes to yellow when it flashes
    var flashView: UIView?
    
    /// labels show value between 0 and 10
    var label: UILabel?
    
    /// delegate
    var delegate: SWHFlyViewDelegate?
    
    /// ellapsed timer - updates the label and tells the view to flash when reaches 10
    var ellapsedTimer: TimeInterval = 0.0 {
        didSet {
            label?.text = "\(Int(ellapsedTimer))"
            if ellapsedTimer >= 9.9 {
                flash()
            }
        }
    }
    
    /// configures the view and starts the timer
    func configure() {
        
        if flashView == nil {
            flashView = UIView(frame: CGRect(x: 0, y: 0, width: SWHFireFlyViewController.FlyHeight, height: SWHFireFlyViewController.FlyHeight))
            flashView?.backgroundColor = UIColor.yellow
            flashView?.alpha = 0
            addSubview(flashView!)
        }
        
        if label == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: SWHFireFlyViewController.FlyHeight, height: SWHFireFlyViewController.FlyHeight))
            label?.text = "0"
            label?.textAlignment = NSTextAlignment.center
            label?.textColor = UIColor.white
            addSubview(label!)
        }
        
        backgroundColor = UIColor.black
        
        ellapsedTimer += (9 - 0) * Double(Double(arc4random()) / Double(UInt32.max)) + 0
        
        flashTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerTicked(timer:)), userInfo: nil, repeats: true)
    }
    
    /// timer ticked - updates ellpased timer
    @objc
    func timerTicked(timer: Timer) {
        ellapsedTimer += timer.timeInterval
    }
    
    /// flash - animation and alerts delegate
    func flash() {
        delegate?.fireFlyFlashed(fly: self)
        
        UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.flashView!.alpha = 1
            }) { (finish) -> Void in
                self.flashView!.alpha = 0
                self.resetTimer()
        }
    }
    
    /// resets timer
    func resetTimer() {
        flashTimer?.invalidate()
        ellapsedTimer = 0.0
        flashTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerTicked(timer:)), userInfo: nil, repeats: true)
    }
}
