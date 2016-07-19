//
//  CLCollectionViewLayout.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLCollectionViewLayout.h"

@interface CLCollectionViewLayout ()

@property (nonatomic) CGFloat width;    // collectionView宽
@property (nonatomic) CGFloat height;   // collectionView高

@property (nonatomic,strong)NSMutableArray *itemsAttributes;    //保存所有列高度的数组

@end

@implementation CLCollectionViewLayout

- (CGFloat)width{
    return self.collectionView.frame.size.width;
}

- (CGFloat)height{
    return self.collectionView.frame.size.height;
}

-(void)prepareLayout{
    //确定所有item的个数
    NSUInteger itemCounts = [[self collectionView]numberOfItemsInSection:0];
    //初始化保存所有item attributes的数组
    self.itemsAttributes = [NSMutableArray arrayWithCapacity:itemCounts];
    [self setAttributes:itemCounts];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.itemsAttributes;
}

- (void)setAttributes:(NSInteger)count{
    for (int i = 0; i < count; i++) {
        //给attributes.frame 赋值，并存入 self.itemsAttributes
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGRect itemFrame;
        switch (count) {
            case 1:
                itemFrame = [self imagesOfOneWith:i];
                break;
            case 2:
                itemFrame = [self imagesOfTwoWith:i];
                break;
            case 3:
                itemFrame = [self imagesOfThreeWith:i];
                break;
            case 4:
                itemFrame = [self imagesOfFourWith:i];
                break;
            case 5:
                itemFrame = [self imagesOfFiveWith:i];
                break;
            case 6:
                itemFrame = [self imagesOfSixWith:i];
                break;
            case 7:
                itemFrame = [self imagesOfSevenWith:i];
                break;
            case 8:
                itemFrame = [self imagesOfEightWith:i];
                break;
            case 9:
                itemFrame = [self imagesOfNineWith:i];
                break;
            default:
                break;
        }
        attributes.frame = itemFrame;
        [self.itemsAttributes addObject:attributes];
    }
}


-(CGRect)imagesOfOneWith:(NSInteger)row{
    return CGRectMake(0, 0, self.width, self.height);
}


-(CGRect)imagesOfTwoWith:(NSInteger)row{
    CGFloat _w = self.width/2;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, _w, self.height);
            break;
        case 1:
            itemFrame = CGRectMake(_w, 0, _w, self.height);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfThreeWith:(NSInteger)row{
    CGFloat bigH = self.height/5 * 3;
    CGFloat smallH = self.height/5 * 2;
    CGFloat smallW = self.width/2;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, self.width, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(0, bigH, smallW, smallH);
            break;
        case 2:
            itemFrame = CGRectMake(smallW, bigH, smallW, smallH);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfFourWith:(NSInteger)row{
    CGFloat bigH = self.height/3 * 2;
    CGFloat smallW = self.width/3;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, self.width, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(0, bigH, smallW, smallW);
            break;
        case 2:
            itemFrame = CGRectMake(smallW, bigH, smallW, smallW);
            break;
        case 3:
            itemFrame = CGRectMake(smallW*2, bigH, smallW, smallW);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfFiveWith:(NSInteger)row{
    CGFloat rightW = self.width/3;
    CGFloat bigH = rightW * 2;
    CGFloat downW = self.width/2;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, bigH, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(bigH, 0, rightW, rightW);
            break;
        case 2:
            itemFrame = CGRectMake(bigH, rightW, rightW, rightW);
            break;
        case 3:
            itemFrame = CGRectMake(0, bigH, downW, downW);
            break;
        case 4:
            itemFrame = CGRectMake(downW, bigH, downW, downW);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfSixWith:(NSInteger)row{
    CGFloat small = self.width/3;
    CGFloat bigH = small * 2;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, bigH, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(bigH, 0, small, small);
            break;
        case 2:
            itemFrame = CGRectMake(bigH, small, small, small);
            break;
        case 3:
            itemFrame = CGRectMake(0, bigH, small, small);
            break;
        case 4:
            itemFrame = CGRectMake(small, bigH, small, small);
            break;
        case 5:
            itemFrame = CGRectMake(small*2, bigH, small, small);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfSevenWith:(NSInteger)row{
    CGFloat bigH = self.height/2;
    CGFloat small = self.width/3;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, self.width, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(0, bigH, small, small);
            break;
        case 2:
            itemFrame = CGRectMake(small, bigH, small, small);
            break;
        case 3:
            itemFrame = CGRectMake(small*2, bigH, small, small);
            break;
        case 4:
            itemFrame = CGRectMake(0, bigH+small, small, small);
            break;
        case 5:
            itemFrame = CGRectMake(small, bigH+small, small, small);
            break;
        case 6:
            itemFrame = CGRectMake(small*2, bigH+small, small, small);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfEightWith:(NSInteger)row{
    CGFloat bigH = self.width/2;
    CGFloat small = self.width/3;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, bigH, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(bigH, 0, bigH, bigH);
            break;
        case 2:
            itemFrame = CGRectMake(0, bigH, small, small);
            break;
        case 3:
            itemFrame = CGRectMake(small, bigH, small, small);
            break;
        case 4:
            itemFrame = CGRectMake(small*2, bigH, small, small);
            break;
        case 5:
            itemFrame = CGRectMake(0, bigH+small, small, small);
            break;
        case 6:
            itemFrame = CGRectMake(small, bigH+small, small, small);
            break;
        case 7:
            itemFrame = CGRectMake(small*2, bigH+small, small, small);
            break;
        default:
            break;
    }
    return itemFrame;
}

-(CGRect)imagesOfNineWith:(NSInteger)row{
    CGFloat bigH = self.height/5 *3;
    CGFloat small = self.width/4;
    CGRect itemFrame;
    switch (row) {
        case 0:
            itemFrame = CGRectMake(0, 0, self.width, bigH);
            break;
        case 1:
            itemFrame = CGRectMake(0, bigH, small, small);
            break;
        case 2:
            itemFrame = CGRectMake(small, bigH, small, small);
            break;
        case 3:
            itemFrame = CGRectMake(small*2, bigH, small, small);
            break;
        case 4:
            itemFrame = CGRectMake(small*3, bigH, small, small);
            break;
        case 5:
            itemFrame = CGRectMake(0, bigH+small, small, small);
            break;
        case 6:
            itemFrame = CGRectMake(small, bigH+small, small, small);
            break;
        case 7:
            itemFrame = CGRectMake(small*2, bigH+small, small, small);
            break;
        case 8:
            itemFrame = CGRectMake(small*3, bigH+small, small, small);
            break;
        default:
            break;
    }
    return itemFrame;
}

@end
