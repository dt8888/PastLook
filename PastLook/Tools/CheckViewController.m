//
//  CheckViewController.m
//  QuickIdentificationDiagram
//
//  Created by DT on 2019/4/18.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "CheckViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "WHToast.h"
#import "MyUtility.h"
#import "IHUtility.h"
#import "UIViewExt.h"
#import "DetailInfoViewController.h"
#define KIsiPhoneX ([UIScreen mainScreen].bounds.size.height>800.0f)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//获取屏幕宽度
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
@interface CheckViewController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) JPImageresizerView *imageresizerView;
@end

@implementation CheckViewController
{
        // 默认的识别成功的回调
        void (^_successHandler)(id);
        // 默认的识别失败的回调
        void (^_failHandler)(NSError *);
    CGFloat topY;
    CGFloat bottomY;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self startSideBack];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self cancelSideBack];
}
- (void)viewDidLoad {
    [super viewDidLoad];
      topY = 64;
    bottomY = 50;
    if(KIsiPhoneX){
        topY = 88;
        bottomY = 83;
    }
    self.navigationController.navigationBar.barTintColor =RGB(57, 57, 57);
   
//     self.navigationController.delegate = self;
    [self setLeftButton:@"left"];
    self.view.backgroundColor = RGB(57, 57, 57);
    [self createView];
    [self createBottomView];
     [self configCallback];
}
-(void)createView{
    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [[JPImageresizerView alloc]initWithResizeImage:self.showImage frame:CGRectMake(20, 64+15,  kScreenWidth-40,kScreenHeight-bottomY-topY-30) maskType:JPNormalMaskType frameType:JPClassicFrameType animationCurve:JPAnimationCurveEaseInOut strokeColor:[UIColor whiteColor] bgColor:[UIColor clearColor] maskAlpha:1 verBaseMargin:2 horBaseMargin:2 resizeWHScale:0 contentInsets:UIEdgeInsetsMake(0, 0, 0, 0) imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
            if (!sSelf) return;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
            if (!sSelf) return;
    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    self.configure = nil;
}

//
-(void)createBottomView{
    NSArray *titleArray = @[@"重置",@"旋转",@"识别"];
     NSArray *imageArray = @[@"reset",@"roate",@"iden"];
    for(int i=0;i<titleArray.count;i++){
        for(int i=0;i<titleArray.count;i++){
            UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(i*(kScreenWidth)/3,kScreenHeight-bottomY, (kScreenWidth)/3, bottomY)];
            tapView.tag = 100+i;
            [tapView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:tapView];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(((kScreenWidth)/3-26)/2, 5, 26, 26)];
            img.image = [UIImage imageNamed:imageArray[i]];
            img.userInteractionEnabled = YES;
            [tapView addSubview:img];
            UILabel *text = [MyUtility createLabelWithFrame:CGRectMake(0 ,img.bottom+4, (kScreenWidth)/3, 16) title:titleArray[i] textColor:RGB(165, 173, 189) font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter numberOfLines:0];
            [tapView addSubview:text];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap:)];
            [tapView addGestureRecognizer:tap];
        }
    }
}
-(void)selectTap:(UITapGestureRecognizer*)tap{
    NSInteger flag = tap.view.tag-100;
    if(flag==0){
        [self.imageresizerView recovery];
    }else if (flag==1){
         [self.imageresizerView rotation];
    }else if (flag==2){
        [IHUtility addWaitingView:@"识别中..."];
        if(self.isIdCard){
            
        }else
        {
            //识别图片
            [[AipOcrService shardService] detectWebImageFromImage:self.showImage
                                                      withOptions:nil
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];
        }
       
    }
}
//识别结果
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
       
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [IHUtility removeWaitingView];
            DetailInfoViewController *detailVC = [[DetailInfoViewController alloc]init];
            detailVC.resultStr = message;
            detailVC.flag = 100;
            detailVC.showImage = weakSelf.showImage;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }];
    };
    
    _failHandler = ^(NSError *error){
         [IHUtility removeWaitingView];
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [WHToast showMessage:msg  duration:1 finishHandler:^{
            }];
        }];
    };
}

#pragma UINavigationControllerDelegate方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
@end
