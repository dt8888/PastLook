//
//  SessionManager.m
//  YJJSApp
//
//  Created by DT on 2018/7/18.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager
#pragma mark - shareManager
/**
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类的实例
 */
+(AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}


@end
