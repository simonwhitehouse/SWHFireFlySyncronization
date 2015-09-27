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
        
        let flyHeight = ((UIScreen.mainScreen().bounds.size.width - 40) - CGFloat((SWHFireFlyViewController.NumberOfFlysPerRow - 1) * 5)) / CGFloat(SWHFireFlyViewController.NumberOfFlysPerRow)
        
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
                var arrayFly = flies[y][x]
                if arrayFly == fly {
                    
                    if y > 0 {
                        if x > 0 {
                            var nextFly = flies[y-1][x-1]
                            if nextFly.ellapsedTimer < 6.0 {
                                nextFly.resetTimer()
                            }
                        }
                        
                        var nextFly = flies[y-1][x]
                        if nextFly.ellapsedTimer < 6.0 {
                            nextFly.resetTimer()
                        }
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
                            var nextFly = flies[y-1][x+1]
                            if nextFly.ellapsedTimer < 6.0 {
                                nextFly.resetTimer()
                            }
                        }
                    }
                    
                    if y+1 < SWHFireFlyViewController.NumberOfFlysPerRow - 1 {
                        
                        if x+1 <  SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
                            var nextFly = flies[y+1][x+1]
                            if nextFly.ellapsedTimer < 6.0 {
                                nextFly.resetTimer()
                            }
                        }
                        
                        var nextFly = flies[y+1][x]
                        if nextFly.ellapsedTimer < 6.0 {
                            nextFly.resetTimer()
                        }
                        
                        if x-1 > 0 {
                            var nextFly = flies[y+1][x-1]
                            if nextFly.ellapsedTimer < 6.0 {
                                nextFly.resetTimer()
                            }
                        }
                    }
                    
                    if x+1 < SWHFireFlyViewController.NumberOfFlysPerRow - 1  {
                        var nextFly = flies[y][x+1]
                        if nextFly.ellapsedTimer < 6.0 {
                            nextFly.resetTimer()
                        }
                    }
                    
                    if x-1 > 0 {
                        var nextFly = flies[y][x-1]
                        if nextFly.ellapsedTimer < 6.0 {
                            nextFly.resetTimer()
                        }
                    }
                    
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
    
    var delegate: SWHFlyViewDelegate?
    
    var ellapsedTimer: NSTimeInterval = 0.0 {
        didSet {
            if ellapsedTimer >= 9.9 {
                flash()
            }
        }
    }
    
    func configure() {
        backgroundColor = UIColor.yellowColor()
        alpha = 0
        
        ellapsedTimer += (9 - 0) * Double(Double(arc4random()) / Double(UInt32.max)) + 0
        
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
    
    func timerTicked(timer: NSTimer) {
        ellapsedTimer += timer.timeInterval
    }
    
    func flash() {
        
        delegate?.fireFlyFlashed(self)
        
        UIView.animateKeyframesWithDuration(0.1, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.alpha = 1
            }) { (finish) -> Void in
                self.alpha = 0
                self.resetTimer()
        }
    }
    
    func resetTimer() {
        flashTimer?.invalidate()
        ellapsedTimer = 0.0
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
}
