//
//  mxSideViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "mxSideViewController.h"

@interface mxSideViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation mxSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rl=CGRectMake(0,0,self.contentView.bounds.size.width,80);
    self.infoLabel=[[UILabel alloc] initWithFrame:rl];
    self.infoLabel.text=@"M&X";
    self.infoLabel.textColor=[UIColor whiteColor];
    self.infoLabel.backgroundColor=[UIColor grayColor];
    self.infoLabel.textAlignment=NSTextAlignmentCenter;
    
    CGRect ml=CGRectMake(0,100,self.contentView.bounds.size.width,self.contentView.bounds.size.height-80);
    self.menuTableView = [[UITableView alloc] initWithFrame:ml];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.menuTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSelectRowAtIndexPath:(didSelectRowAtIndexPath)didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = didSelectRowAtIndexPath;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* path=[[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    NSArray* list=[NSArray arrayWithContentsOfFile:path];
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* plist=[[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    NSMutableArray* menuDic=[[NSMutableArray alloc] initWithContentsOfFile:plist];
    NSString* menu=[menuDic objectAtIndex:indexPath.row];
    
    static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = menu;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_didSelectRowAtIndexPath)
        _didSelectRowAtIndexPath(indexPath);
    
    [self showHideSidebar];
    
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
