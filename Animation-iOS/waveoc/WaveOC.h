//
//  Header.h
//  wave
//
//  Created by wanghaijun on 2017/11/2.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Wave.h"

@interface WaveOC : NSObject

+ (UIImage*) showWave:(CGFloat)width height:(CGFloat)height p:(double)phase a:(double)amplitude color1:(unsigned int)color1 color2:(unsigned int)color2;

@end
