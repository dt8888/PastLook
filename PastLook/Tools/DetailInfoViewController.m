//
//  DetailInfoViewController.m
//  QuickIdentificationDiagram
//
//  Created by DT on 2019/4/20.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "WHToast.h"
#import "MyUtility.h"
#import "IHUtility.h"
#import "UIViewExt.h"
#import <Social/Social.h>
#define KIsiPhoneX ([UIScreen mainScreen].bounds.size.height>800.0f)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//获取屏幕宽度
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
@interface DetailInfoViewController ()

@end

@implementation DetailInfoViewController
{
    UIScrollView *_bgView;
    CGFloat topY ;
    CGFloat bottomY;
    UIScrollView*_imageView;
    int userSum;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userSum = 0;
    //保存本地图片
    NSMutableArray *thisData = [[NSMutableArray alloc]init];
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentTime = [dateday stringFromDate:date];

    topY = 64;
    bottomY = 50;
    if(KIsiPhoneX){
        topY = 88;
        bottomY = 83;
    }
     [self setLeftButton:@"arrow"];
    [self setTitle:@"识别结果"];
    [self createBottomView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-topY-bottomY)];
    _bgView.backgroundColor = RGB(240,240,240);
    [self.view addSubview:_bgView];
    
    _imageView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (kScreenHeight-topY)/2+topY, kScreenWidth, (kScreenHeight-topY)/2-bottomY)];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.hidden = YES;
    [self.view addSubview:_imageView];
    
    CGFloat whScale = self.showImage.size.width / self.showImage.size.height;
    CGFloat w = kScreenWidth;
    CGFloat h = w / whScale;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    img.image = self.showImage;
    img.userInteractionEnabled = YES;
    [_imageView addSubview:img];
    _imageView.contentSize = CGSizeMake(kScreenWidth, h+20);
    CGSize size = [IHUtility GetSizeByText:self.resultStr sizeOfFont:16 width:kScreenWidth-40];
    
    UILabel *text = [MyUtility createLabelWithFrame:CGRectMake(20 ,10, kScreenWidth-40, size.height+10) title:self.resultStr textColor:RGB(51, 51, 51) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft numberOfLines:0];
    text.numberOfLines = 0;
    [_bgView addSubview:text];
    _bgView.contentSize = CGSizeMake(0, size.height+30);
}

-(void)createBottomView{
    NSArray *titleArray = @[@"复制",@"分享",@"校对"];
    NSArray *imageArray = @[@"copy",@"share",@"revision"];
    for(int i=0;i<titleArray.count;i++){
        for(int i=0;i<titleArray.count;i++){
            UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(i*(kScreenWidth)/3,kScreenHeight-bottomY, (kScreenWidth)/3, bottomY)];
            tapView.tag = 100+i;
            [tapView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:tapView];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(((kScreenWidth)/3-26)/2,5, 26, 26)];
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
       //复制
        [self gotoCopy];
    }else if (flag==1){
      //分享
        [self gotoShare];
    }else if (flag==2){
     //校对
         CGSize size = [IHUtility GetSizeByText:self.resultStr sizeOfFont:16 width:kScreenWidth-40];
        _bgView.frame = CGRectMake(0, 64, kScreenWidth, (kScreenHeight-topY)/2);
         _bgView.contentSize = CGSizeMake(0, size.height+20);
        _imageView.hidden = NO;
   }
}
//复制方法
-(void)gotoCopy{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.resultStr;
    [WHToast showMessage:@"复制成功！" duration:1.0f finishHandler:^{
    }];
}
//去分享
-(void)gotoShare{
    UIImage *imageToShare = self.showImage;
    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [WHToast showMessage:@"分享成功"  duration:1 finishHandler:^{
            }];
            //分享 成功
        } else  {
            [WHToast showMessage:@"取消分享"  duration:1 finishHandler:^{
                
            }];
            //分享 取消
        }
    };
}
@end
