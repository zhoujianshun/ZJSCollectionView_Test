//
//  CircleLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/12.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "CircleLayout.h"

static CGFloat itemWidth = 50;
static CGFloat itemHeight = 50;

@implementation CircleLayout

-(void)prepareLayout{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _center = CGPointMake(size.width/2, size.height/2);
     _radius = MIN(size.width, size.height) / 2.5;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
}

-(CGSize)collectionViewContentSize{
    return self.collectionView.frame.size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(itemWidth, itemHeight);
    
    CGFloat centerX = self.center.x +self.radius*cosf(2*M_PI*indexPath.item/self.cellCount);
    CGFloat centerY = self.center.y+ self.radius*sinf(2*M_PI*indexPath.item/self.cellCount);
    attributes.center = CGPointMake(centerX, centerY);
    
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{

    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.cellCount; i++) {
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        if (i == 0) {
//            att.center = self.center;
//        }
//        
        [attributes addObject:att];
    }

    return attributes;
}

//-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems{
//
//    [updateItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        UICollectionViewUpdateItem *item = obj;
//        
//        if (item.updateAction == UICollectionUpdateActionInsert) {
//                UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:item.indexPathAfterUpdate];
//                att.center = self.center;
//                att.alpha = 0.1;
//            
//    
//        }else if(item.updateAction == UICollectionUpdateActionDelete){
//                UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:item.indexPathAfterUpdate];
//                att.center = self.center;
//                att.alpha = 0.1;
//                att.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.f);
//        }
//        
//    }];
//
//}

//
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if (itemIndexPath.item == self.cellCount - 1) {
        att.center = self.center;
        att.alpha = 0.1;
    }

    return att;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if (itemIndexPath.item == self.cellCount - 1) {
        att.center = self.center;
        att.alpha = 0.1;
        att.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.f);
    }
    return att;
}

@end
