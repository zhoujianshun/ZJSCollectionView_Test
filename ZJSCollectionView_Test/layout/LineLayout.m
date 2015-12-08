//
//  LineLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/11.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "LineLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.6

@implementation LineLayout
-(instancetype)init{
    self = [super init];
    
    if (self) {
//        self.itemSize = CGSizeMake(100, 100);
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.sectionInset = UIEdgeInsetsMake(300, 0.0, 300, 0.0);
//        self.minimumLineSpacing = -15.0;
        //self.minimumInteritemSpacing = 1;
    }
    
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake(100, 100);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(300, 0.0, 300, 0.0);
    self.minimumLineSpacing = -15.0;
}


//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
//
//    return proposedContentOffset;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{

    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        attributes.zIndex = 0;
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
             attributes.zIndex = 0;
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
            
//            if (distance>0) {
//                attributes.alpha = 0.5;
//            }
        }
    }
    return array;
}

@end
