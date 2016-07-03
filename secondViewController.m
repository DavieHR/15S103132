//
//  secondViewController.m
//  mxphotoshop
//
//  Created by star on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WXApi.h"
#import "WXApiObject.h"

#import "secondViewController.h"

@interface secondViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation secondViewController

static NSMutableArray *colors;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    colors=[[NSMutableArray alloc]initWithObjects:[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor grayColor],[UIColor blackColor],nil];
    CGRect viewFrame=CGRectMake(0,50,self.view.bounds.size.width,500);
    _buttonHidden=YES;
    _widthHidden=YES;
    
    _iv=[[UIImageView alloc] initWithFrame:viewFrame];
    [self.view addSubview:_iv];
    
    _drawView=[[drawView alloc]initWithFrame:viewFrame];
//    _drawView.layer.borderWidth=1;
//    _drawView.layer.borderColor=[UIColor grayColor].CGColor;
    _drawView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_drawView];
    [self.view sendSubviewToBack:_drawView];
    [self.view sendSubviewToBack:_iv];

    UIButton* undo=[[UIButton alloc] initWithFrame:CGRectMake(135, 10, 40, 30)];
    [undo setBackgroundImage:[UIImage imageNamed:@"undo.png"] forState:UIControlStateNormal];
    [undo addTarget:self action:@selector(undoImage) forControlEvents:UIControlEventTouchUpInside];
    UIButton* redo=[[UIButton alloc] initWithFrame:CGRectMake(200, 10, 40, 30)];
    [redo setBackgroundImage:[UIImage imageNamed:@"redo.png"] forState:UIControlStateNormal];
    [redo addTarget:self action:@selector(redoImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undo];
    [self.view addSubview:redo];
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(20,10,40,30)];
    //[back setBackgroundColor:[UIColor grayColor]];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIButton* share=[[UIButton alloc] initWithFrame:CGRectMake(325, 10, 40, 30)];
    //[share setBackgroundColor:[UIColor grayColor]];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [self.view addSubview:share];
    
    UIButton* bg=[[UIButton alloc] initWithFrame:CGRectMake(275, 10, 40, 30)];
    //[share setBackgroundColor:[UIColor grayColor]];
    [bg setTitle:@"背景" forState:UIControlStateNormal];
    [bg addTarget:self action:@selector(setBG) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bg];
    
    UIButton* clear=[[UIButton alloc] initWithFrame:CGRectMake(43, 630, 40, 30)];
    //[clear setBackgroundColor:[UIColor grayColor]];
    [clear setTitle:@"清空" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearImage) forControlEvents:UIControlEventTouchUpInside];
    UIButton* save=[[UIButton alloc] initWithFrame:CGRectMake(126, 630, 40, 30)];
    //[save setBackgroundColor:[UIColor grayColor]];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clear];
    [self.view addSubview:save];
    
    _color=[[UIButton alloc] initWithFrame:CGRectMake(209, 630, 40, 30)];
    //[_color setBackgroundColor:[UIColor grayColor]];
    [_color setTitle:@"颜色" forState:UIControlStateNormal];
    [_color addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    _line=[[UIButton alloc] initWithFrame:CGRectMake(292, 630, 40, 30)];
    //[_line setBackgroundColor:[UIColor grayColor]];
    [_line setTitle:@"线条" forState:UIControlStateNormal];
    [_line addTarget:self action:@selector(changeLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_color];
    [self.view addSubview:_line];
    
    _red=[[UIButton alloc] initWithFrame:CGRectMake(27, 580, 30, 30)];
    _yellow=[[UIButton alloc] initWithFrame:CGRectMake(59, 580, 30, 30)];
    _green=[[UIButton alloc] initWithFrame:CGRectMake(91, 580, 30, 30)];
    _blue=[[UIButton alloc] initWithFrame:CGRectMake(123, 580, 30, 30)];
    _purple=[[UIButton alloc] initWithFrame:CGRectMake(155, 580, 30, 30)];
    _gray=[[UIButton alloc] initWithFrame:CGRectMake(187, 580, 30, 30)];
    _black=[[UIButton alloc] initWithFrame:CGRectMake(219, 580, 30, 30)];
    [_red setBackgroundColor:[UIColor redColor]];
    [_yellow setBackgroundColor:[UIColor yellowColor]];
    [_green setBackgroundColor:[UIColor greenColor]];
    [_blue setBackgroundColor:[UIColor blueColor]];
    [_purple setBackgroundColor:[UIColor purpleColor]];
    [_black setBackgroundColor:[UIColor whiteColor]];
    [_gray setBackgroundColor:[UIColor grayColor]];
    [_red addTarget:self action:@selector(colorSet1) forControlEvents:UIControlEventTouchUpInside];
    [_yellow addTarget:self action:@selector(colorSet2) forControlEvents:UIControlEventTouchUpInside];
    [_green addTarget:self action:@selector(colorSet3) forControlEvents:UIControlEventTouchUpInside];
    [_blue addTarget:self action:@selector(colorSet4) forControlEvents:UIControlEventTouchUpInside];
    [_purple addTarget:self action:@selector(colorSet5) forControlEvents:UIControlEventTouchUpInside];
    [_gray addTarget:self action:@selector(colorSet6) forControlEvents:UIControlEventTouchUpInside];
    [_black addTarget:self action:@selector(colorSet7) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_red];
    [self.view addSubview:_yellow];
    [self.view addSubview:_green];
    [self.view addSubview:_blue];
    [self.view addSubview:_purple];
    [self.view addSubview:_black];
    [self.view addSubview:_gray];
    _red.hidden=YES;
    _yellow.hidden=YES;
    _green.hidden=YES;
    _blue.hidden=YES;
    _purple.hidden=YES;
    _gray.hidden=YES;
    _black.hidden=YES;
    
    _s=[[UIButton alloc] initWithFrame:CGRectMake(270, 580, 30, 30)];
    _m=[[UIButton alloc] initWithFrame:CGRectMake(302, 580, 30, 30)];
    _l=[[UIButton alloc] initWithFrame:CGRectMake(334, 580, 30, 30)];
    [_s setTitle:@"细" forState:UIControlStateNormal];
    [_m setTitle:@"中" forState:UIControlStateNormal];
    [_l setTitle:@"粗" forState:UIControlStateNormal];
    //[_s setBackgroundColor:[UIColor grayColor]];
    //[_m setBackgroundColor:[UIColor grayColor]];
    //[_l setBackgroundColor:[UIColor grayColor]];
    [_s addTarget:self action:@selector(lineSet1) forControlEvents:UIControlEventTouchUpInside];
    [_m addTarget:self action:@selector(lineSet2) forControlEvents:UIControlEventTouchUpInside];
    [_l addTarget:self action:@selector(lineSet3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_s];
    [self.view addSubview:_m];
    [self.view addSubview:_l];
    _s.hidden=YES;
    _m.hidden=YES;
    _l.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)undoImage
{
    [_drawView revocation];
}

-(void)redoImage
{
    [_drawView refrom];
}

-(void)setBG
{
    UIImagePickerController* picker=[[UIImagePickerController alloc] init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* bgimage=[info objectForKey:UIImagePickerControllerEditedImage];
    _iv.frame=CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.width);
    [_iv setImage:bgimage];
    _drawView.frame=CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.width);
    [_drawView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
}

-(void)shareImage
{
    UIGraphicsBeginImageContext(_drawView.bounds.size);
    [_iv.layer renderInContext:UIGraphicsGetCurrentContext()];
    [_drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    WXMediaMessage* message=[WXMediaMessage message];
    [message setThumbImage:image];
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
-(void)clearImage
{
    [_drawView clear];
}

-(void)saveImage
{
    UIGraphicsBeginImageContext(_drawView.bounds.size);
    [_iv.layer renderInContext:UIGraphicsGetCurrentContext()];
    [_drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image,self,nil,nil);
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"成功保存为相册图片。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)changeColor
{
    if(_buttonHidden==YES)
    {
        _red.hidden=NO;
        _yellow.hidden=NO;
        _green.hidden=NO;
        _blue.hidden=NO;
        _purple.hidden=NO;
        _gray.hidden=NO;
        _black.hidden=NO;
        _buttonHidden=NO;
    }
    else
    {
        _red.hidden=YES;
        _yellow.hidden=YES;
        _green.hidden=YES;
        _blue.hidden=YES;
        _purple.hidden=YES;
        _gray.hidden=YES;
        _black.hidden=YES;
        _buttonHidden=YES;
    }
}

-(void)changeLine
{
    if(_widthHidden==YES)
    {
        _s.hidden=NO;
        _m.hidden=NO;
        _l.hidden=NO;
        _widthHidden=NO;
    }
    else
    {
        _s.hidden=YES;
        _m.hidden=YES;
        _l.hidden=YES;
        _widthHidden=YES;
    }
}

-(void)colorSet1
{
    [_drawView setLineColor:0];
    [_color setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:0];
}
-(void)colorSet2
{
    [_drawView setLineColor:1];
    [_color setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:1];
}
-(void)colorSet3
{
    [_drawView setLineColor:2];
    [_color setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:2];
}
-(void)colorSet4
{
    [_drawView setLineColor:3];
    [_color setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:3];
}
-(void)colorSet5
{
    [_drawView setLineColor:4];
    [_color setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:4];
}
-(void)colorSet6
{
    [_drawView setLineColor:5];
    [_color setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:5];
}
-(void)colorSet7
{
    [_drawView setLineColor:6];
    [_color setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //_color.backgroundColor=[colors objectAtIndex:6];
}
-(void)lineSet1
{
    [_drawView setlineWidth:0];
    [_line setTitle:@"细" forState:UIControlStateNormal];
}
-(void)lineSet2
{
    [_drawView setlineWidth:1];
    [_line setTitle:@"中" forState:UIControlStateNormal];
}
-(void)lineSet3
{
    [_drawView setlineWidth:2];
    [_line setTitle:@"粗" forState:UIControlStateNormal];
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
