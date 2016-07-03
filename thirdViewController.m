//
//  thirdViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "thirdViewController.h"

@interface thirdViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation thirdViewController

-(void)loadView
{
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0,0,375,667)];
    self.view=view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
    
    UIStoryboard* sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _wvc=[sb instantiateViewControllerWithIdentifier:@"webvc"];
    _nvc=[sb instantiateViewControllerWithIdentifier:@"notifyvc"];
    _ivc=[sb instantiateViewControllerWithIdentifier:@"iovc"];
    _ovc=[sb instantiateViewControllerWithIdentifier:@"openvc"];
    _cvc=[sb instantiateViewControllerWithIdentifier:@"cavc"];
    
    NSString* file=[[NSBundle mainBundle] pathForResource:@"table" ofType:@"plist"];
    _list=[NSArray arrayWithContentsOfFile:file];
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(20,10,40,30)];
    //[back setBackgroundColor:[UIColor grayColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

-(void)viewWillAppear:(BOOL)animated
{
    _tv=[[UITableView alloc] initWithFrame:CGRectMake(0,50,self.view.bounds.size.width,self.view.bounds.size.height-50)];
    _tv.delegate=self;
    _tv.dataSource=self;
    [self.view addSubview:_tv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid=@"cellid";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    NSUInteger row=[indexPath row];
    cell.detailTextLabel.text=@">";
    cell.textLabel.text=[_list objectAtIndex:row];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
            [self.navigationController pushViewController:_wvc animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:_cvc animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:_nvc animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:_ivc animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:_ovc animated:YES];
            break;
        default:
            break;
    }
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
