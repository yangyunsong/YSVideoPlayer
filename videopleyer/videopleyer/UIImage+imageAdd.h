//
//  UIImage+imageAdd.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/8.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageAdd)

/*
 * 获取视频封面
 */
+(UIImage *)getThumbnailImage:(NSString *)videoPath;
/*
 * 裁剪图片(圆形)
 */
+(UIImage *)circleImageWithName:(NSString *)name
                    borderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor;

@end
