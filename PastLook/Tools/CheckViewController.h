//
//  CheckViewController.h
//  QuickIdentificationDiagram
//
//  Created by DT on 2019/4/18.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "JPImageresizerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CheckViewController : BaseViewController
@property (nonatomic, strong) JPImageresizerConfigure *configure;
@property (nonatomic, strong) UIImage *showImage;
@property(nonatomic,assign)BOOL isIdCard;
@end

NS_ASSUME_NONNULL_END
