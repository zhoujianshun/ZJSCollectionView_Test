//
//  Group2ObjectCollectionViewCell.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/10/29.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
@class Group2ObjectCollectionViewCell;

typedef void(^DownloadTapped)(Group2ObjectCollectionViewCell *);

@interface Group2ObjectCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) MyObject *myObject;
@property (nonatomic,copy) DownloadTapped downloadTapped;

@end
