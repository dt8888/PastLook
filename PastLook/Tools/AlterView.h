//
//  AlterView.h
//  PastLook
//
//  Created by DT on 2019/4/19.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlterView : UIView
@property(nonatomic,strong)UIView *bGView;
-(instancetype)initWithShareRegistHeight:(NSString*)title;
@property(copy,nonatomic)void (^ButtonClick)(NSString*);
@end

NS_ASSUME_NONNULL_END
