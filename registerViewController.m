//
//  registerViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "registerViewController.h"
#import "User+CoreDataProperties.h"

#define MOC [coreManager sharedManager].managedObjectContext

@interface registerViewController ()

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect loginRect=CGRectMake(50, 100, 275, 300);
    _regView=[[registerView alloc] initWithFrame:loginRect];
    _regView.layer.borderWidth=1;
    _regView.layer.borderColor=[[UIColor blackColor] CGColor];
    [self.view addSubview:_regView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(130, 450, 100, 50)];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button titleLabel].font=[UIFont systemFontOfSize:22];
    [button addTarget:self action:@selector(doReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(130, 550, 100, 50)];
    [button1 setTitle:@"返回" forState:UIControlStateNormal];
    [button1 titleLabel].font=[UIFont systemFontOfSize:22];
    [button1 addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doReg
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"User" inManagedObjectContext:MOC];
    [request setEntity:entity];
    NSPredicate* predict=[NSPredicate predicateWithFormat:@"name = %@",_regView.namet.text];
    if(predict)
        [request setPredicate:predict];
    NSError* err=nil;
    NSArray* res=[MOC executeFetchRequest:request error:&err];
    unsigned long i=[res count];
    if(i!=0)
    {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户已存在。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _regView.passt.text=@"";
            _regView.suret.text=@"";
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        User* user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:MOC];
        if([_regView.namet.text isEqual:@""]||[_regView.passt.text isEqual:@""]||[_regView.suret.text isEqual:@""])
        {
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名密码。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _regView.passt.text=@"";
                _regView.suret.text=@"";
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            if(_regView.passt.text!=_regView.suret.text)
            {
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致，请重新输入。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _regView.passt.text=@"";
                    _regView.suret.text=@"";
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                user.name=_regView.namet.text;
                user.psw=_regView.passt.text;
                [[coreManager sharedManager] saveContext];
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
