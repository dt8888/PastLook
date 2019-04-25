//
//  SessionManager.h
//  YJJSApp
//
//  Created by DT on 2018/7/18.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface SessionManager : NSObject
+(AFHTTPSessionManager*)shareManager;
@end
