//
//  UIImage+imageAdd.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/8.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "UIImage+imageAdd.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (imageAdd)
+(UIImage *)getThumbnailImage:(NSString *)videoPath {
    if (videoPath) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoPath] options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(asset.duration.timescale, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
    } else {
        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
        return placeHoldImg;
    }
}

+(UIImage *)circleImageWithName:(NSString *)name
                    borderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor{
    
    UIImage *oldimage = [UIImage imageNamed:name];
    CGFloat imgW = oldimage.size.width +   borderWidth;
    CGFloat imgH = oldimage.size.height +   borderWidth;
    CGSize imageSize = CGSizeMake(imgW, imgH);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [borderColor set];
    CGFloat sideRudius = imgW * 0.5;
    CGFloat centerX = sideRudius;
    CGFloat centerY = sideRudius;
    CGContextAddArc(ctx, centerX, centerY, sideRudius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    CGFloat insideRadius = sideRudius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, insideRadius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    
    [oldimage drawInRect:CGRectMake(borderWidth, borderWidth, oldimage.size.width, oldimage.size.width)];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newimg;
}


@end
