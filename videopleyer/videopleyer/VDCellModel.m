//
//  VDCellModel.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/9.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "VDCellModel.h"
#import "NSDictionary+NSDictionaryAdd.h"
#import "UIImage+imageAdd.h"
@implementation VDCellModel


+ (NSMutableArray *)getLocalData{
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
        VDCellModel *model = [[VDCellModel alloc]init];
        model.filmName = filmName;
        model.filmPath = filmPath;
        model.filmImg = img;
        [allData addObject:model];
    }
    return allData;
}

@end
