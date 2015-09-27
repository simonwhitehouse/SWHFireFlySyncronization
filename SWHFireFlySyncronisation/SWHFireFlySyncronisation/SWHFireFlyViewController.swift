//
//  ViewController.swift
//  SWHFireFlySyncronisation
//
//  Created by Simon J Whitehouse on 27/09/2015.
//  Copyright © 2015 co.swhitehouse. All rights reserved.
//

import UIKit

class SWHFireFlyViewController: UIViewController {
    
    var flies = Array<Array<SWHFlyView>>()
    
    static let NumberOfFlysPerRow = 10
    static let SensitivePeriod = 7.0
    static let FlyHeight = ((UIScreen.mainScreen().bounds.size.width - 40) - CGFloat((SWHFireFlyViewController.NumberOfFlysPerRow - 1) * 5)) / CGFloat(SWHFireFlyViewController.NumberOfFlysPerRow)
    
    @IBOutlet weak var flyContainer: UIView! {
        didSet {
            flyContainer.layer.borderColor = UIColor.whiteColor().CGColor
            flyContainer.layer.borderWidth = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buildFlies()
    }
    
    func buildFlies() {
        var startOriginX: CGFloat = 0.0
        var startOriginY: CGFloat = 0.0
        
        let flyHeight = SWHFireFlyViewController.FlyHeight
        
        for var y = 0; y < SWHFireFlyViewController.NumberOfFlysPerRow; y++ {
            flies.append([SWHFlyView]())
            for var x = 0; x < SWHFireFlyViewController.NumberOfFlysPerRow; x++ {
                let newFly = SWHFlyView(frame: CGRectMake(startOriginX, startOriginY, flyHeight, flyHeight))
                flyContainer.addSubview(newFly)
                newFly.configure()
                startOriginX += flyHeight + 5
                newFly.delegate = self
                flies[y].append(newFly)
            }
            
            startOriginX = 0
            startOriginY += flyHeight + 5
        }
    }
    
    
    
}

extension SWHFireFlyViewController: SWHFlyViewDelegate {
    func fireFlyFlashed(fly: SWHFlyView) {
        
        for var y = 0; y < SWHFireFlyViewController.NumberOfFlysPerRow; y++ {
            for var x = 0; x < SWHFireFlyViewController.NumberOfFlysPerRow; x++ {
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
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
                            let nextFly = flies[y-1][x+1]
                            if nextFly.ellapsedTimer < SWHFireFlyViewController.SensitivePeriod {
                                nextFly.resetTimer()
                            }
                        }
                    }
                    
                    if y+1 < SWHFireFlyViewController.NumberOfFlysPerRow - 1 {
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
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
                    
                    if x+1 < SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
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

protocol SWHFlyViewDelegate {
    func fireFlyFlashed(fly: SWHFlyView)
}

class SWHFlyView : UIView {
    var flashTimer: NSTimer?
    
    var flashView: UIView?
    var label: UILabel?
    
    var delegate: SWHFlyViewDelegate?
    
    var ellapsedTimer: NSTimeInterval = 0.0 {
        didSet {
            label?.text = "\(Int(ellapsedTimer))"
            if ellapsedTimer >= 9.9 {
                flash()
            }
        }
    }
    
    func configure() {
        
        if flashView == nil {
            flashView = UIView(frame: CGRectMake(0, 0, SWHFireFlyViewController.FlyHeight, SWHFireFlyViewController.FlyHeight))
            flashView?.backgroundColor = UIColor.yellowColor()
            flashView?.alpha = 0
            addSubview(flashView!)
        }
        
        if label == nil {
            label = UILabel(frame: CGRectMake(0, 0, SWHFireFlyViewController.FlyHeight, SWHFireFlyViewController.FlyHeight))
            label?.text = "0"
            label?.textAlignment = NSTextAlignment.Center
            label?.textColor = UIColor.whiteColor()
            addSubview(label!)
        }
        
        backgroundColor = UIColor.blackColor()
        
        ellapsedTimer += (9 - 0) * Double(Double(arc4random()) / Double(UInt32.max)) + 0
        
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
    
    func timerTicked(timer: NSTimer) {
        ellapsedTimer += timer.timeInterval
    }
    
    func flash() {
        
        delegate?.fireFlyFlashed(self)
        
        UIView.animateKeyframesWithDuration(0.1, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.flashView!.alpha = 1
            }) { (finish) -> Void in
                self.flashView!.alpha = 0
                self.resetTimer()
        }
    }
    
    func resetTimer() {
        flashTimer?.invalidate()
        ellapsedTimer = 0.0
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
}
