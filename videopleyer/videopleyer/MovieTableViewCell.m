//
//  MovieTableViewCell.m
//  videopleyer
//
//  Created by yangyunsong on 17/1/11.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import "MovieTableViewCell.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "ReadFile.h"
@interface MovieTableViewCell()<VLCMediaThumbnailerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoSize;

@end

@implementation MovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVideo:(YSVideo *)video{
    _video = video;
    VLCMedia *media = [VLCMedia mediaWithPath:video.filmPath];
    VLCMediaThumbnailer *mediaTh = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
    mediaTh.snapshotPosition = 0.1;
    [mediaTh fetchThumbnail];
    self.videoTitle.text = video.filmName;
    self.videoSize.text = [[ReadFile sharedManager]fileSizeToString:video.filmPath];
    
}

- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    UIImage *img = [[UIImage alloc]initWithCGImage:thumbnail];
    self.videoImg.image = img;
}
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    NSLog(@"error");
}


@end
