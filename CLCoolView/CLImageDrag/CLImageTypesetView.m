//
//  CLImageTypesetView.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLImageTypesetView.h"
#import "CLCollectionViewLayout.h"
#import "CLImageCell.h"

#define CLScreenWidth   [UIScreen mainScreen].bounds.size.width

@interface CLImageTypesetView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

static  NSString *cellIdentifier = @"imageTypesetCell";
@implementation CLImageTypesetView

- (instancetype)initWithFrame:(CGRect)frame{
    CLCollectionViewLayout *layout = [[CLCollectionViewLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.delegate = self;
        self.dataSource = self;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self registerNib:[UINib nibWithNibName:@"CLImageCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)setImagesWithImageArray:(NSArray *)imageArray point:(CGPoint)point{
    self.imageArray = [imageArray mutableCopy];
    CGFloat x = point.x;
    CGFloat y = point.y;
    CGFloat w = CLScreenWidth - 2*x;
    CGFloat h = [self getHeightWith:imageArray.count width:w];
    self.frame = CGRectMake(x, y, w, h);
    [self reloadData];
}

- (void)reloadData{
    CGFloat h = [self getHeightWith:self.imageArray.count width:self.frame.size.width];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h);
    [super reloadData];
}

//  根据数组个数 得到collection高度
- (CGFloat)getHeightWith:(NSInteger)count width:(CGFloat)width{
    CGFloat height = width;
    switch (count) {
        case 1:
            height = width;
            break;
        case 2:
            height = width/2;
            break;
        case 3:
            height = width/12*15;
            break;
        case 4:
            height = width;
            break;
        case 5:
            height = width/12*14;
            break;
        case 6:
            height = width;
            break;
        case 7:
            height = width/12*16;
            break;
        case 8:
            height = width/12*14;
            break;
        case 9:
            height = width/12*15;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - collectionDataSourc&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CLImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setImage:self.imageArray[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *viewArray = [NSMutableArray array];
    for (int i = 0; i<self.imageArray.count; i++) {
        CLImageCell *cell = (CLImageCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        UIImageView *oImageView = [[UIImageView alloc] initWithImage:cell.imageView.image];
        oImageView.frame =[cell.imageView convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        [viewArray addObject:oImageView];
    }
    if (self.selectImageBlock) {
        self.selectImageBlock(indexPath.item, viewArray);
    }
}


#pragma mark - 移动手势
- (void)setMoveGesture{
    // 拖拽
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGesture:)];
    [self addGestureRecognizer:panGesture];
}

- (void)handlepanGesture:(UIGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    //判断手势状态
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            if(indexPath){
                sourceIndexPath = indexPath;
                CLImageCell *cell = (CLImageCell *)[self cellForItemAtIndexPath:indexPath];
                snapshot = [self customSnapshothotFromeView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self addSubview:snapshot];
                [UIView animateWithDuration:0.2 animations:^{
                    snapshot.center = location;
                    snapshot.alpha = 0.7;
                    cell.hidden = YES;
                }completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            snapshot.center = location;
            if(indexPath && ![indexPath isEqual:sourceIndexPath]){
                [self moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束
        {
            CLImageCell *cell = (CLImageCell *)[self cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.2 animations:^{
                snapshot.center = cell.center;
                //                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
            }completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                cell.hidden = NO;
                snapshot = nil;
            }];
            sourceIndexPath = nil;
        }
            break;
        default:
            NSLog(@"default");
            break;
    }
}

// item能从什么位置移动到什么位置,返回是否可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    [super moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
    //取出源item数据
    id objc = [self.imageArray objectAtIndex:indexPath.item];
    //从资源数组中移除该数据
    [self.imageArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.imageArray insertObject:objc atIndex:newIndexPath.item];
    if (self.updateArrayBlock) {
        self.updateArrayBlock(self.imageArray);
    }
}

- (UIView *)customSnapshothotFromeView:(UIView *)inputView{
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

// 长按手势
- (void)setLongGesture{
    // 长按
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self addGestureRecognizer:longGesture];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint location = [gesture locationInView:self];
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
        if (self.longGestureBlock) {
            self.longGestureBlock(indexPath.item);
        }
    }
}



@end
