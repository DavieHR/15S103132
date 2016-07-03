//
//  loadViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loadViewController.h"
#import "User+CoreDataProperties.h"

#define MOC [coreManager sharedManager].managedObjectContext

@interface loadViewController ()

@end

@implementation loadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect loginRect=CGRectMake(50, 100, 275, 200);
    _loginView=[[loginView alloc] initWithFrame:loginRect];
    _loginView.layer.borderWidth=1;
    _loginView.layer.borderColor=[[UIColor blackColor] CGColor];
    [self.view addSubview:_loginView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(130, 350, 100, 50)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button titleLabel].font=[UIFont systemFontOfSize:22];
    [button addTarget:self action:@selector(doLog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(130, 450, 100, 50)];
    [button1 setTitle:@"返回" forState:UIControlStateNormal];
    [button1 titleLabel].font=[UIFont systemFontOfSize:22];
    [button1 addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didLogin:(nameblock)block
{
    _nblock=block;
}

-(void)doLog
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"User" inManagedObjectContext:MOC];
    [request setEntity:entity];
    NSPredicate* predict=[NSPredicate predicateWithFormat:@"name = %@",_loginView.namet.text];
    if(predict)
        [request setPredicate:predict];
    NSError* err=nil;
    NSArray* res=[MOC executeFetchRequest:request error:&err];
    unsigned long i=[res count];
    for(User* u in res)
    {
        NSLog(@"%@,%@",u.name,u.psw);
    }
    if(i==0)
    {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户不存在，请注册后登录。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _loginView.passt.text=@"";
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        User* u=[res objectAtIndex:0];
        if(_loginView.passt.text==u.psw)
        {
            if(_nblock)
                _nblock(_loginView.namet.text);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误，请重新输入。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _loginView.passt.text=@"";
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(IBAction)del
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *result = [MOC executeFetchRequest:request error:nil];
    for(User *u in result)
        [MOC deleteObject:u];
}

//-(IBAction)select
//{
//    NSFetchRequest* request=[[NSFetchRequest alloc] init];
//    NSEntityDescription* entity=[NSEntityDescription entityForName:@"User" inManagedObjectContext:MOC];
//    [request setEntity:entity];
//    NSPredicate* predict=[NSPredicate predicateWithFormat:@"name = %@",_tfn.text];
//    if(predict)
//        [request setPredicate:predict];
//    NSError* err=nil;
//    NSArray* res=[MOC executeFetchRequest:request error:&err];
//    for(User *u in res)
//        NSLog(@"%@,%@",u.name,u.psw);
//}
//
//-(IBAction)insert
//{
//    User* user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:MOC];
//    user.name=_tfn.text;
//    user.psw=_tfp.text;
//    [[coreManager sharedManager] saveContext];
//}

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
