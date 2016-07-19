//
//  CLImageBrowserCell.h
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLImageBrowserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

// 单点block回调
@property (nonatomic, copy) void (^singleTapGestureBlock)();

// 长按回调
@property (nonatomic, copy) void (^longGestureBlock)();

- (void)setImage:(id)image placeholder:(UIImage *)placeholder;

@end
