//
//  CLImageCell.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLImageCell.h"
#import <UIImageView+WebCache.h>

@implementation CLImageCell

- (void)awakeFromNib {
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = 0.4;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setImage:(id)image{
    if ([image isKindOfClass:[NSString class]]) {
        //url 加载图片
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"3"]];
    }else if ([image isKindOfClass:[UIImage class]]){
        //image
        self.imageView.image = image;
    }
}

@end
