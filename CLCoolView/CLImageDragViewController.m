//
//  CLImageDragViewController.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLImageDragViewController.h"
#import "CLImageTypesetView.h"
#import "CLImageBrowserController.h"

@interface CLImageDragViewController ()<UIActionSheetDelegate>{
    NSInteger removeIndex;
    CLImageTypesetView *_typesetView;
}

@end

@implementation CLImageDragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _typesetView = [[CLImageTypesetView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_typesetView];
    
    [_typesetView setImagesWithImageArray:self.imageArray point:CGPointMake(0.5, 20)];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [_typesetView setUpdateArrayBlock:^(NSMutableArray *imageArr) {
        weakSelf.imageArray = imageArr;
    }];
    
    [_typesetView setLongGestureBlock:^(NSInteger index) {
        if (_typesetView.imageArray.count > 1) {
            removeIndex = index;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
            [actionSheet showInView:weakSelf.view];
        }
    }];
    
    [_typesetView setSelectImageBlock:^(NSInteger index, NSArray<UIImageView *> *array) {
        CLImageBrowserController *imageBrowser = [[CLImageBrowserController alloc] initWithSourceArray:array imageArray:weakSelf.imageArray index:index];
        imageBrowser.transitioningDelegate = imageBrowser;
        [weakSelf presentViewController:imageBrowser animated:YES completion:nil];
    }];
    
    [_typesetView setMoveGesture];
    [_typesetView setLongGesture];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //取出源item数据
        id objc = [_typesetView.imageArray objectAtIndex:removeIndex];
        [_typesetView.imageArray removeObject:objc];
        [_typesetView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
