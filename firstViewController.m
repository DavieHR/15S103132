//
//  firstViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "firstViewController.h"

@interface firstViewController ()

@end

@implementation firstViewController

const float colormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
const float colormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };
//旧化
const float colormatrix_jiuhua[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
const float colormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐色
const float colormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
const float colormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//浪漫
const float colormatrix_langman[] = {
    0.8f, 0, 0, 0, 60.0f,
    0, 0.8f,0, 0, 60.0f,
    0, 0, 0.8f, 0, 60.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
const float colormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//梦幻
const float colormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
const float colormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sv.contentSize=CGSizeMake(1130,100);
    _source=[_iv image];
    _iv.userInteractionEnabled=YES;
    _b=50;
    _c=50;
    _con=50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回一个使用RGBA通道的位图上下文
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    long bitmapByteCount; //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    long bitmapBytesPerRow; //计算整张图占用的字节数
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow = pixelsWide * 4;
    bitmapByteCount	= bitmapBytesPerRow * pixelsHigh;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc(bitmapByteCount);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate(bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease(colorSpace);
    bitmapData=nil;
    return context;
}

//图片转换成数组，每4个元素对应图片一个像素点
static unsigned char* RequestImagePixelData(UIImage* inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char* data = CGBitmapContextGetData(cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

//改变RGBA数值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)
{
    int redV=*red;
    int greenV=*green;
    int blueV=*blue;
    int alphaV=*alpha;
    *red=f[0]*redV+f[1]*greenV+f[2]*blueV+f[3]*alphaV+f[4];
    *green=f[0+5]*redV+f[1+5]*greenV+f[2+5]*blueV+f[3+5]*alphaV+f[4+5];
    *blue=f[0+5*2]*redV+f[1+5*2]*greenV+f[2+5*2]*blueV+f[3+5*2]*alphaV+f[4+5*2];
    *alpha=f[0+5*3]*redV+f[1+5*3]*greenV+f[2+5*3]*blueV+f[3+5*3]*alphaV+f[4+5*3];
    if(*red>255)
        *red=255;
    if(*red<0)
        *red=0;
    if(*green>255)
        *green=255;
    if(*green<0)
        *green=0;
    if(*blue>255)
        *blue=255;
    if(*blue<0)
        *blue=0;
    if(*alpha>255)
        *alpha=255;
    if(*alpha<0)
        *alpha=0;
}

UIImage* processImage(UIImage* inImage,const float* f)
{
    unsigned char* imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    size_t w = CGImageGetWidth(inImageRef);
    size_t h = CGImageGetHeight(inImageRef);
    int wOff = 0;
    int pixOff = 0;
    //双层循环按照长宽的像素个数迭代每个像素点
    for(GLuint y=0;y<h;y++)
    {
        pixOff = wOff;
        for(GLuint x=0;x<w;x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha=(unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red,&green,&blue,&alpha,f);
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            //将数组的索引指向下四个元素
            pixOff += 4;
        }
        wOff+=w*4;
    }
    
    NSInteger 	dataLength = w*h*4;
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,imgPixel,dataLength,NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    long bytesPerRow = 4*w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(w,h,bitsPerComponent,bitsPerPixel,bytesPerRow,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    UIImage* my_Image = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}

-(IBAction)put1
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_lomo);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put2
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_heibai);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put3
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_jiuhua);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put4
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_gete);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put5
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_ruise);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put6
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_danya);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put7
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_langman);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put8
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_guangyun);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put9
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_menghuan);
    [_iv setImage:des];
    _edited=des;
}

-(IBAction)put10
{
    [self rollback];
    UIImage* source=_source;
    UIImage* des=processImage(source,colormatrix_yese);
    [_iv setImage:des];
    _edited=des;
}

CIImage* editAll(CIImage* img,float b,float c,float con)
{
    CIFilter* filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:img forKey:kCIInputImageKey];
    //亮度:-1~1
    [filter setValue:[NSNumber numberWithFloat:(b-50)/500] forKey:@"inputBrightness"];
    //饱和度0~2
    [filter setValue:[NSNumber numberWithFloat:c/50] forKey:@"inputSaturation"];
    //对比度0~2
    [filter setValue:[NSNumber numberWithFloat:(con+450)/500] forKey:@"inputContrast"];
    // 得到过滤后的图片
    CIImage* outputImage = [filter outputImage];
    return outputImage;
}

-(IBAction)sliderValueWithBright
{
    int vb_int=(int)_usb.value;
    NSString* vb=[NSString stringWithFormat:@"%d",vb_int];
    vb=[vb stringByAppendingString:@"%"];
    _lb.text=vb;
    
    UIImage* brighter=[[UIImage alloc] init];
    
    CIImage* beginImage = [CIImage imageWithCGImage:_edited.CGImage];
    CIImage *outputImage = editAll(beginImage,_usb.value,_c,_con);
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    brighter = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    // 释放C对象
    CGImageRelease(cgimg);
    _iv.image=brighter;
    _b=_usb.value;
}

