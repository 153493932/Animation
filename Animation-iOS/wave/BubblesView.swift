//
//  Bubble.swift
//  wave
//
//  Created by wanghaijun on 2017/11/9.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

import UIKit

class BundlesView: UIView {
    
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
        BubbleOC.initBubbles(UIImage(named:"bubble"))
        timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.showBubbles), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    func showBubbles() {
        let uiImage = BubbleOC.showBubbles((NSInteger)(self.frame.width), height:(NSInteger)(self.frame.height));
        let bgColor = UIColor.init(patternImage: uiImage!);
        self.backgroundColor = bgColor;
    }
    
}
