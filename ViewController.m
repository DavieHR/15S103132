//ÐÞ¸Ä4
//
//  ViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/16.
//  Copyright Â© 2016å¹?apple. All rights reserved.
//

#import "ViewController.h"

@interface mxViewController ()
{
    NSTimer* timer;
    UILabel* timelabel;
}

@end

@implementation mxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changebg:) name:@"changeBG" object:nil];
    
    _bg=[UIImage imageNamed:@"main.jpg"];
    self.view.layer.contents=(id)_bg.CGImage;
    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
    // Do any additional setup after loading the view, typically from a nib.
    CGRect labelrect=CGRectMake(270, 20, 80, 30);
    timelabel=[[UILabel alloc] initWithFrame:labelrect];
    timelabel.font=[UIFont fontWithName:@"Helvetica" size:20];
    timelabel.textColor=[UIColor grayColor];
    [self.view addSubview:timelabel];
    [self performSelectorInBackground:@selector(showTime) withObject:nil];
    
    UIStoryboard* sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _fvc=[sb instantiateViewControllerWithIdentifier:@"firstvc"];
    _svc=[sb instantiateViewControllerWithIdentifier:@"secondvc"];
    _tvc=[sb instantiateViewControllerWithIdentifier:@"thirdvc"];
    _frvc=[sb instantiateViewControllerWithIdentifier:@"fourthvc"];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    
    _sidebarVC=[[mxSideViewController alloc] init];
    [_sidebarVC setBgRGB:0x000000];
    [self.view addSubview:_sidebarVC.view];
    _sidebarVC.view.frame  = self.view.bounds;
    
    [_sidebarVC didSelectRowAtIndexPath:^(NSIndexPath *indexPath) {
        if(indexPath.row==0)
        {
            [self.navigationController pushViewController:_fvc animated:YES];
        }
        else if(indexPath.row==1)
        {
            [self.navigationController pushViewController:_svc animated:YES];
        }
        else if(indexPath.row==2)
        {
            [self.navigationController pushViewController:_tvc animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_frvc animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _bg=change[@"bg"];
    self.view.layer.contents=(id)_bg.CGImage;
    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
}

-(void)changebg:(NSNotification*)notification
{
    _bg=[notification object];
    self.view.layer.contents=(id)_bg.CGImage;
    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
}

-(void)showTime
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

-(void)updateTime
{
    @autoreleasepool
    {
        NSDateFormatter* df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        NSString* timestamp=[df stringFromDate:[NSDate date]];
        [timelabel setText:timestamp];
    }
}

- (IBAction)show
{
    [_sidebarVC showHideSidebar];
}

-(IBAction)login
{
    UIStoryboard* sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    loadViewController* lvc=[sb instantiateViewControllerWithIdentifier:@"loadvc"];
    lvc.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:lvc animated:YES completion:nil];
    [lvc didLogin:^(NSString *username) {
        NSString* welcome=[NSString stringWithFormat:@"æ¬¢è¿Žæ‚? "];
        welcome=[welcome stringByAppendingString:username];
        _l.text=welcome;
        [_b setHidden:YES];
        [_r setHidden:YES];
    }];
}

-(IBAction)reg
{
    UIStoryboard* sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    registerViewController* rvc=[sb instantiateViewControllerWithIdentifier:@"registervc"];
    rvc.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:rvc animated:YES completion:nil];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [_sidebarVC panDetected:recoginzer];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
