//
//  ZJSSelectableCategoryCell.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSSelectableCategoryCell.h"

#define TITLE_SCALE 1/1.2

#define TITLT_FONT [UIFont systemFontOfSize:16.f]

#define TITLE_COLOR_SELECTED [UIColor colorWithRed:33.f/255.f green:233.f/255.f blue:160.f/255.f alpha:1.f]
#define TITLE_COLOR [UIColor colorWithRed:142.f/255.f green:142.f/255.f blue:142.f/255.f alpha:1.f]

@interface ZJSSelectableCategoryCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation ZJSSelectableCategoryCell

- (void)awakeFromNib {
    // Initialization code
    //self.backgroundColor = [UIColor redColor];
    self.titleLabel.font = TITLT_FONT;
    self.titleLabel.textColor = TITLE_COLOR;
    self.titleLabel.transform = CGAffineTransformMakeScale(TITLE_SCALE, TITLE_SCALE);
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(NSString *)title{
    return self.titleLabel.text;
}

-(void)setChecked:(BOOL)checked withAnimation:(BOOL) animation{
    if (_checked != checked) {
        
        if (animation) {
            if (checked) {
                // 选中
                if (!_checked) {
                    // 此时状态为未选中
                    [UIView animateWithDuration:0.2f animations:^{
                        self.titleLabel.textColor = TITLE_COLOR_SELECTED;
                        //self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                        self.titleLabel.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        
                    }];
                }else{
                    self.titleLabel.textColor = TITLE_COLOR_SELECTED;
                    //self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    self.titleLabel.transform = CGAffineTransformIdentity;
                }
            }else{
                // 取消选中
                
                if (_checked) {
                    // 此时状态为选中
                    //self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    self.titleLabel.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:0.2f animations:^{
                        self.titleLabel.textColor = TITLE_COLOR;
                        //self.titleLabel.transform = CGAffineTransformIdentity;
                        self.titleLabel.transform = CGAffineTransformMakeScale(TITLE_SCALE, TITLE_SCALE);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else{
                    self.titleLabel.textColor = TITLE_COLOR;
                    //self.titleLabel.transform = CGAffineTransformIdentity;
                    self.titleLabel.transform = CGAffineTransformMakeScale(TITLE_SCALE, TITLE_SCALE);
                }
                
            }
            
            
             _checked = checked;
        }else{
            [self setChecked:checked];
        
        }

    }

}

-(void)setChecked:(BOOL)checked{
    if (_checked !=checked) {
        _checked = checked;
        if (checked) {
            self.titleLabel.textColor = TITLE_COLOR_SELECTED;
            //self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.titleLabel.transform = CGAffineTransformIdentity;
        }else{
            self.titleLabel.textColor = TITLE_COLOR;
            //self.titleLabel.transform = CGAffineTransformIdentity;
            self.titleLabel.transform = CGAffineTransformMakeScale(TITLE_SCALE, TITLE_SCALE);
        }
    }
    
    

}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    if (self.checked) {
        //self.titleLabel.transform = CGAffineTransformMakeScale(1.2-(1- 1/1.2)*scale, 1.2-(1- 1/1.2)*scale);
        self.titleLabel.transform = CGAffineTransformMakeScale(1-(1- TITLE_SCALE)*scale, 1-(1- TITLE_SCALE)*scale);
        self.titleLabel.textColor = [UIColor colorWithRed:(33+ (142 - 33)*scale)/255.f green:(233+ (142 - 233)*scale)/255.f blue:(160+ (142 - 160)*scale)/255.f alpha:1.f];
    }else{
    
        //self.titleLabel.transform = CGAffineTransformMakeScale(1+(0.2)*scale, 1+(0.2)*scale);
        self.titleLabel.transform = CGAffineTransformMakeScale(TITLE_SCALE+(1 - TITLE_SCALE)*scale, TITLE_SCALE+(1 - TITLE_SCALE)*scale);
        self.titleLabel.textColor = [UIColor colorWithRed:(142+ (-109)*scale)/255.f green:(142+ 91*scale)/255.f blue:(142+ 18*scale)/255.f alpha:1.f];
   
    }
    
}

+(CGSize)cellSizeWithTitle:(NSString *)title isSelected:(BOOL)selected{
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:TITLT_FONT}];
    return CGSizeMake(size.width +16, size.height);
}

@end
