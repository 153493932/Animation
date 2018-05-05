//
//  waveView.swift
//  wave
//
//  Created by dhlsnow on 2017/9/18.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

import UIKit

protocol WaveViewDelegate {
    func waveHeightDidChange(progress:Double)
}

class waveView: UIView {
    
    var delegate : WaveViewDelegate?
    public var progress = 0.0

    // mask
    private var waveLayer1 = CAShapeLayer()
    private var waveLayer2 = CAShapeLayer()
    // gradientLayer
    private var gradientLayer1 = CAGradientLayer()
    private var gradientLayer2 = CAGradientLayer()
    
    private var displayLink = CADisplayLink()
    private var waveHeightIsChanging = true
    
    var startPhase = 0.0
    var waveHeight = 0.0
    var amplitude = 10.0
    var restAmplitude = 10.0
    var speed = 0.02
    var restSpeed = 0.02
    var t:Double{
        return Double(bounds.width/0.6)
    }
    var startPhaseOffset = 1.5
    

    private var heightBlock = UIView() //高度和waveHeight进行绑定，通过上下移动heightBlock来调整波浪高度

    // 渐变色
    struct GradientColor {
        var color1 = UIColor(red:0.80, green:0.95, blue:0.98, alpha:1.00).cgColor
        var color2 = UIColor(red:0.68, green:0.93, blue:0.99, alpha:1.00).cgColor
        var color3 = UIColor(red:0.94, green:0.96, blue:0.99, alpha:1.00).cgColor
    }
    
    var blueGradient1 = GradientColor()
    var blueGradient2 = GradientColor(
        color1 : UIColor(red:0.66, green:0.93, blue:1.00, alpha:1.00).cgColor,
        color2 : UIColor(red:0.54, green:0.90, blue:1.00, alpha:1.00).cgColor,
        color3 : UIColor(red:0.86, green:0.96, blue:1.00, alpha:1.00).cgColor
    )
    

    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    func waveAnimation(withDuration duration:Double,progress:Double) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.waveHeightIsChanging = true
            self.heightBlock.center.y = CGFloat(200*(1-progress))
            self.restSpeed = 0.06
            self.restAmplitude = 15
        }, completion: {_ in
            let when = DispatchTime.now() + 0.03 // wait 0.05s
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.waveHeightIsChanging = false
            }
            UIView.animate(withDuration:1, animations:{
                self.restSpeed = 0.02
                self.restAmplitude = 10
            })
        })
    }
    
    private func setup(){
        setupShapeLayer()
        setupGradientLayer(gradientLayer1, color:blueGradient1,mask: waveLayer1)
        setupGradientLayer(gradientLayer2, color:blueGradient2,mask: waveLayer2)
        
        heightBlock.frame = CGRect(x: self.bounds.width/2, y: self.bounds.height, width: 10, height: 10)
        heightBlock.backgroundColor = UIColor.clear
        self.addSubview(heightBlock)

        displayLink = CADisplayLink(target: self, selector: #selector(waveView.updatePath))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink.isPaused = false
    }
    
    
    private func setupShapeLayer(){
        self.clipsToBounds = true
        waveLayer1.path = sinePath(starttingPhase: 0, waveHeight: waveHeight, T: t,amplitude: amplitude).cgPath
        waveLayer1.fillColor = UIColor.red.cgColor
        waveLayer1.opacity = 1
        
        waveLayer2.path = sinePath(starttingPhase: startPhaseOffset, waveHeight: waveHeight, T: t,amplitude: amplitude).cgPath
        waveLayer2.fillColor = UIColor.blue.cgColor
        waveLayer2.opacity = 1

    }
    
    
    // 配置渐变背景
    private func setupGradientLayer(_ gradientLayer:CAGradientLayer ,color:GradientColor,mask:CAShapeLayer){
        gradientLayer.frame = CGRect(x: 0, y:0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [color.color1,color.color2,color.color3]
        gradientLayer.mask = mask
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    // 循环动画
    @objc private func updatePath()  {
//        waveHeightIsChanging = true
        if waveHeightIsChanging {
            delegate?.waveHeightDidChange(progress: progress)
        }

        if speed > restSpeed {
            speed -= 0.0004
        }
        
        if speed < restSpeed {
            speed += 0.0008
        }

        if amplitude > restAmplitude {
            amplitude -= 0.05
        }
        
        if amplitude < restAmplitude {
            amplitude += 0.1
        }

        startPhase += speed
        waveLayer1.path = sinePath(starttingPhase: startPhase, waveHeight: waveHeight, T: t,amplitude: amplitude).cgPath
        waveLayer2.path = sinePath(starttingPhase: startPhase*1+startPhaseOffset, waveHeight: waveHeight, T: t,amplitude: amplitude).cgPath
        
        waveHeight = Double(self.bounds.height - (heightBlock.layer.presentation()?.frame.midY)!)
        progress = max(0, 1-Double((heightBlock.layer.presentation()?.frame.midY)!/self.bounds.height ))
    }
    
    
    // 波浪曲线
    private func sinePath(starttingPhase phase:Double,waveHeight:Double,T:Double,amplitude:Double) -> UIBezierPath {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))

        let freq = 2*Double.pi/T
        let steps = 100.0
        let stepX = Double(width)/steps

        for i in 0...Int(steps) {
            let x = Double(i) * stepX
            let y = Double(height)-(amplitude*sin(phase+freq*(stepX*Double(i)))+Double(waveHeight))
            path.addLine(to: CGPoint(x: x, y:y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.close()
        return path
    }


 
}
