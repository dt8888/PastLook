//
//  LaunchPageView.m
//  PastLook
//
//  Created by DT on 2019/4/22.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "LaunchPageView.h"
#import "MyUtility.h"
#import "UIViewExt.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//获取屏幕宽度
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
@implementation LaunchPageView
{
     CGFloat navHight;
}
- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = [UIColor whiteColor];
        
             UIImage *image = [UIImage imageNamed:@"log.jpg"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, (kScreenHeight-60)/2-50,60 , 60)];
                imageView.image = image;
                [self addSubview:imageView];
        
        UILabel *text = [MyUtility createLabelWithFrame:CGRectMake(20 ,imageView.bottom+20, kScreenWidth-40,20) title:@"鱼缸智能控制器" textColor:RGB(57, 57, 57) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter numberOfLines:0];
        [self addSubview:text];
        
      [self performSelector:@selector(moveCoordinate) withObject:nil afterDelay:4];
    }
    return self;
}
- (void)moveCoordinate
{
    /*
     (void)animateWithDuration:(NSTimeInterval)duration
     delay:(NSTimeInterval)delay
     options:(UIViewAnimationOptions)options
     animations:(void (^)(void))animations
     completion:(void (^)(BOOL finished))completion
     duration为动画持续的时间。
     animations为动画效果的代码块。
     completion为动画执行完毕以后执行的代码块
     options为动画执行的选项。
     delay为动画开始执行前等待的时间
     下面是可以设置动画效果的属性：
     frame
     bounds
     center
     transform
     alpha
     backgroundColor
     contentStretch
     
     1.例如一个视图淡出屏幕，另外一个视图出现的代码：
     [UIView animateWithDuration:1.0 animations:^{
     firstView.alpha = 0.0;
     secondView.alpha = 1.0;
     }];
     */
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
    }];
    // removeFromSuperviewz:
    // (Unlinks the receiver from its superview and its window, and removes it from the responder chain.
    // 译：把当前view从它的父view和窗口中移除，同时也把它从响应事件操作的响应者链中移除)
}
@end
