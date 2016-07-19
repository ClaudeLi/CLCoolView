//
//  CLImageCell.h
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setImage:(id)image;

@end
