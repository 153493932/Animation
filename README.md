# Animation
                                               移动端可共用动效算法开发
    本文主要介绍如何在Android和iOS设备上，用同一套C语言代码实现一组动画效果的设计和开发过程。其中包括平台层和可共用C层的设计和实现。C层处理需要高运算效率的图像处理，粒子系统等算法。

    项目背景：
    1、为了让App展示更酷炫，UX团队在设计中增加了大量的动画效果。
    2、面对同一个效果，往往不同开发保持着不同的开发思路。最后实现的效果往往不一致。为了保持效果的一致性，需要花费大量的时间调优，甚至重新开发。

    解决办法：
    基于跨Android和iOS 的C/C++开发语言，1人开发和交流，提炼Android、iOS的核心效果算法。
    以下我们以项目中遇到的水波和气泡效果为例，怎样获得可共用的C/C++代码。这两种效果需要具有随机性和人机交互，例如水波的波峰和波谷和播放速度都是随机的；气泡可以在用户点击的位置动态产生气泡。  避免让用户看起来像播放gif动画。
    那我们接着需要思考除了用C/C++语言开发外，怎样让动效代码具有跨平台的性呢？这里我们对Android和iOS设备做了一层抽象。做过图像处理的开发都比较了解这点：屏幕上显示的图像，都是由像素点组成的。像素点不同颜色和位置勾画出了整个图像。而且在设备里面一般都是通过一块内存来放像素点信息的，映射到代码里面那就是一个二维数组。那刚好联想到Android和iOS中对图片的处理都会从原始的jpeg或者png文件解析到一块内存中，显示的时候通过像素合成到显示的内存块。

    通过上面的思考，我们把实现步骤分解如下：
    1、创建2个平台相关的自定义View，主要功能是定时把更新过的数据刷到界面。
    2、创建内存，提供公用的效果算法处理。算法更新内存中不同位置的像素颜色，View读取内存显示出来。
    3、开发核心公用算法。
  
    具体步骤如下：（以气泡效果为例）

    1、创建自定义View。这个可以做成模版，后面的需要自定义的动画，都可以一样的复用。
    Android：
    public class BubbleView extends View {
     ……


    @Override
    public void onDraw(Canvas canvas) {
        long startTime = System.currentTimeMillis(), endTime;
        //刷新内存
        DRLib.showBubbles(baseBitmap, baseBitmap.getWidth(),baseBitmap.getHeight());
        //更新到画布
        canvas.drawBitmap(baseBitmap, srcRect, srcRect, null);

        endTime = (System.currentTimeMillis() - startTime);
        Log.e("TAG", "Bubble endTime =" + endTime);
        //我们以每秒钟20帧，设置刷新频率。要注意减去中间代码执行的时间。
        handler.postDelayed(runnable, (long) (Math.max(5.0d, 50.0d - endTime)));
    }

    //点击交互
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        ……
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                DRLib.addBubble(pos_x, pos_y);
                break;
        }

        return true;
    }
}
   
iOS ：

class BundlesView: UIView {
    
    ……
    
    func setupSubviews() {
        BubbleOC.initBubbles(UIImage(named:"bubble"))
        timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.showBubbles), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    func showBubbles() {
        let uiImage = BubbleOC.showBubbles((NSInteger)(self.frame.width), height:(NSInteger)(self.frame.height));
        let bgColor = UIColor.init(patternImage: uiImage!);
	//iOS 需要从UIImage再解析出来颜色数据，设置到背景。这里相当于做了Color Data转UIImage，再UIImage变Color Data的过程。有时间再研究有没有简化方法。
        self.backgroundColor = bgColor;
    }
    
}

2、创建内存
Android：




    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        baseBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        //baseBitmap图像合成Buffer
        Bitmap bubbleBitmap = BitmapFactory.decodeResource(this.getResources(), R.mipmap.particle_bubble).copy(Bitmap.Config.ARGB_8888, true);
        DRLib.initBubbles(bubbleBitmap);
       //bubbleBitmap 原始图像数据Buffer
    }


