//
//  AlterView.m
//  PastLook
//
//  Created by DT on 2019/4/19.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "AlterView.h"
#import "MyUtility.h"
#import "UIViewExt.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//获取屏幕宽度
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
@implementation AlterView
{
    UIView *bgView;
}
-(instancetype)initWithShareRegistHeight:(NSString*)title {
    // 大背景
    self=[super init];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.3;
            [window addSubview:view];
            self.bGView =view;
        }
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        self.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [window addSubview:self];
//   self.bGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.bGView];
//    self.bGView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    
    UIView *alterView = [[UIView alloc]initWithFrame:CGRectMake(40, (kScreenHeight-180)/2, kScreenWidth-80, 170)];
    alterView.backgroundColor = [UIColor whiteColor];
     alterView.clipsToBounds = YES;
        alterView.layer.cornerRadius = 5;
    [self addSubview:alterView];
    
    UILabel *titleLabel = [MyUtility createLabelWithFrame:CGRectMake(0 ,0, kScreenWidth-80, 55) title:@"提醒" textColor:RGB(150, 150, 150) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter numberOfLines:0];
    titleLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    [alterView addSubview:titleLabel];
    
    UIView *grayLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0 ,titleLabel.bottom, kScreenWidth-80, 1)];
    [alterView addSubview:grayLineView1];
    grayLineView1.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    UILabel *textLabel = [MyUtility createLabelWithFrame:CGRectMake(0 ,grayLineView1.bottom, kScreenWidth-80, 55) title:@"没有搜索到任何设备" textColor:RGB(150, 150, 150) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [alterView addSubview:textLabel];
    
    UIView *grayLineView2 = [[UIView alloc]initWithFrame:CGRectMake(0 ,textLabel.bottom, kScreenWidth-80, 1)];
    [alterView addSubview:grayLineView2];
    grayLineView2.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    UIButton *posswordBtn = [MyUtility createButtonWithFrame:CGRectMake(0 ,grayLineView2.bottom, kScreenWidth-80, 55) title:@"知道了" textColor:RGB(16, 180, 241) imageName:@"" target:self action:@selector(gotoPossword) isCorner:NO isDriction:4];
    posswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [alterView addSubview:posswordBtn];
    }
    return self;
}
-(void)gotoPossword{
    [self hide:YES];
}
- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak AlterView *weakSelf = self;
        [UIView animateWithDuration: animated ?0.3: 0 animations:^{
        } completion:^(BOOL finished) {
            [weakSelf.bGView removeFromSuperview];
            [weakSelf removeFromSuperview];
            weakSelf.bGView=nil;
        }];
    }
}
@end
