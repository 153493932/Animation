//
//  WaveView2.swift
//  wave
//
//  Created by wanghaijun on 2017/11/9.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

import UIKit

var waveHeight:Double = 0.0
var timer:Timer!

var startPhase2 = 0.0
var waveHeight2 = 0.0
var amplitude2 = 10.0
var restAmplitude2 = 10.0
var speed2 = 0.02
var restSpeed2 = 0.2

class WaveView3: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        timer = Timer(timeInterval: 0.04, target: self, selector: #selector(self.wave), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    func wave() {
        //        let timeInterval = NSDate().timeIntervalSince1970 * 1000
        //以下系数都可以增加随机数，使效果更生动
        if speed2 >= restSpeed2 {
            speed2 -= 0.0004
        }
        
        if speed2 < restSpeed2 {
            speed2 += 0.0008
        }
        
        if amplitude2 >= restAmplitude2 {
            amplitude2 -= 0.0005
        }
        
        if amplitude2 < restAmplitude2 {
            amplitude2 += 0.001
        }
        
        startPhase2 += speed2
        
        
        let uiImage = WaveOC.showWave(self.frame.width, height:self.frame.height, p:startPhase2, a:amplitude2, color1:0xFF88F0FF, color2:0xFFa0ffff)
        let bgColor = UIColor.init(patternImage: uiImage!);
        self.backgroundColor = bgColor;
        
        //       let timeInterval2 = NSDate().timeIntervalSince1970 * 1000
        //       print("time = ", timeInterval2 - timeInterval);
    }
}
