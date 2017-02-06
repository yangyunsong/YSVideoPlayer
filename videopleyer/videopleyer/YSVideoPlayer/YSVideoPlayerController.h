//
//  YSVideoControlView.h
//  videopleyer
//
//  Created by yangyunsong on 17/1/5.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSVideo.h"

#define kYSVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kYSVideoPlayerOriginalHeight (kYSVideoPlayerOriginalWidth * (11.0 / 16.0))

@interface YSVideoPlayerController : UIView

@property (nonatomic, copy) void(^videoPlayerGoBackBlock)(void);

@property (nonatomic, copy) void(^videoPlayerWillChangeToOriginalScreenModeBlock)();

@property (nonatomic, copy) void(^videoPlayerWillChangeToFullScreenModeBlock)();

@property (nonatomic, strong) YSVideo *video;

@property (nonatomic, assign) CGRect Vframe;


@property (nonatomic, assign) BOOL isLocked;

@property (nonatomic, assign) BOOL isLocal;


-(void) showInView:(UIView *)view;


@end
