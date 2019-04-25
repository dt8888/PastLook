//
//  IHUtility.m
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "IHUtility.h"
#import "MBProgressHUD.h"
#import "WHToast.h"
#import <CommonCrypto/CommonDigest.h>
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
const Byte iv[] = {1,2,3,4,5,6,7,8};
#define DESkey  @"yijiao17"
@implementation IHUtility

//表示常用方法，弹框，提示
+(UIImage *)rotateAndScaleImage:(UIImage *)image maxResolution:(NSInteger)maxResolution {
    
    int kMaxResolution;
    if (maxResolution <= 0)
        kMaxResolution = 640;
    else
        kMaxResolution = (int)maxResolution;
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//随机数
+ (NSString*)getTransactionID
{
    NSDate* date = [NSDate date];
    NSMutableString* strDate = [NSMutableString stringWithFormat:@"%@", date];
    NSString *s1=[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *s2= [s1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *s3= [s2 stringByReplacingOccurrencesOfString:@":" withString:@""];
    int n = (arc4random() % 9000) ;
    NSMutableString* transactionID = [NSMutableString stringWithString:[s3 substringToIndex:14]];
    [transactionID appendString:[NSString stringWithFormat:@"%d", n]];
    
    [transactionID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return transactionID;
}
//获取当前时间戳
+(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
//获取时间（刚刚）
+(NSString *)createdTimeStr:(NSString *)time{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:time];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = timeInterval/3600) > 1 && (temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = timeInterval/3600) > 24 && (temp = timeInterval/3600) < 48){
        result = [NSString stringWithFormat:@"昨天"];
    }else if ((temp = timeInterval/3600) > 48 && (temp = timeInterval/3600) < 72){
        result = [NSString stringWithFormat:@"前天"];
    }else{
        result = time;
    }
    return result;
}

+(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height;
    return textHeight;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(NSString*)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}
+(CGSize)withText:(NSString *)text font:(CGFloat)font{
      CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return tmpRect.size;
}
+(void)blurEffect:(UIView *)view{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectVIew = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectVIew.frame = view.bounds;
    [view addSubview:effectVIew];
}
//高度
+(CGFloat)withText:(NSString *)text font:(CGFloat)font width:(CGFloat)width{
    
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height;
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^[A-Za-z0-9]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

+ (NSString*)MD5Encode:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
//验证手机号码
+ (BOOL)checkPhoneValidate:(NSString*)str
{
    if (str == nil || [str length] == 0 ) {
        [WHToast showMessage:@"手机号码不能为空"  duration:1 finishHandler:^{
        }];
        return NO;
    }
    if([str length]!=11)
    {
        [WHToast showMessage:@"请输入正确的手机号码"  duration:1 finishHandler:^{
        }];
        return NO;
    }
    return YES;
}


+(CGSize)GetSizeByText:(NSString *)text sizeOfFont:(CGFloat)sizeOfFont width:(int)width{
    CGSize size;
    if (text==nil || [text length]==0) {
        size=CGSizeMake(320, 20);
        return size;
    }
    UIFont *font;
    if (sizeOfFont<=0) {
        font=[UIFont systemFontOfSize:12];
    }else {
        font=[UIFont systemFontOfSize:sizeOfFont];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:sizeOfFont]};
        size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:\
                NSStringDrawingTruncatesLastVisibleLine |
                NSStringDrawingUsesLineFragmentOrigin |
                NSStringDrawingUsesFontLeading
                               attributes:attribute context:nil].size;
    }else{
        size=[text sizeWithFont:font constrainedToSize:CGSizeMake(width,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}
+(void)saveDicUserDefaluts:(NSDictionary *)dic  key:(NSString *)key{
    NSUserDefaults *userDefaluts=[NSUserDefaults standardUserDefaults];
    [userDefaluts setObject:dic forKey:key];
    [userDefaluts synchronize];
}

+(NSDictionary*)getUserDefalutDic:(NSString *)key{
    NSUserDefaults *userDefaluts=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[userDefaluts objectForKey:key];
    return dic;
}
//判断非空
+ (BOOL) isBlankString:(NSString *)string {
    if (string ==nil || string ==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}
//时间对比 返回1 - 过期, 0 - 相等, -1 - 没过期
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}
//获得明天时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour|NSCalendarUnitMinute fromDate:aDate];
    [components setDay:([components day]+1)];
    [components setHour:[components hour]];
     [components setMinute:[components minute]];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [dateday stringFromDate:beginningOfWeek];
}

+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                         documentAttributes:tempDic
                                      error:nil];
    return [[NSString alloc] initWithData:htmlData
                                 encoding:NSUTF8StringEncoding];
}

+ (id)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

