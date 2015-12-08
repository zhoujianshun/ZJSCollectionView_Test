//
//  CollectionViewCellBasic.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/11.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "CollectionViewCellBasic.h"

@implementation CollectionViewCellBasic

- (void)awakeFromNib {
    // Initialization code
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor redColor].CGColor;
}


//-(UIView*)snapshotView{
//    UIView *snapshotView = [[UIView alloc] init];
//   
//}
@end
