//
//  ZJSDraggableAndGroupableCollectionViewFlowLayout.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/6.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "ZJSDraggableCollectionViewFlowLayout.h"

@interface ZJSDraggableAndGroupableCollectionViewFlowLayout : UICollectionViewLayout
@property (nonatomic,getter=isEdit) BOOL edit;
//@property (nonatomic,assign) BOOL panGestureRecognizerEnable;
@end


@protocol ZJSDraggableAndGroupableCollectionViewDataSource <ZJSDraggableCollectionViewDataSource>

@optional

-(BOOL)collecationView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath;
-(void)collecationView:(UICollectionView *)collectionView willMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath;

@end

@protocol ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate <ZJSDraggableCollectionViewFlowLayoutDelegate>


@end
