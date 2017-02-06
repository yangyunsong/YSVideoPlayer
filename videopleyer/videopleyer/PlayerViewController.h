//
//  PlayerViewController.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/14.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "YSVideo.h"

#define kYSVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kYSVideoPlayerOriginalHeight (kZXVideoPlayerOriginalWidth * (11.0 / 16.0))

@interface PlayerViewController : UIViewController
@property(nonatomic, strong)YSVideo *video;
@end
