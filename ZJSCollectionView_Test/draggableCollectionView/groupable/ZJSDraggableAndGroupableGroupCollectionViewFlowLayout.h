//
//  ZJSDraggableAndGroupableGroupCollectionViewFlowLayout.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/9.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "ZJSDraggableAndGroupableCollectionViewFlowLayout.h"
@class ZJSGroupViewController;

@protocol ZJSDraggableAndGroupableGroupCollectionViewDataSource <ZJSDraggableCollectionViewDataSource>

@optional

-(CGRect)collecationViewCloseRect:(UICollectionView *)collectionView;

@end

@protocol ZJSDraggableAndGroupableGroupCollectionViewFlowLayoutDelegate <ZJSDraggableCollectionViewFlowLayoutDelegate>

-(void)collecationView:(UICollectionView*)collectionView closeGroupWithItem:(id)item;

@end

@interface ZJSDraggableAndGroupableGroupCollectionViewFlowLayout : ZJSDraggableAndGroupableCollectionViewFlowLayout

/**
 *  0~1, default 1.
 */
@property (nonatomic) CGFloat scale;

-(void)setScaleWithAnimation:(CGFloat)scale;

@end
