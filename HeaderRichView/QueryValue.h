//
//  QueryValue.h
//  YiMei
//
//  Created by 李鹏博 on 16/1/13.
//  Copyright © 2016年 李鹏博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QueryValue : NSObject
/*大商机呢*/
+(NSArray*)tipArray;
/*时间转化为时间戳*/
+(NSString*)shijainchuo:(NSString*)time;
/**时间戳转换为时间**/
+(NSString *)timeForshijianchuo:(NSString*)timeStampString;
/**时间戳转换为日期**/
+(NSString *)dateForshijianchuo:(NSString*)sjc;
/**时间戳转换为nsdate**/
+(NSDate *)dateForCreateTime:(NSString*)timeStampString;
/**
 *  时间戳转换为汉语时间（非当天,得到日期和时间）
 *
 *  @param timeStampString <#timeStampString description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)hanTimeForshijianchuo:(NSString*)timeStampString;
/**
 *  时间戳转换为汉语时间（当天,不要日期,只要时间）
 *
 *  @param timeStampString <#timeStampString description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)hanTimeTodayForshijianchuo:(NSString*)timeStampString;

/**颜色转换为图片**/
+(UIImage*)createImageWithColor:(UIColor*)color;

/**随机颜色**/
+ (UIColor *)randomColor;
//获得所有城市
+(NSDictionary*)areaArray;
/**
 *  获得所有兴趣标签
 */
+(NSArray*)interestArray;
/**
 *  获得所有印象标签
 */
+(NSArray*)tagArray;
/*根据兴趣标签的名字得到ID*/
+(NSString*)interestIDwithJobName:(NSString*)interestName;
/*根据兴趣标签的ID得到名字*/
+(NSString*)interestNamewithJobId:(NSString*)interestId;
/**
 *  根据城市的ID获取城市的名字
 */
+(NSString*)cityForId:(NSString*)ID;
/**
 *  根据城市的名字获取城市的ID
 */
+(NSString*)idForCity:(NSString*)city;
/**
 *  根据城市的名字获取省份的ID
 */
+(NSString*)idForfather:(NSString*)city;
/**
 *  根据标签的ID获取标签的名字
 */
+(NSString*)tagNameForTagID:(NSString*)tagId;
/**
 *  根据标签的名字获取标签的ID
 */
+(NSString*)tagIdForTagName:(NSString*)tagName;

/**
 *  手机号码验证
 */
+(BOOL)validateMobile:(NSString *)mobile;
/**
 *  压缩图片尺寸
 *
 *  @param image   图片
 *  @param newSize 大小
 *
 *  @return 真实图片
 */

+(UIImage *)imageWithImageSimple:(UIImage *)image targetWidth:(CGFloat)defineWidth;
/**
 *  返回文件格式
 */
+ (NSString *)getTimeNow;
@end
