//
//  ZJSSelectableCategoryFlowLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSSelectableCategoryFlowLayout.h"

@implementation ZJSSelectableCategoryFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UICollectionViewLayoutAttributes *att = obj;
//        if (att.indexPath == [[self.collectionView indexPathsForSelectedItems] firstObject]) {
//            att.size = CGSizeMake(self.itemSize.width*1.2, self.itemSize.height*1.2);
//        }else{
//            att.transform = CGAffineTransformIdentity;
//        }
//    }];
    
    return array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
//    if (att.indexPath == [[self.collectionView indexPathsForSelectedItems] firstObject]) {
//        att.size = CGSizeMake(self.itemSize.width*1.2, self.itemSize.height*1.2);
//    }else{
//        att.transform = CGAffineTransformIdentity;
//    }
    
    return att;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity ];
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//    }
//    
//    NSIndexPath *indexPath =  [self.collectionView indexPathForItemAtPoint:CGPointMake(horizontalCenter, CGRectGetMidY(self.collectionView.bounds))];
//    if (indexPath) {
//        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


//-(NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position{
//        NSIndexPath *indexPath = [super targetIndexPathForInteractivelyMovingItem:previousIndexPath withPosition:position];
//    NSLog(@"targetIndexPathForInteractivelyMovingItem");
//    return indexPath;
//}



@end
