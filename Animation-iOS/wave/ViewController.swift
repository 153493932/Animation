//
//  ViewController.swift
//  wave
//
//  Created by dhlsnow on 2017/9/18.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController , WaveViewDelegate  {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var waveLoadingView: waveView!
    @IBOutlet weak var money: UILabel!

    // 调试用
    @IBOutlet weak var amplitude: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var phase: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var isControllOpen = true
    var duration = 2.0; //变化高度所用的时间
    
    var waveView: WaveView3!
    var bubblesView: BundlesView!
    
    // json 动画
    let progressAnimation = LOTAnimationView(name: "progressRing")//进度条json动画 控制播放进度
    let bubbleAnimation = LOTAnimationView(name: "bubble")//气泡json动画 循环播放


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        waveLoadingView.delegate = self
//
//        // setup json animation
//        progressAnimation.frame = CGRect(x: 0, y: 0, width: progressView.bounds.width, height: progressView.bounds.height)
//        progressView.addSubview(progressAnimation)
//
//        bubbleAnimation.frame = CGRect(x: 0, y: 0, width: bubbleView.bounds.width, height: bubbleView.bounds.height)
//        bubbleView.addSubview(bubbleAnimation)
//        bubbleAnimation.loopAnimation = true
//        bubbleAnimation.play()
//
//        syncLabel()
//
//        waveLoadingView.layer.cornerRadius = 100
//        waveLoadingView.waveAnimation(withDuration: duration, progress: 0.75)
        
        
//        BubbleOC.initBubbles(UIImage(named:"bubble"))
//
//
//        // 启用计时器，控制每秒执行一次tickDown方法
//        timer = Timer(timeInterval: 0.04, target: self, selector: #selector(self.wave), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
        
        waveView = WaveView3(frame:CGRect(x:0, y:(self.view.frame.height - 300)/2, width:self.view.frame.width,height:300));
        self.view.addSubview(waveView);
        
        bubbleView = BundlesView(frame:CGRect(x:0, y:0, width:self.view.frame.width, height:view.frame.height));
        self.view.addSubview(bubbleView);
    }
 
  
    
    
    // WaveViewDelegate
    func waveHeightDidChange(progress: Double) {
        print(progress)
        money.text = String(Int(waveLoadingView.progress*3000))
        progressAnimation.animationProgress = CGFloat(progress)
    }

    
    
    // 后面的都是调试用的
    
    func syncLabel() {
        durationLabel.text = String(duration)
        amplitude.text = String(waveLoadingView.amplitude)
        speed.text = String(waveLoadingView.speed)
        phase.text = String(waveLoadingView.startPhaseOffset)
    }

    @IBAction func changeHeight(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            waveLoadingView.waveAnimation(withDuration: duration, progress: 0)
        case 1:
            waveLoadingView.waveAnimation(withDuration: duration, progress: 0.25)

        case 2:
            waveLoadingView.waveAnimation(withDuration: duration, progress: 0.5)

        case 3:
            waveLoadingView.waveAnimation(withDuration: duration, progress: 0.75)

        case 4:
            waveLoadingView.waveAnimation(withDuration: duration, progress: 1)

        default:
            break
        }
    }
    
    
    @IBAction func amplitudeSlider(_ sender: UISlider) {
        amplitude.text = String(sender.value)
        waveLoadingView.restAmplitude = Double(sender.value)
    }
    
    @IBAction func speedSlider(_ sender: UISlider) {
        speed.text = String(sender.value)
        waveLoadingView.restSpeed = Double(sender.value)

    }
    
    @IBAction func phaseSlider(_ sender: UISlider) {
        phase.text = String(sender.value)
        waveLoadingView.startPhaseOffset = Double(sender.value)
    }
    
    @IBAction func changeDuration(_ sender: UISlider) {
        durationLabel.text = String(sender.value)
        duration = Double(sender.value)
    }
    
    @IBAction func showControll(_ sender: UITapGestureRecognizer) {
        if !isControllOpen {
            print("open")
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            isControllOpen = true
        }

    }
    
    @IBAction func closeControll(_ sender: UIButton) {
        if isControllOpen {
            print("close")
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = -230
                self.view.layoutIfNeeded()
            })
            isControllOpen = false
        }
    }
    
}

