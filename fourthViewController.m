//
//  fourthViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WXApi.h"
#import "WXApiObject.h"

#import "fourthViewController.h"

#import "MSImagePickerController.h"
#import <QuickLook/QLPreviewController.h>

@interface fourthViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MSImagePickerControllerDelegate,UIScrollViewDelegate>

@end

@implementation fourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
    
    _longphoto=[[UIImage alloc] init];
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(20,10,40,30)];
    //[back setBackgroundColor:[UIColor grayColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton* share=[[UIButton alloc] initWithFrame:CGRectMake(325, 10, 40, 30)];
    //[share setBackgroundColor:[UIColor grayColor]];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    
    UIButton* choose=[[UIButton alloc] initWithFrame:CGRectMake(20, 600, 40, 30)];
    //[share setBackgroundColor:[UIColor grayColor]];
    [choose setTitle:@"添加" forState:UIControlStateNormal];
    [choose addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choose];
    
    UIButton* del=[[UIButton alloc] initWithFrame:CGRectMake(325, 600, 40, 30)];
    //[share setBackgroundColor:[UIColor grayColor]];
    [del setTitle:@"保存" forState:UIControlStateNormal];
    [del addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:del];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveImage
{
    UIImageWriteToSavedPhotosAlbum([_iv image],self,@selector(showSave:didSavingWithError:contextInfo:),NULL);
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

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareImage
{
    UIGraphicsBeginImageContext(_iv.bounds.size);
    NSLog(@"%f,%f",_iv.bounds.size.width,_iv.bounds.size.height);
    [_iv.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    WXMediaMessage* message=[WXMediaMessage message];
    //[message setThumbImage:image];
    WXImageObject* imageObject=[WXImageObject object];
    NSData* d=UIImagePNGRepresentation(image);
    imageObject.imageData=d;
    message.mediaObject=imageObject;
    
    SendMessageToWXReq* req=[[SendMessageToWXReq alloc] init];
    req.bText=NO;
    req.message=message;
    req.scene=WXSceneSession;
    [WXApi sendReq:req];
}

- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *)picker; // 选择的图片超过上限的时候调用
{
    NSString* message = [NSString stringWithFormat:@"你最多只能选择%ld张图片。", picker.maxImageCount];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return _photolist.count;
}

-(void)chooseImage
{
    MSImagePickerController* picker = [[MSImagePickerController alloc] init];
    picker.msDelegate = self;
    picker.maxImageCount = 3;
    picker.doneButtonTitle = @"OK";
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(MSImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerdidFinish:(MSImagePickerController *)picker {
    _photolist=[NSMutableArray arrayWithArray:picker.images];
    [picker dismissViewControllerAnimated:true completion:^{
        @autoreleasepool
        {
            [_iv removeFromSuperview];
            _iv=nil;
            for(int i=0;i<[_photolist count];i++)
            {
                UIImage* img=[_photolist objectAtIndex:i];
                img=[self scaleToSize:img size:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.width)];
                if(i==0)
                    _longphoto=img;
                else
                {
                    _longphoto=[self combine:_longphoto :img];
                }
                NSLog(@"%f,%f",_longphoto.size.width,_longphoto.size.height);
            }
        
            _backScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,50,_longphoto.size.width,500)];
            [_backScrollView setContentSize:_longphoto.size];
            [_backScrollView setShowsHorizontalScrollIndicator:NO];
            [_backScrollView setShowsVerticalScrollIndicator:NO];
            _backScrollView.delegate = self;
            _iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,50,_longphoto.size.width,_longphoto.size. height)];
            _iv.image = _longphoto;
            [_backScrollView addSubview:_iv];
            [self.view addSubview:_backScrollView];
        }
    }];
}

-(UIImage *)combine:(UIImage*)up :(UIImage*)down
{
    CGFloat width = up.size.width ;
    CGFloat height = up.size.height+down.size.height;
    CGSize offScreenSize = CGSizeMake(width,height);
    UIGraphicsBeginImageContext(offScreenSize);
    [up drawInRect:CGRectMake(0, 0, up.size.width, up.size.height)];
    [down drawInRect:CGRectMake(0, up.size.height, down.size.width, down.size.height)];
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imagez;
}

-(UIImage*)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(size.width,size.width*img.size.height/img.size.width));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.width*img.size.height/img.size.width)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}

-(void)imagePickerMutilSelectorDidGetImages:(NSArray *)imageArray
{
    _photolist=[[NSMutableArray alloc] initWithArray:imageArray copyItems:YES];
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
