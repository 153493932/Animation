//
//  Bubble.m
//  wave
//
//  Created by 时文娟 　　 on 17/11/5.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

#import "BubbleOC.h"

@implementation BubbleOC

unsigned char *bubbleData ;
int bubbleWidth;
int bubbleHeight;


+ (UIImage *) initBubbles:(UIImage *)uiImage {
    CGImageRef  imageRef;
    imageRef = uiImage.CGImage;

    int width  = (int)CGImageGetWidth(imageRef);
    int height = (int)CGImageGetHeight(imageRef);
    bubbleWidth = width;
    bubbleHeight = height;
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);

    initBubble(buffer, width, height);
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];

    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

+ (UIImage*) showBubbles:(NSInteger)width height:(NSInteger)height {
    
    UInt8*      buffer;
    int size = (int)(width * height << 2);
    buffer = (UInt8 *)malloc(size * sizeof(UInt8));
    
    bubbleCycle(buffer, (int)width, (int)height);
    
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, size);
    
    
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    8, 32, width * 4,
                                    CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaFirst, effectedDataProvider,
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
