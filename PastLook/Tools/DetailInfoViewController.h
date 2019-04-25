//
//  DetailInfoViewController.h
//  QuickIdentificationDiagram
//
//  Created by DT on 2019/4/20.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfoViewController : BaseViewController
@property(nonatomic,strong)NSString *resultStr;
@property (nonatomic, strong) UIImage *showImage;
@property(nonatomic,assign)int flag;
@end

NS_ASSUME_NONNULL_END
