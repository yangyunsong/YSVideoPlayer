//
//  NSDictionary+NSDictionaryAdd.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/14.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "NSDictionary+NSDictionaryAdd.h"
#import <AVFoundation/AVFoundation.h>
@implementation NSDictionary (NSDictionaryAdd)
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}@end
