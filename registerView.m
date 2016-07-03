// �޸�1

//
//  registerView.m
//  mxphotoshop
//
//  Created by star on 16/6/20.
//  Copyright © 2016�?apple. All rights reserved.
//

#import "registerView.h"

@implementation registerView

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
        _sure=[[UILabel alloc]init];
        [_name setText:@"用户�?"];
        [_pass setText:@"密码:"];
        [_sure setText:@"确认:"];
        _name.textAlignment=NSTextAlignmentCenter;
        _pass.textAlignment=NSTextAlignmentCenter;
        _sure.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_name];
        [self addSubview:_pass];
        [self addSubview:_sure];
        
        _namet=[[textFieldView alloc] init];
        _passt=[[textFieldView alloc] init];
        _suret=[[textFieldView alloc] init];
        _namet.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.05];
        _passt.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.05];
        _suret.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.05];
        [self addSubview:_namet];
        [self addSubview:_passt];
        [self addSubview:_suret];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    _name.frame=CGRectMake(0, h/12, w/3, h/6);
    _namet.frame=CGRectMake(w/3, h/12, w/2, h/6);
    _pass.frame=CGRectMake(0, 5*h/12, w/3, h/6);
    _passt.frame=CGRectMake(w/3, 5*h/12, w/2, h/6);
    _sure.frame=CGRectMake(0, 9*h/12, w/3, h/6);
    _suret.frame=CGRectMake(w/3, 9*h/12, w/2, h/6);
}


@end
