//
//  videoPlayerHeader.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/8.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#ifndef videoPlayerHeader_h
#define videoPlayerHeader_h


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds

#define kFont(size) [UIFont systemFontOfSize:size]
#define kLineHeight (1 / [UIScreen mainScreen].scale)


#define kMediaLength self.player.media.length
#define MRRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


/*************** Control ****************************/
static const CGFloat YSProgressWidth = 3.0f;
static const CGFloat YSVideoControlBarHeight = 40.0;
static const CGFloat YSVideoControlSliderHeight = 10.0;
static const CGFloat YSVideoControlAnimationTimeinterval = 0.3;
static const CGFloat YSVideoControlTimeLabelFontSize = 10.0;
static const CGFloat YSVideoControlBarAutoFadeOutTimeinterval = 4.0;
static const CGFloat YSVideoControlCorrectValue = 3;
static const CGFloat YSVideoControlAlertAlpha = 0.75;
#endif /* videoPlayerHeader_h */