-(IBAction)sliderValueWithColor
{
    int vc_int=(int)_usc.value;
    NSString* vc=[NSString stringWithFormat:@"%d",vc_int];
    vc=[vc stringByAppendingString:@"%"];
    _lc.text=vc;
    
    UIImage* brighter=[[UIImage alloc] init];
    
    CIImage* beginImage = [CIImage imageWithCGImage:_edited.CGImage];
    CIImage *outputImage = editAll(beginImage,_b,_usc.value,_con);
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    brighter = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    // 释放C对象
    CGImageRelease(cgimg);
    _iv.image=brighter;
    _c=_usc.value;
}

-(IBAction)sliderValueWithContract
{
    int vcon_int=(int)_uscon.value;
    NSString* vcon=[NSString stringWithFormat:@"%d",vcon_int];
    vcon=[vcon stringByAppendingString:@"%"];
    _lcon.text=vcon;
    
    UIImage* brighter=[[UIImage alloc] init];
    
    CIImage* beginImage = [CIImage imageWithCGImage:_edited.CGImage];
    CIImage *outputImage = editAll(beginImage,_b,_c,_uscon.value);
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    brighter = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    // 释放C对象
    CGImageRelease(cgimg);
    _iv.image=brighter;
    _con=_uscon.value;
}

UIAlertController* showTakePhoto()
{
    NSString* msg=@"相机休息中,请稍候尝试.";
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){}];
    [alert addAction:defaultAction];
    return alert;
}

