//
//  loginView.m
//  mxphotoshop
//
//  Created by star on 16/6/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loginView.h"

@implementation loginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        _name=[[UILabel alloc]init];
        _pass=[[UILabel alloc]init];
        [_name setText:@"用户名:"];
        [_pass setText:@"密码:"];
        _name.textAlignment=NSTextAlignmentCenter;
        _pass.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_name];
        [self addSubview:_pass];
        
        _namet=[[textFieldView alloc] init];
        _passt=[[textFieldView alloc] init];
        _namet.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.05];
        _passt.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.05];
        [self addSubview:_namet];
        [self addSubview:_passt];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    _name.frame=CGRectMake(0, h/8, w/3, h/4);
    _namet.frame=CGRectMake(w/3, h/8, w/2, h/4);
    _pass.frame=CGRectMake(0, 5*h/8, w/3, h/4);
    _passt.frame=CGRectMake(w/3, 5*h/8, w/2, h/4);
}

@end
