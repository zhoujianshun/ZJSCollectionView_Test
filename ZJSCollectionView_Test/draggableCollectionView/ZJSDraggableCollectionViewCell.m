//
//  ZJSDraggableCollectionViewCell.m
//  huashida_home
//
//  Created by 周建顺 on 15/11/25.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "ZJSDraggableCollectionViewCell.h"

@implementation ZJSDraggableCollectionViewCell


- (UIView *)snapshotView{
    return [self snapshotViewAfterScreenUpdates:NO];
}

@end
