//
//  NSDictionary+NSDictionaryAdd.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/14.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionaryAdd)
// 获取视频大小、时间
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path;
@end
