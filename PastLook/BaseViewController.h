//
//  BaseViewController.h
//  技师外快宝
//
//  Created by DT on 2019/3/11.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
-(void)setTitle:(NSString *)title;
-(void)setLeftButton:(NSString*)imgStr;
-(void)tapRightBtn;
-(void)cancelSideBack;
-(void)startSideBack;
-(void)prsentToLoginViewController;
-(void)setRightButton:(NSString *)imageStr;
@end

NS_ASSUME_NONNULL_END
