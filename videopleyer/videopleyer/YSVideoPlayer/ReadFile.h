//
//  ReadFile.h
//  videopleyer
//
//  Created by yangyunsong on 17/1/11.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadFile : NSObject

+ (instancetype)sharedManager;
- (NSMutableArray *)getLocalData;
- (void)deleteLocalFile:(NSString *)path;
- (NSString *)fileSizeToString:(NSString *)path;
- (void)replaceFileName:(NSString *)path;
@end
