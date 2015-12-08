//
//  MyCollectionReusableView.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/9/22.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "MyCollectionReusableView.h"


@implementation MyCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)showButtonTapped:(id)sender {
    if (self.tap) {
            self.tap(self.section);
    }

}

@end
