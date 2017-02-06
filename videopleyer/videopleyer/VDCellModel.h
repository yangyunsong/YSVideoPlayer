//
//  VDCellModel.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/9.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VDCellModel : NSObject
+ (NSMutableArray *)getLocalData;
@property(strong, nonatomic)UIImage *filmImg;
@property(strong, nonatomic)NSString *filmName;
@property(strong, nonatomic)NSString *filmPath;
@property(strong, nonatomic)NSString *recoder;
@end
