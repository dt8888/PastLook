//
//  AppDelegate.m
//  PastLook
//
//  Created by DT on 2019/4/19.
//  Copyright © 2019年 dayukeji. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LaunchPageView.h"
#import "YJNetworkData.h"
#import "WHToast.h"
#import <AipOcrSdk/AipOcrSdk.h>
@interface AppDelegate ()<UIAlertViewDelegate>
@property(nonatomic,strong)NSString*isUpdate;
@property(nonatomic,strong)NSString*versionUrl;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 授权方法2（更安全）： 下载授权文件，添加至资源
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [WHToast showMessage:@"初始化失败,请稍后重试" duration:1.0f finishHandler:^{
        }];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
        ViewController *viewVC = [[ViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
        self.window.rootViewController = nav;
    return YES;
}
- (void)startShowWindow
{
    LaunchPageView *launchView = [[LaunchPageView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:launchView];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if([self.isUpdate isEqualToString:@"YES"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前检测到新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去升级", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        //跳转到App Store
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionUrl] options:@{} completionHandler:^(BOOL success) {
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
