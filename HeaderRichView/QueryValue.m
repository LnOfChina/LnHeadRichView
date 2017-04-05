//
//  QueryValue.m
//  YiMei
//
//  Created by 李鹏博 on 16/1/13.
//  Copyright © 2016年 李鹏博. All rights reserved.
//  创建人：李鹏博
//  时间： 2016/1/13
//  功能： 查询本地的城市、行业、标签、类型，时间戳／时间转换等等

#import "QueryValue.h"
@interface QueryValue()

@end
@implementation QueryValue
+(NSArray*)tipArray{
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tip.plist"];
    NSDictionary *tagDic =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    return tagDic[@"data"];
}
+(NSArray*)tagArray{
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tag.plist"];
    NSDictionary *tagDic =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    return tagDic[@"data"];
}
+(NSString*)tagNameForTagID:(NSString*)tagId{
    NSString *tagName =@"";
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tag.plist"];
    NSDictionary *tagDic =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dataArray =tagDic[@"data"];
    for (NSDictionary *dataDic in dataArray) {
        NSInteger tagID =[dataDic[@"id"] integerValue];
        if ([tagId integerValue]==tagID) {
            tagName =dataDic[@"name"];
        }
    }
    return tagName;
}
+(NSString*)tagIdForTagName:(NSString*)tagName{
    NSString *tagId =@"";
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/tag.plist"];
    NSDictionary *tagDic =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dataArray =tagDic[@"data"];
    for (NSDictionary *dataDic in dataArray) {
        NSString* tag =dataDic[@"name"];
        if ([tagName  isEqualToString:tag]) {
            tagId =dataDic[@"id"];
        }
    }
    return tagId;
}
//返回总城市列表
+(NSDictionary*)areaArray{
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/area.plist"];
    NSDictionary *area =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSDictionary *dataDic =area[@"data"];
    return dataDic;
}
//根据城市ID返回城市名字
+(NSString*)cityForId:(NSString*)ID{
    NSString *city =@"";
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/area.plist"];
    NSDictionary *area =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dataArray =area[@"data"][@"citys"];
    for (NSDictionary *dataDic in dataArray) {
        NSInteger cityID =[dataDic[@"id"] integerValue];
        if ([ID integerValue]==cityID) {
            city =dataDic[@"areaname"];
        }
    }
    return city;
}
////根据城市名字返回ID
//+(NSString*)idForCity:(NSString*)city{
//    NSString *cityID =@"";
//    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/area.plist"];
//    NSDictionary *area =[[NSDictionary alloc] initWithContentsOfFile:filePath];
//    NSArray *dataArray =area[@"data"][@"citys"];
//    for (NSDictionary *dataDic in dataArray) {
//        NSString *cityName =dataDic[@"areaname"];
//        if ([city isEqualToString:cityName]) {
//            cityID =String(dataDic[@"id"]);
//        }
//    }
//    return cityID;
//}
//+(NSString*)idForfather:(NSString*)city{
//    NSString *fatherID =@"";
//    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/area.plist"];
//    NSDictionary *area =[[NSDictionary alloc] initWithContentsOfFile:filePath];
//    NSArray *dataArray =area[@"data"][@"citys"];
//    for (NSDictionary *dataDic in dataArray) {
//        NSString *cityName =dataDic[@"areaname"];
//        if ([city isEqualToString:cityName]) {
//            fatherID =String(dataDic[@"fatherid"]);
//        }
//    }
//    return fatherID;
//}
//获得所有职业
+(NSArray*)interestArray{
    NSString *filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/interest.plist"];
    NSDictionary *interest =[[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dataArr =interest[@"data"];
    return dataArr;
}
+(NSString*)interestIDwithJobName:(NSString*)interestName{
    NSString *interestID =@"";
    for (NSDictionary *dataDic in [QueryValue interestArray]) {
        if ([dataDic[@"name"] isEqualToString:interestName]) {
            interestID =[NSString stringWithFormat:@"%@",dataDic[@"id"]];
        }
    }
    return interestID;
}
+(NSString*)interestNamewithJobId:(NSString*)interestId{
    NSString *interestName =@"";
    for (NSDictionary *dataDic in [QueryValue interestArray]) {
        if ([[NSString stringWithFormat:@"%@",dataDic[@"id"]] isEqualToString:interestId]) {
            interestName =[NSString stringWithFormat:@"%@",dataDic[@"name"]];
        }
    }
    return interestName;
}
//时间转化为时间戳
+(NSString*)shijainchuo:(NSString*)time{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:time]; //------------将字符串按formatter转成nsdate
    NSTimeInterval a=[date timeIntervalSince1970]*1000;
    NSString *timeSp = [NSString stringWithFormat:@"%.f",a];//转为字符型
    return timeSp;
}
//时间戳转换为时间
+(NSString *)timeForshijianchuo:(NSString*)timeStampString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[timeStampString doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
//    confromTimespStr =[confromTimespStr substringWithRange:NSMakeRange(0, 18)];
    return confromTimespStr;
}
//时间戳转换为日期
+(NSString *)dateForshijianchuo:(NSString*)timeStampString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[timeStampString doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    confromTimespStr =[confromTimespStr substringWithRange:NSMakeRange(0, 10)];
    return confromTimespStr;
}
//时间戳转换为nsdate
+(NSDate *)dateForCreateTime:(NSString*)timeStampString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[timeStampString longLongValue]/1000];
   
    return date;
}
//时间戳转换为日期
+(NSString *)hanTimeForshijianchuo:(NSString*)timeStampString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[timeStampString doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    confromTimespStr =[confromTimespStr substringWithRange:NSMakeRange(5, 12)];
    return confromTimespStr;
}
+(NSString *)hanTimeTodayForshijianchuo:(NSString*)timeStampString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[timeStampString doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    confromTimespStr =[confromTimespStr substringWithRange:NSMakeRange(12, 5)];
    return confromTimespStr;
}

+(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
//手机号码验证
+(BOOL)validateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/**
 *  压缩图片尺寸
 *
 *  @param image   图片
 *  @param newSize 大小
 *
 *  @return 真实图片
 */

+(UIImage *)imageWithImageSimple:(UIImage *)image targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  返回文件格式
 *
 *  @return <#return value description#>
 */
+ (NSString *)getTimeNow
{
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc ] init];
    [formatter1 setDateFormat:@"YYYYMMdd"];
    
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc ] init];
    [formatter2 setDateFormat:@"YYYYMMddhhmmssSSS"];
   
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@/%@%@", [formatter1 stringFromDate:[NSDate date]],[formatter2 stringFromDate:[NSDate date]],strRandom];
    
    return timeNow;
}
@end