-(void)waitAdd
{
    UIImagePickerController* picker=[[UIImagePickerController alloc] init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction)addphoto
{
    [self performSelector:@selector(waitAdd) withObject:nil afterDelay:0.0f];
}

-(void)waitTake
{
    UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* picker=[[UIImagePickerController alloc] init];
        picker.allowsEditing=YES;
        picker.delegate=self;
        picker.sourceType=type;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert=showTakePhoto();
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(IBAction)takephoto
{
    [self performSelector:@selector(waitTake) withObject:nil afterDelay:0.0f];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _source=[info objectForKey:UIImagePickerControllerEditedImage];
    _edited=_source;
    [_iv setImage:_source];
    [_iv setContentMode:UIViewContentModeScaleAspectFill];
    _usb.value=50;
    _usc.value=50;
    _uscon.value=50;
    _lb.text=@"50%";
    _lc.text=@"50%";
    _lcon.text=@"50%";
    _b=50;
    _c=50;
    _con=50;
}

-(IBAction)rollback
{
    UIImage* source=_source;
    [_iv setImage:source];
    _edited=source;
    [_iv setContentMode:UIViewContentModeScaleAspectFill];
    _usb.value=50;
    _usc.value=50;
    _uscon.value=50;
    _lb.text=@"50%";
    _lc.text=@"50%";
    _lcon.text=@"50%";
    _b=50;
    _c=50;
    _con=50;
}

-(void)showSave:(UIImage*)image didSavingWithError:(NSError*)error contextInfo:(void*)info
{
    NSString* msg=nil;
    if(error!=NULL)
        msg=@"(T_T)";
    else
        msg=@"(^_^)";
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"保存结果" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)save
{
    UIImageWriteToSavedPhotosAlbum([_iv image],self,@selector(showSave:didSavingWithError:contextInfo:),NULL);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
    if(point.x>50&&point.x<320&&point.y>60&&point.y<320)
        _iv.image=_source;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIImage* brighter=[[UIImage alloc] init];
    
    CIImage* beginImage = [CIImage imageWithCGImage:_edited.CGImage];
    CIImage *outputImage = editAll(beginImage,_b,_c,_con);
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    brighter = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    // 释放C对象
    CGImageRelease(cgimg);
    _iv.image=brighter;
}

unsigned char* filterImage(int* r,int* g,int* b,unsigned long w,unsigned long h,int d,unsigned char* source)
{
    unsigned char* des=source;
    int m=(int)h/60;
    int n=(int)w/60;
    int her,heg,heb;
    double fangchar,fangchag,fangchab;
    double m0r,m0g,m0b;
    double vr,vg,vb;
    double kr,kg,kb;
    NSDate* startTime=[NSDate date];
    int size=(2*m+1)*(2*n+1);
    int lamda=10+5*d*d;
    for(int i=m;i<h-m;i++)
    {
        for(int j=n;j<w-n;j++)
        {
            if(*(r+i*w+j)>40&&*(g+i*w+j)>50&&*(b+i*w+j)>60)
            {
                her=0;fangchar=0.00;m0r=0.00;vr=0.00;kr=0.00;
                heg=0;fangchag=0.00;m0g=0.00;vg=0.00;kg=0.00;
                heb=0;fangchab=0.00;m0b=0.00;vb=0.00;kb=0.00;
                for(int x=i-m;x<=i+m;x++)
                {
                    for(int y=j-n;y<=j+n;y++)
                    {
                        her+=*(r+x*w+y);
                        heg+=*(g+x*w+y);
                        heb+=*(b+x*w+y);
                        fangchar+=(double)*(r+x*w+y)**(r+x*w+y);
                        fangchag+=(double)*(g+x*w+y)**(g+x*w+y);
                        fangchab+=(double)*(b+x*w+y)**(b+x*w+y);
                    }
                }
                m0r=(double)her/size;
                m0g=(double)heg/size;
                m0b=(double)heb/size;
                vr=fangchar/size-m0r*m0r;
                vg=fangchag/size-m0g*m0g;
                vb=fangchab/size-m0b*m0b;
                kr=vr/(vr+lamda);
                kg=vg/(vg+lamda);
                kb=vb/(vb+lamda);
                *(r+i*w+j)=(int)(m0r+((double)*(r+i*w+j)-m0r)*kr);
                *(g+i*w+j)=(int)(m0g+((double)*(g+i*w+j)-m0g)*kg);
                *(b+i*w+j)=(int)(m0b+((double)*(b+i*w+j)-m0b)*kb);
            }
        }
    }
    for(int i=m;i<h-m;i++)
    {
        for(int j=n;j<w-n;j++)
        {
            des[4*(w*i+j)]=*(r+i*w+j);
            des[4*(w*i+j)+1]=*(g+i*w+j);
            des[4*(w*i+j)+2]=*(b+i*w+j);
        }
    }
    double finishTime=[[NSDate date] timeIntervalSinceDate:startTime];
    NSLog(@"%f s",finishTime);
    return des;
}

-(IBAction)optimize
{
    UIView* __block redView=[[UIView alloc]initWithFrame:CGRectMake(_iv.frame.origin.x+50,_iv.frame.origin.y+50,50,50)];
    UIImage* bg=[UIImage imageNamed:@"cao.png"];
    redView.layer.contents=(id)bg.CGImage;
    redView.layer.backgroundColor=[UIColor clearColor].CGColor;
    CAKeyframeAnimation *ani=[CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef aPath=CGPathCreateMutable();
    //动画起始点
    CGPathMoveToPoint(aPath,nil,_iv.frame.origin.x,_iv.frame.origin.y);
    CGPathAddCurveToPoint(aPath,nil,160,30,220,220,240,280);//控制点
    ani.path=aPath;
    CGPathRelease(aPath);
    ani.duration=3;
    ani.repeatCount=HUGE_VALF;
    //设置为渐出
    ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //自动旋转方向
    ani.rotationMode=@"auto";
    [self.view addSubview:redView];
    [redView.layer addAnimation:ani forKey:@"position"];
    
    UIImage* __block my_Image=[[UIImage alloc] init];
    
    if(_edited!=nil)
    {
        dispatch_queue_t queue = dispatch_queue_create("cn.mx.mxbeautyphoto", NULL);
        dispatch_async(queue, ^ {
            UIImage* inImage=_edited;
            unsigned char* imgPixel = RequestImagePixelData(inImage);
            CGImageRef inImageRef = [inImage CGImage];
            size_t w = CGImageGetWidth(inImageRef);
            size_t h = CGImageGetHeight(inImageRef);
            int wOff = 0;
            int pixOff = 0;
            int* redV=malloc(sizeof(int)*h*w);
            int* greenV=malloc(sizeof(int)*h*w);
            int* blueV=malloc(sizeof(int)*h*w);
            
            //双层循环按照长宽的像素个数迭代每个像素点
            for(GLuint y=0;y<h;y++)
            {
                pixOff = wOff;
                for(GLuint x=0;x<w;x++)
                {
                    *(redV+y*w+x) = (unsigned char)imgPixel[pixOff];
                    *(greenV+y*w+x) = (unsigned char)imgPixel[pixOff+1];
                    *(blueV+y*w+x) = (unsigned char)imgPixel[pixOff+2];
                    //alpha not use,将数组的索引指向下四个元素
                    pixOff += 4;
                }
                wOff+=w*4;
            }
            int d=7;
            imgPixel=filterImage((int*)redV,(int*)greenV,(int*)blueV,w,h,d,imgPixel);
            NSInteger 	dataLength = w*h*4;
            //下面的代码创建要输出的图像的相关参数
            CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,imgPixel,dataLength,NULL);
            int bitsPerComponent = 8;
            int bitsPerPixel = 32;
            long bytesPerRow = 4*w;
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
            
            //创建要输出的图像
            CGImageRef imageRef = CGImageCreate(w,h,bitsPerComponent,bitsPerPixel,bytesPerRow,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
            my_Image = [UIImage imageWithCGImage:imageRef];
            
            CFRelease(imageRef);
            CGColorSpaceRelease(colorSpaceRef);
            CGDataProviderRelease(provider);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_iv setImage:my_Image];
                _edited=my_Image;
                [redView.layer removeAllAnimations];
                [redView removeFromSuperview];
                redView=nil;
            });
        });
    }
    else
    {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"" message:@"请添加照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
