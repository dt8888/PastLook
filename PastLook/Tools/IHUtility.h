//
//  IHUtility.h
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface IHUtility : NSObject
+(UIImage *)rotateAndScaleImage:(UIImage *)image maxResolution:(NSInteger)maxResolution;

+ (BOOL) IsEnableWIFI ;
//随机数
+ (NSString*)getTransactionID;
//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp;
//获取时间（刚刚）
+(NSString *)createdTimeStr:(NSString *)time;
+(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+(NSString*)stringFromDate:(NSDate *)date;
+ (BOOL)checkPhoneValidate:(NSString*)str;
//宽度
+(CGSize)withText:(NSString *)text font:(CGFloat)font;
+(void)blurEffect:(UIView *)view;
+(CGSize)GetSizeByText:(NSString *)text sizeOfFont:(CGFloat)sizeOfFont width:(int)width;
//高度
+(CGFloat)withText:(NSString *)text font:(CGFloat)font width:(CGFloat)width;
+(void)addWaitingView;

+(void)addWaitingView:(NSString*)alterStr;
+(void)removeWaitingView;
+(BOOL)judgePassWordLegal:(NSString *)pass;
+ (NSString*)MD5Encode:(NSString*)input;
+(void)saveDicUserDefaluts:(NSDictionary *)dic  key:(NSString *)key;
+(NSDictionary*)getUserDefalutDic:(NSString *)key;
//判断非空
+ (BOOL) isBlankString:(NSString *)string;
//时间对比 返回1 - 过期, 0 - 相等, -1 - 没过期
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
//获得明天时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate;
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri;
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

+(UIAlertController *)createAlertWithTitle:(NSString *)title message:(NSString *)message preferred:(UIAlertControllerStyle)preferred confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler cancleHandler:(void(^)(UIAlertAction *cancleAction))cancleHandler;

+(NSString *)decryptUseDES:(NSString *)cipherText;
+(NSString *)getLastString:(NSString *)string;

+(NSDictionary*)getWXString:(NSString*)string;

+(NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second;


//判断数组非空
+ (BOOL)isBlankArray:(NSArray*)arr;
//身份验证
+(BOOL)validateIDCardNumber:(NSString *)value;

+ (NSString*)weekConversionDay:(NSString*)week;
+ (NSString *)time_timestampToString:(NSInteger)timestamp;
+(UIImage *) getImageFromURL:(NSString *)fileURL;

+ (BOOL)isStringContainNumberWith:(NSString *)str;
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;

+(void)writeToFileWithTxt:(NSString *)string;
@end
