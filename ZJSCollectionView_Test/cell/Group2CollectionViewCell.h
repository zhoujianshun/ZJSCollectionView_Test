//
//  Group2CollectionViewCell.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/10/29.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
@class Group2CollectionViewCell;

#define GROUP2_CELL_DELETE_PADDING 15

typedef void(^DeleteBlock)(Group2CollectionViewCell*);

@interface Group2CollectionViewCell : UICollectionViewCell

@property (nonatomic) BOOL isEdit;
@property (nonatomic,copy) DeleteBlock deleteBlock;
@property (nonatomic,strong) MyObject *myObject;

@end
