//
//  CollectionViewCellBasic.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/11.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSDraggableCollectionViewCell.h"

@interface CollectionViewCellBasic : ZJSDraggableCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
