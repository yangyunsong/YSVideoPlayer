//
//  BaseNavigationController.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/8.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController
@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;
@end
