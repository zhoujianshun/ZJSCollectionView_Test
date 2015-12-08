//
//  Group2ObjectCollectionViewCell.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/10/29.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "Group2ObjectCollectionViewCell.h"

@interface Group2ObjectCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@end

@implementation Group2ObjectCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myContentView.layer.cornerRadius = 3;
    self.myContentView.layer.masksToBounds = YES;
}

- (IBAction)downloadTapped:(id)sender {
    
    if (self.downloadTapped) {
        self.downloadTapped(self);
    }
    
}

-(void)setMyObject:(MyObject *)myObject{
    _myObject = myObject;
    self.label.text = myObject.name;
    
}

@end
