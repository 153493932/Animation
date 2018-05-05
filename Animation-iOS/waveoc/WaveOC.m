//
//  Wave.m
//  wave
//
//  Created by wanghaijun on 2017/11/2.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//


#import "WaveOC.h"
#import "BubbleOC.h"

@implementation WaveOC

+ (UIImage*) showWave:(double)width height:(double)height p:(double)phase a:(double)amplitude color1:(unsigned int)color1 color2:(unsigned int)color2 {

    UInt8*      buffer;
    int size = (int)(width * height * 4);
    buffer = (UInt8 *)malloc(size * sizeof(UInt8));

    drawWave(buffer, (int)width, (int)height, phase, amplitude, color1, color2);
    
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, size);
    

    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    

    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    8, 32, width * 4,
                                    CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast, effectedDataProvider,
                                    NULL, true, kCGRenderingIntentDefault);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    free(buffer);
    buffer = nil;
    return effectedImage;
}
@end
