//
//  Group2CollectionViewCell.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/10/29.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "Group2CollectionViewCell.h"

static NSString * const kVibrateAnimation = @"kVibrateAnimation";
static CGFloat const VIBRATE_DURATION = 0.1;
static CGFloat const VIBRATE_RADIAN = M_PI / 96;

@interface Group2CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *label;


@property (nonatomic,assign) BOOL vibrating;

@end

@implementation Group2CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myContentView.layer.cornerRadius = 3;
    self.myContentView.layer.masksToBounds = YES;
    
    self.deleteButton.layer.cornerRadius = self.deleteButton.bounds.size.width/2;
    self.deleteButton.layer.masksToBounds = YES;
}


- (IBAction)deleteButtonTapped:(id)sender {
    NSLog(@"deleteButtonTapped");
    
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

-(void)setMyObject:(MyObject *)myObject{
    _myObject = myObject;
    self.label.text = myObject.name;

}

#pragma mark - getter setter

-(BOOL)isEdit{
    return self.vibrating;
}

-(void)setIsEdit:(BOOL)isEdit{
    self.vibrating = isEdit;
    self.deleteButton.hidden = !isEdit;
    
}


- (BOOL)vibrating
{
    return [self.layer.animationKeys containsObject:kVibrateAnimation];
}

- (void)setVibrating:(BOOL)vibrating
{
    BOOL _vibrating = [self.layer.animationKeys containsObject:kVibrateAnimation];
    
    if (_vibrating && !vibrating) {
        [self.layer removeAnimationForKey:kVibrateAnimation];
    }
    else if (!_vibrating && vibrating) {
        CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        vibrateAnimation.fromValue = @(- VIBRATE_RADIAN);
        vibrateAnimation.toValue = @(VIBRATE_RADIAN);
        vibrateAnimation.autoreverses = YES;
        vibrateAnimation.duration = VIBRATE_DURATION;
        vibrateAnimation.repeatCount = CGFLOAT_MAX;
        [self.layer addAnimation:vibrateAnimation forKey:kVibrateAnimation];
    }
}

@end
