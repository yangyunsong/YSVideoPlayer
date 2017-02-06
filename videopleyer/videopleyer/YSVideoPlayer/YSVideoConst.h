//
//  YSVideoConst.h
//  videopleyer
//
//  Created by yangyunsong on 17/1/6.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#ifndef YSVideoConst_h
#define YSVideoConst_h



#define kMediaLength self.player.media.length
#define MRRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kSCREEN_BOUNDS [[UIScreen mainScreen] bounds]


/*************** Control ****************************/
static const CGFloat YSProgressWidth = 3.0f;
static const CGFloat YSVideoControlBarHeight = 40.0;
static const CGFloat YSVideoControlSliderHeight = 10.0;
static const CGFloat YSVideoControlAnimationTimeinterval = 0.3;
static const CGFloat YSVideoControlTimeLabelFontSize = 10.0;
static const CGFloat YSVideoControlBarAutoFadeOutTimeinterval = 4.0;
static const CGFloat YSVideoControlCorrectValue = 3;
static const CGFloat YSVideoControlAlertAlpha = 0.75;


#endif /* YSVideoConst_h */
