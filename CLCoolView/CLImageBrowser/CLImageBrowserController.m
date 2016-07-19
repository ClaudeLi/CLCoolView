//
//  CLImageBrowserController.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLImageBrowserController.h"
#import "FYTransitionHelper.h"
#import "CLImageBrowserCell.h"

#define KBounds         [UIScreen mainScreen].bounds
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface CLImageBrowserController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView    *_collectionView;
    UILabel             *_label;            // 显示当前页数label
    UIButton            *_delBtn;           // 删除
    NSMutableArray <UIImageView *>*_sourceArray;
    NSMutableArray      *_imageArray;
    NSInteger           _currentIndex;
    NSArray             *rectArray;
}

@property(nonatomic ,strong) FYTransitionHelper *transitionHelper;

@end

static NSString *cellIdentifier = @"ImageBrowserCells";

@implementation CLImageBrowserController

- (instancetype)initWithSourceArray:(NSArray <UIImageView *>*)sourceArray imageArray:(NSArray *)imageArray index:(NSInteger)index{
    self = [super init];
    if (self) {
        _sourceArray = [NSMutableArray arrayWithArray:sourceArray];
        rectArray = [_sourceArray copy];
        _imageArray = [NSMutableArray arrayWithArray:imageArray];
        _currentIndex = index;
        [self configCollectionView];
        [self setOriginalImageView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(KScreenWidth * _imageArray.count, KScreenHeight);
    [_collectionView registerNib:[UINib nibWithNibName:@"CLImageBrowserCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView setContentOffset:CGPointMake((KScreenWidth) * _currentIndex, 0) animated:NO];
}

- (void)setOriginalImageView{
    UIImageView *sourceImageView = _sourceArray[_currentIndex];
    
    UIImageView *finalImageView = [[UIImageView alloc] initWithImage:sourceImageView.image];
    finalImageView.frame = [self getFinalImageViewFrameWith:sourceImageView.image];
    
    FYTransitionHelper *animatorHelper = [[FYTransitionHelper alloc] initWithOriginalImageView:sourceImageView finalImageView:finalImageView];
    _transitionHelper = animatorHelper;
    
    __weak typeof(self) weakSelf = self;
    [_transitionHelper.presentAnimator setTransitionCompletionBlock:^(BOOL didComepleted, UIImageView *imageView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (didComepleted) {
            [strongSelf transitionCompleteAnimation];
        }
    }];
}

- (CGRect)getFinalImageViewFrameWith:(UIImage *)image{
    if (image.size.height/image.size.width > KScreenHeight/KScreenWidth) {
        CGFloat w = KScreenWidth;
        CGFloat h = w/image.size.width * image.size.height;
        return CGRectMake(0, 0, w, h);
    }
    return KBounds;
}

- (void)transitionCompleteAnimation{
    [self.view addSubview:_collectionView];
    if (_imageArray.count > 1) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.center = CGPointMake(KScreenWidth/2, KScreenHeight - 30);
        _label.text = [NSString stringWithFormat:@"%ld/%ld", (long) (_currentIndex+1), (long)_imageArray.count];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label];
        if (_isCanDel) {
            _delBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 50, 20, 35, 44)];
            [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_delBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            _delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_delBtn addTarget:self action:@selector(delBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_delBtn];
        }
    }
}

- (void)delBtnAction{
    NSLog(@"删除%ld", (long)_currentIndex);
    [_imageArray removeObjectAtIndex:_currentIndex];
    [_sourceArray removeObjectAtIndex:_currentIndex];
    [self reloadData];
}

- (void)reloadData{
    _currentIndex--;
    [_collectionView reloadData];
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    [_collectionView setContentOffset:CGPointMake(KScreenWidth * _currentIndex, 0) animated:YES];
    if (_imageArray.count == 1) {
        _delBtn.hidden = YES;
    }
    if (self.updateImageArrayBlock) {
        self.updateImageArrayBlock(_imageArray);
    }
    _label.text = [NSString stringWithFormat:@"%ld/%ld", (long) (_currentIndex+1), (long)_imageArray.count];
}


#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageV = _sourceArray[indexPath.item];
    [cell setImage:_imageArray[indexPath.row] placeholder:imageV.image];
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            [self setAnimatorHelper];
        };
    }
    __strong typeof(cell) weakCell = cell;
    if (!cell.longGestureBlock) {
        cell.longGestureBlock = ^(){
            [self useThisImageWith:weakCell.imageView.image];
        };
    }
    return cell;
}

- (void)useThisImageWith:(UIImage *)image{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = (offSet.x + (KScreenWidth * 0.5)) / KScreenWidth;
    _label.text = [NSString stringWithFormat:@"%ld/%ld", (long) (_currentIndex+1), (long)_imageArray.count];
}

- (void)setAnimatorHelper{
    CLImageBrowserCell *cell = (CLImageBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    UIImageView *imageView = rectArray[_currentIndex];
    if (cell) {
        FYTransitionHelper *animatorHelper = [[FYTransitionHelper alloc] initWithOriginalImageView:_sourceArray[_currentIndex] frame:imageView.frame finalImageView:cell.imageView];
        _transitionHelper = animatorHelper;
    }
    [self goBack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回
- (void)goBack{
    if (self.navigationController.delegate == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.transitioningDelegate == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (fromVC == self) {
        /// set  the Navgation's delegate is nil at this time , Otherwise the Application might explode , Boom! Boom! Boom!
        self.navigationController.delegate = nil;
        return _transitionHelper.popAnimator;
    } else if (toVC == self){
        return _transitionHelper.pushAnimator;
    }
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source {
    
    return _transitionHelper.presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return _transitionHelper.dismissAnimator;
    
}

@end