iOS：
@implementation BubbleOC

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
    buffer = (UInt8 *)malloc(size * sizeof(UInt8));//创建像素合成内存
    
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

3、C语言公用算法
我们采用粒子系统，来统一管理每个气泡的生命周期。可以先看一下简化的例子系统。
typedef struct BitmapStruct {
    unsigned char         *data;
    int         width;
    int         height;
} Bitmap;

typedef struct ParticleStruct{
    int         		visible;
    int			life;
    int			size;
    int			cx;
    int			cy;
    int			cz;
    int			speedX;
    int			speedY;
    int			speedIncX;
    int			speedIncY;
    int			alpha;
    int			alphaInc;
    int			angle;
    int			radius;
    int			color;
    int         		width;
    int         		height;
    Bitmap      		bitmap;  //原始数据的像素的Buffer
} Particle;

extern Particle *addPaticel(int *data, int width, int height, int color) ;

//核心气泡处理算法
Particle particles[BUBBLE_MAX]; //粒子数组

//每个粒子投射到画布上的像素合成处理
void drawBubble(Particle particle, unsigned char *layerBuffer, int layerWidth, int layerHeight) {

    for (int y = 0; y < particleBitmap.height; y++) {
        if (particle.cy + y < 0) {
            break;
        }
        unsigned int *destLine = (unsigned int *) layerBuffer + (particle.cy + y) * layerWidth + particle.cx;
        for (int x = 0; x < particleBitmap.width; x++) {
            if (x + particle.cx == layerWidth - 1) {
                break;
            }
            unsigned int srcColor = *((unsigned int *) particleBitmap.data + y * particleBitmap.width + x);
            unsigned int alpha = srcColor >> 24;
            unsigned int destAlpha;
            switch (alpha) {//根据原始数据alpha，跟背景色混合处理
                case 0:
                    break;
                case 255:
                    *(destLine + x) = srcColor;
                    break;
                default:
                    destAlpha = ((particle.alpha * alpha) >> 8);
                    *(destLine + x) = (destAlpha << 24) | (srcColor & 0x00FFFFFF);
                    break;
            }

        }
    }
}


void bubbleCycle(unsigned char *layerBuffer, int layerWidth, int layerHeight) {
    int i, count;
    float scale, half_height;
    ….

    for (i = 0; i < BUBBLE_MAX; i++) {
        if (count == 0)
            break;

        if (particles[i].visible == 1) {
            particles[i].life--;
            particles[i].cx += particles[i].speedX;
            particles[i].cy += particles[i].speedY;
            particles[i].speedX += particles[i].speedIncX;
            particles[i].speedY += particles[i].speedIncY;
		//根据粒子属性，实现一个活泼的小粒子
            drawBubble(particles[i], layerBuffer, layerWidth, layerHeight);
		//粒子回收
            if (particles[i].life == 0 || particles[i].cy < 0
                || particles[i].cx < -particleBitmap.width || particles[i].cx > layerWidth + particleBitmap.width) {
                particles[i].visible = 0;
                i--;
                bubbleCount--;
            }

            count--;
        }
    }

         //产生新粒子
    count = random() % BUBBLE_MAX;
    for (i = 0; i < count; i++) {

		……
        particles[i].visible = 1;
        bubbleCount++;
    }
}



void addBubble(int x, int y) {
        //跟用户交互式时的动态添加粒子处理

    particles[i].alpha = 155 + random() % 100;
    particles[i].visible = 1;
}

   通过上面的步骤我们实现了Android和iOS动效核心算法代码的共用。我们也在同一个设计思想的指导下，实现了两端一致的效果。在需要调优的地方，可以从C层提供相关参数，在平台层调优。此过程除了可以应用在2D动效，也可以运用在3D场景开发当中。
