//
//  YJNetworkData.m
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "YJNetworkData.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "WHToast.h"
#import "NSObject+SBJSON.h"
#import "SessionManager.h"
#define  serStrURL @"http://api.linkacb.com/"
@implementation YJNetworkData
static YJNetworkData *_config;
+(YJNetworkData *)shareInstance{
    @synchronized(self){
        if (_config==nil) {
            _config=[[YJNetworkData alloc] init];
        }
    }
    return _config;
}

-(void)httpRequestWithParameterWithGet:(NSString *)method success:(void (^)(id))success
{
 AFHTTPSessionManager *sessionManager = [SessionManager shareManager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    [sessionManager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    NSString * service = [NSString stringWithFormat:@"%@%@",serStrURL,method];
    [sessionManager GET:service parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSData * xmlData = (NSData *)responseObject;
            if(xmlData.bytes > 0){
                JSONDecoder *jd=[[JSONDecoder alloc] init];
                NSString *resultString  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *ret = [jd objectWithData: responseObject];
                if(ret!=nil){
                    NSInteger errorNo=[[ret objectForKey:@"code"]integerValue];
                    if(errorNo!=0){
                        [WHToast showMessage:[ret objectForKey:@"msg"] duration:1 finishHandler:^{
                        }];
                    }else
                    {
                        NSDictionary *dic2=[self parseResult:ret tag:nil];
                        success(dic2);
                    }
                }else
                {
                    success(resultString);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSDictionary *userInfo=error.userInfo;
        [WHToast showMessage:[userInfo objectForKey:@"NSLocalizedDescription"] duration:1 finishHandler:^{
        }];
    }];
}
#pragma mark 构建模型
-(NSDictionary *)parseResult:(NSDictionary*)dic tag:(IHFunctionTag)tag{
    return dic;
}
#pragma mark 跟新系统版本
-(void)updateIosVersion:(NSString*)iosVersion
             success:(void (^)(NSDictionary *obj))success{
    [self httpRequestWithParameterWithGet:@"sys/update/v1.7?iosVersion=1" success:^(id dic) {
        success(dic);
    }];
}
@end

