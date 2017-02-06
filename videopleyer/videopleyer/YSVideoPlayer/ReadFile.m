//
//  ReadFile.m
//  videopleyer
//
//  Created by yangyunsong on 17/1/11.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import "ReadFile.h"
#import "UIImage+imageAdd.h"
#import "VDCellModel.h"
#import "YSVideo.h"
@implementation ReadFile
+ (instancetype)sharedManager{
    
    static ReadFile *sharedReadFile = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedReadFile = [[self alloc]init];
    });
    return sharedReadFile;
}

- (NSMutableArray *)getLocalData{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:docsDir];
    NSString *filmName;
    NSString *filmPath;
    UIImage *img;
    
    NSMutableArray * allData = [NSMutableArray new];
    while (filmName = [dirEnum nextObject]) {
        filmPath = [docsDir stringByAppendingPathComponent:filmName];
        img = [UIImage getThumbnailImage:[docsDir stringByAppendingPathComponent:filmName]];
        // range = [filmName rangeOfString:@"."];
        //   filmName = [filmName substringToIndex:range.location];
        YSVideo *video = [[YSVideo alloc]init];
        video.filmName = filmName;
        video.filmPath = filmPath;
        [allData addObject:video];
    }
    return allData;
}
- (void)deleteLocalFile:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];

    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else{
        NSLog(@" have");
        BOOL blDele= [manager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

- (void)replaceFileName:(NSString *)path{

    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    
    
    
}

- (NSString *)fileSizeToString:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
   unsigned long long fileSize = [[manager attributesOfItemAtPath:path error:nil]fileSize];
    
    
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    
    if (fileSize < 10)  {
        return @"0 B";
    }else if (fileSize < KB)    {
        return @"< 1 KB";
    }else if (fileSize < MB)    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
    }else if (fileSize < GB)    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
    }else   {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


@end
