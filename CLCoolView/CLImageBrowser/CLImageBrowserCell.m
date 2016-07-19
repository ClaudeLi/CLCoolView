//
//  CLImageBrowserCell.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLImageBrowserCell.h"
#import "UIView+CLExt.h"
#import <UIImageView+WebCache.h>

@interface CLImageBrowserCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIView *imageContainerView;

@end

@implementation CLImageBrowserCell

- (void)awakeFromNib {
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    
    self.imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageContainerView];
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self addGestureRecognizer:longGesture];
}

- (void)resizeSubviews {
    _imageContainerView.cl_origin = CGPointZero;
    _imageContainerView.cl_width = self.cl_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.cl_height / self.cl_width) {
        _imageContainerView.cl_height = floor(image.size.height / (image.size.width / self.cl_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.cl_width;
        if (height < 1 || isnan(height)) height = self.cl_height;
        height = floor(height);
        _imageContainerView.cl_height = height;
        _imageContainerView.cl_centerY = self.cl_height / 2;
    }
    if (_imageContainerView.cl_height > self.cl_height && _imageContainerView.cl_height - self.cl_height <= 1) {
        _imageContainerView.cl_height = self.cl_height;
    }
    _scrollView.contentSize = CGSizeMake(self.cl_width, MAX(_imageContainerView.cl_height, self.cl_height));
    //    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.cl_height <= self.cl_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}


#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.cl_width > scrollView.contentSize.width) ? (scrollView.cl_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.cl_height > scrollView.contentSize.height) ? (scrollView.cl_height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)setImage:(id)image placeholder:(UIImage *)placeholder{
    [_scrollView setZoomScale:1.0 animated:NO];
    if ([image isKindOfClass:[NSString class]]) {
        //url 加载图片
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:placeholder];
    }else if ([image isKindOfClass:[UIImage class]]){
        //image
        self.imageView.image = image;
    }
    [self resizeSubviews];
}


#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)gesture{
    if (self.longGestureBlock) {
        self.longGestureBlock();
    }
}

@end
