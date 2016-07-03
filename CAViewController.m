//
//  CAViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/23.
//  Copyright © 2016�?apple. All rights reserved.
//
// change1
#import "CAViewController.h"

@interface CAViewController ()

@end

@implementation CAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(20,10,40,30)];
    //[back setBackgroundColor:[UIColor grayColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    NSLog(@"ca");
    [self.navigationController popViewControllerAnimated:YES];
}

-(bool)prefersStatusBarHidden
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
