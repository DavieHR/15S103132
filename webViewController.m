//
//  webViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "webViewController.h"
#import "mxdata.h"

#define ROW_COUNT 3
#define COLUMN_COUNT 3
#define ROW_WIDTH 100
#define ROW_HEIGHT 180
#define CELL_WSPACING 15
#define CELL_HSPACING 20

@interface webViewController ()

@end

@implementation webViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(20,10,40,30)];
    //[back setBackgroundColor:[UIColor grayColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UILabel* tip=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 10)];
    tip.textAlignment=NSTextAlignmentCenter;
    tip.font=[UIFont systemFontOfSize:12];
    tip.text=@"点击图片可设为主页背景哦^_^";
    tip.textColor=[UIColor whiteColor];
    [self.view addSubview:tip];
    
    NSString* path=[[NSBundle mainBundle] pathForResource:@"photoUrl" ofType:@"plist"];
    _list=[NSArray arrayWithContentsOfFile:path];
    
    [self layoutUI];
    [self loadImageWithMultiThread];
}

#pragma mark 界面布局
-(void)layoutUI
{
    _ivs=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++)
    {
        for (int c=0; c<COLUMN_COUNT; c++)
        {
            UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20+c*(ROW_WIDTH+CELL_WSPACING), 60+r*(ROW_HEIGHT+CELL_HSPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.backgroundColor=[UIColor grayColor];
            imageView.userInteractionEnabled = YES;
            [self.view addSubview:imageView];
            [_ivs addObject:imageView];
        }
    }
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread
{
    for(int i=0;i<ROW_COUNT*COLUMN_COUNT;i++)
    {
        //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%d",i];
        //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
        [thread start];
    }
}

-(void)loadImage:(NSNumber*)index
{
    NSInteger i=[index integerValue];
    NSData* data= [self requestData:i];
    mxdata *imageData=[[mxdata alloc]init];
    imageData.i=i;
    imageData.data=data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

#pragma mark 将图片显示到界面
-(void)updateImage:(mxdata*)imageData{
    UIImage *image=[UIImage imageWithData:imageData.data];
    UIImageView* imageView= _ivs[imageData.i];
    imageView.image=image;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
}


-(void)clickCategory:(UITapGestureRecognizer*)recognizer
{
    UIImageView* viewClicked=[recognizer view];
    NSLog(@"%f,%f",viewClicked.frame.origin.x,viewClicked.frame.origin.y);
    //notification通知主界面更换背景图片
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBG" object:viewClicked.image];
}


#pragma mark 请求图片数据
-(NSData *)requestData:(NSInteger)index
{
    //对于多线程操作建议把线程操作放到@autoreleasepool中
    @autoreleasepool {
        NSString* listi=[_list objectAtIndex:index];
        NSURL *url=[NSURL URLWithString:listi];
        NSData *data=[NSData dataWithContentsOfURL:url];
        return data;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
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
