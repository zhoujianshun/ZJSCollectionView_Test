//
//  ZJSDraggableCollectionViewFlowLayout.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/20.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSDraggableCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,getter=isEdit) BOOL edit;
@property (nonatomic,assign) BOOL panGestureRecognizerEnable;

@end

@protocol ZJSDraggableCollectionViewDataSource <UICollectionViewDataSource>

@optional
- (BOOL)collecationView:(UICollectionView *)collectionView
canMovewItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)sourceIndexPath
   canMovewToIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView
      itemAtIndexPath:(NSIndexPath *)sourceIndexPath
  willMoveToIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)collectionView:(UICollectionView *)collectionView
      itemAtIndexPath:(NSIndexPath *)dourceIndexPath
   didMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol ZJSDraggableCollectionViewFlowLayoutDelegate <UICollectionViewDelegate>

@optional
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end