//封装提示框
+(UIAlertController *)createAlertWithTitle:(NSString *)title message:(NSString *)message preferred:(UIAlertControllerStyle)preferred confirmHandler:(void (^)(UIAlertAction *))confirmHandler   cancleHandler:(void (^)(UIAlertAction *))cancleHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferred];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmHandler];
    [alertController addAction:confirmAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    [alertController addAction:cancleAction];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.3)
    {
        [cancleAction setValue:RGB(155, 155, 155) forKey:@"titleTextColor"];
        [confirmAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }
    return alertController;
}
+(NSString *)getLastString:(NSString *)string
{
    NSString *lastString = nil;
    NSString *frist = [string substringWithRange:NSMakeRange(1, string.length-2)];
    NSString *newStr = [frist stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSRange startRange = [newStr rangeOfString:@"{"];
    NSRange endRange = [newStr rangeOfString:@"}"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [newStr substringWithRange:range];
    NSArray *last = [result componentsSeparatedByString:@","];
    
    for (int i=0;i<last.count;i++) {
        NSArray *subResultArr = [last[i] componentsSeparatedByString:@":"];
        
        if ([subResultArr[0] isEqualToString:@"trade_no"]) {
            NSLog(@"trade_no = %@",subResultArr[1]);
            lastString  = subResultArr[1];
        }
        //        if ([subResultArr[0] isEqualToString:@"out_trade_no"]) {
        //            NSLog(@"out_trade_no = %@",subResultArr[1]);
        //            lastString = [NSString stringWithFormat:@"%@ %@",lastString,subResultArr[1]];
        //        }
    }
    return lastString;
}
+(NSDictionary*)getWXString:(NSString*)string
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray *last = [string componentsSeparatedByString:@"&"];
    for(NSString *str in last) {
        NSArray *subResultArr = [str componentsSeparatedByString:@"="];
        
        if ([subResultArr[0] isEqualToString:@"package"]) {
            [dict setObject:[NSString stringWithFormat:@"%@=%@",subResultArr[1],subResultArr[2]] forKey:subResultArr[0]];
        }else
        {
            [dict setObject:subResultArr[1] forKey:subResultArr[0]];
        }
    }
    return dict;
}

//判断是否为空
+ (BOOL)isBlankArray:(NSArray*)arr{
    if([arr isEqual:[NSNull null]]){
        return YES;
    }
    if(arr.count==0){
        return YES;
    }
    if(arr==nil){
        return YES;
    }
    return NO;
}
+(void)addWaitingView{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
}
+(void)addWaitingView:(NSString*)alterStr{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window alterStr:alterStr animated:YES];
}
+(void)removeWaitingView{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:YES];
}
+ (NSString*)weekConversionDay:(NSString*)week {
    if([week isEqualToString:@"Monday"]){
        return @"星期一";
    }
    if([week isEqualToString:@"Tuesday"]){
        return @"星期二";
    }
    if([week isEqualToString:@"Wednesday"]){
        return @"星期三";
    }
    if([week isEqualToString:@"Thursday"]){
        return @"星期四";
    }
    if([week isEqualToString:@"Friday"]){
        return @"星期五";
    }
    if([week isEqualToString:@"Saturday"]){
        return @"星期六";
    }
    if([week isEqualToString:@"Sunday"]){
        return @"星期日";
    }
    return nil;
}

+(BOOL)isStringContainNumberWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];//count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}
  
+ (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}
+(UIImage *) getImageFromURL:(NSString *)fileURL
{
       UIImage * result;
       NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
       result = [UIImage imageWithData:data];
       return result;
}
/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowRadius = 8;
    view.layer.shadowColor = RGB(0, 0, 0).CGColor;
    view.layer.shadowOpacity = 1;
    view.layer.cornerRadius = 8;
    view.clipsToBounds=NO;
    //////// shadow /////////
//    CALayer *shadowLayer = [CALayer layer];
//    shadowLayer.frame = view.frame;
//shadowLayer.masksToBounds = NO;
//    shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    shadowLayer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
//    shadowLayer.shadowOffset = CGSizeMake(0, 2);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
//    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
//    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
//    //路径阴影
//    UIBezierPath *path = [UIBezierPath bezierPath];
//
//    float width = shadowLayer.bounds.size.width;
//    float height = shadowLayer.bounds.size.height;
//    float x = shadowLayer.bounds.origin.x;
//    float y = shadowLayer.bounds.origin.y;
//
//    CGPoint topLeft      = shadowLayer.bounds.origin;
//    CGPoint topRight     = CGPointMake(x + width, y);
//    CGPoint bottomRight  = CGPointMake(x + width, y + height);
//    CGPoint bottomLeft   = CGPointMake(x, y + height);
//
//    CGFloat offset = 1.f;
//    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
//    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
//    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
//    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
//    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
//    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
//    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
//    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
//    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
//
//    //设置阴影路径
//    shadowLayer.shadowPath = path.CGPath;
  
    //////// cornerRadius /////////
//    view.layer.cornerRadius = cornerRadius;
//        view.layer.masksToBounds = YES;
//    view.layer.shouldRasterize = YES;
//    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
//    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}
+(void)writeToFileWithTxt:(NSString *)string{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            //获取沙盒路径
            NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            //获取文件路径
            NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.txt"];
            //创建文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //如果文件不存在 创建文件
            if(![fileManager fileExistsAtPath:theFilePath]){
                NSString *str = @"日志开始记录\n";
                [str writeToFile:theFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            NSLog(@"所写内容=%@",string);
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:theFilePath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData* stringData  = [[NSString stringWithFormat:@"%@\n",string] dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
        }
    });
}
@end
