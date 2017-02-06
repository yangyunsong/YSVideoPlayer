//
//  YSVideoPlayerTimeIndicatorView.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/22.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, YSTimeIndicatorPlaystate){
    YSTimeIndicatorPlayStateRewind,      // rewind
    YSTimeIndicatorPlayStateFastForward // fast forward
};

static const CGFloat kVideoTimeIndicatorViewSide = 96;

@interface YSVideoPlayerTimeIndicatorView : UIView
@property (nonatomic, strong, readwrite) NSString *labelText;
@property (nonatomic, assign, readwrite) YSTimeIndicatorPlaystate playState;

@end
