//
//  ViewController.m
//  PastLook
//
//  Created by DT on 2019/4/19.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "ViewController.h"
#import "MyUtility.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "CheckViewController.h"
#import "WHToast.h"
#import "AlterView.h"
#define  titleColor     RGB(119, 120, 120)   //背景色
#define kScreenHeight [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//获取屏幕宽度
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define KIsiPhoneX ([UIScreen mainScreen].bounds.size.height>800.0f)
#define  tabBarHeigh    KIsiPhoneX ? 34:0
#define  navHeigh    KIsiPhoneX ? 44:20
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIImageView *bgImage;
@end

@implementation ViewController
{
    UILabel *infoLabel;
    NSMutableArray *_imageArray;
    NSMutableArray*_labelArray;
    NSInteger _selFlag;
    BOOL  _isOpenButton;
    BOOL _isSearched;
    UILabel *title;
    UILabel *_timeText;
   
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self startSideBack];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self cancelSideBack];
//}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}
-(void)createView{
    UIImageView*bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 90, kScreenWidth-30, 470*(kScreenWidth-30)/690)];
    bg1 .userInteractionEnabled = YES;
    bg1.layer.masksToBounds = YES;
    bg1.layer.cornerRadius = 5;
    bg1.tag = 100;
    bg1 .image = [UIImage imageNamed:@"bg1"];
    [self.view addSubview:bg1 ];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkImage:)];
    [bg1  addGestureRecognizer:tap];
    
    UIImageView*bg2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, bg1.bottom+20, kScreenWidth-30, 470*(kScreenWidth-30)/690)];
    bg2 .userInteractionEnabled = YES;
    bg2.tag = 200;
    bg2.layer.masksToBounds = YES;
    bg2.layer.cornerRadius = 5;
    bg2 .image = [UIImage imageNamed:@"bg2"];
    [self.view addSubview:bg2 ];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkImage:)];
    [bg2  addGestureRecognizer:tap2];
}
-(void)checkImage:(UITapGestureRecognizer*)tap{
    int userSum = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userSum"] intValue];

        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        if(tap.view.tag==100){
            //相册
            vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if (tap.view.tag==200){
            //相机
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:vc animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    CheckViewController *checkVC = [[CheckViewController alloc]init];
    checkVC.hidesBottomBarWhenPushed = YES;
    checkVC.showImage = image;
    [self.navigationController pushViewController:checkVC animated:YES];
    
}
@end
