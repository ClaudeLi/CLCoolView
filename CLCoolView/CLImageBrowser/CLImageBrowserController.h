//
//  CLImageBrowserController.h
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLImageBrowserController : UIViewController<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

// 是否可删除
@property (nonatomic, assign) BOOL isCanDel;

// Return the new photos / 返回最新的图片数组
@property (nonatomic, copy) void(^updateImageArrayBlock)(NSMutableArray *imageArray);

/**
 *  图片浏览器
 *
 *  @param sourceArray 源imageView数组 <-- 需要预览的imageView数组 -->
 *  @param imageArray  图片数组 <-- 本地图片为UIImage数组, 网络图片为图片地址数组 -->
 *  @param index       点击的图片的索引
 *
 */
- (instancetype)initWithSourceArray:(NSArray <UIImageView *>*)sourceArray imageArray:(NSArray *)imageArray index:(NSInteger)index;

@end

