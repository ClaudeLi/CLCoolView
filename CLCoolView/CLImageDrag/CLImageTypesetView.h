//
//  CLImageTypesetView.h
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 初始化调用- initWithFrame:CGRectZero

@interface CLImageTypesetView : UICollectionView

// 图片数组
@property (nonatomic, strong) NSMutableArray *imageArray;

// 选中图片 回调Block
@property (nonatomic, copy) void(^selectImageBlock)(NSInteger index, NSArray <UIImageView *>* sourceArray);

// 长按图片 回调Block <-- 注：先调用 setLongGesture 添加长按手势 -->
@property (nonatomic, copy) void(^longGestureBlock)(NSInteger index);

// 移动图片 回调Block <-- 注：先调用 setMoveGesture 添加拖拽手势 -->
@property (nonatomic, copy) void(^updateArrayBlock)(NSMutableArray *imageArray);

// 设置图片数组, 起始坐标点 CGPointMark(x, y)
- (void)setImagesWithImageArray:(NSArray *)imageArray point:(CGPoint)point;

// 添加长按手势
- (void)setLongGesture;

// 添加移动手势
- (void)setMoveGesture;

@end
