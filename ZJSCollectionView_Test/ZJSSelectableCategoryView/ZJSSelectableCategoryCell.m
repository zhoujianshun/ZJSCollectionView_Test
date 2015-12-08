//
//  ZJSSelectableCategoryCell.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSSelectableCategoryCell.h"
#define TITLT_FONT [UIFont systemFontOfSize:15.f]
#define TITLT_FONT_SELECT [UIFont systemFontOfSize:18.f]

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
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(NSString *)title{
    return self.titleLabel.text;
}

//-(void)setSelected:(BOOL)selected{
//    
//    
//    if (self.selected!=selected) {
//        if (selected) {
//            
//            if (!self.selected) {
//                [UIView animateWithDuration:0.2f animations:^{
//                    self.titleLabel.textColor = [UIColor blueColor];
//                    
//                    self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                    
//                } completion:^(BOOL finished) {
//                    
//                    self.titleLabel.transform = CGAffineTransformIdentity;
//                    //            self.titleLabel.textColor = [UIColor blueColor];
//                    //            self.titleLabel.font = TITLT_FONT_SELECT;
//                    self.titleLabel.font = TITLT_FONT_SELECT;
//                    
//                }];
//            }else{
//                self.titleLabel.transform = CGAffineTransformIdentity;
//                //            self.titleLabel.textColor = [UIColor blueColor];
//                //            self.titleLabel.font = TITLT_FONT_SELECT;
//                self.titleLabel.font = TITLT_FONT_SELECT;
//            }
//        
//        }else{
//            
//            if (self.selected) {
////
////                self.titleLabel.font = TITLT_FONT;
//                [UIView animateWithDuration:0.2f animations:^{
//                    self.titleLabel.textColor = [UIColor blackColor];
//                    //            self.titleLabel.textColor = [UIColor blackColor];
//                    //            self.titleLabel.font = TITLT_FONT;
//                    self.titleLabel.transform = CGAffineTransformMakeScale(1/1.2, 1/1.2);
//                    self.titleLabel.transform = CGAffineTransformIdentity;
//                } completion:^(BOOL finished) {
//                    
//                    //            self.titleLabel.textColor = [UIColor blackColor];
//                    //            self.titleLabel.font = TITLT_FONT;
//                    self.titleLabel.font = TITLT_FONT;
//                    self.titleLabel.transform = CGAffineTransformIdentity;
//                    
//                }];
//            }else{
//                self.titleLabel.font = TITLT_FONT;
//                self.titleLabel.transform = CGAffineTransformIdentity;
//            }
//            
//        }
//        
//        [super setSelected:selected];
//    }
//
//}

-(void)setChecked:(BOOL)checked withAnimation:(BOOL) animation{
    if (_checked != checked) {
        
        if (animation) {
            if (checked) {
                if (!_checked) {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.titleLabel.textColor = TITLE_COLOR_SELECTED;
                        self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    } completion:^(BOOL finished) {
                        self.titleLabel.transform = CGAffineTransformIdentity;
                        self.titleLabel.font = TITLT_FONT_SELECT;
                        
                    }];
                }else{
                    self.titleLabel.transform = CGAffineTransformIdentity;
                    self.titleLabel.font = TITLT_FONT_SELECT;
                }
            }else{
                if (_checked) {
                    self.titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    self.titleLabel.font = TITLT_FONT;
                    
                    [UIView animateWithDuration:0.2f animations:^{
                        self.titleLabel.textColor = TITLE_COLOR;
                        self.titleLabel.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        self.titleLabel.font = TITLT_FONT;
                        
                    }];
                }else{
                    self.titleLabel.font = TITLT_FONT;
                    self.titleLabel.transform = CGAffineTransformIdentity;
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
            self.titleLabel.transform = CGAffineTransformIdentity;
            self.titleLabel.font = TITLT_FONT_SELECT;
            self.titleLabel.textColor = TITLE_COLOR_SELECTED;
        }else{
            self.titleLabel.transform = CGAffineTransformIdentity;
            self.titleLabel.font = TITLT_FONT;
            self.titleLabel.textColor = TITLE_COLOR;
        }
    }
    
    

}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    if (self.checked) {
        self.titleLabel.transform = CGAffineTransformMakeScale(1-(0.2)*scale, 1-(0.2)*scale);
        self.titleLabel.textColor = [UIColor colorWithRed:(33+ (142 - 33)*scale)/255.f green:(233+ (142 - 233)*scale)/255.f blue:(160+ (142 - 160)*scale)/255.f alpha:1.f];
    }else{
    
        self.titleLabel.transform = CGAffineTransformMakeScale(1+(0.2)*scale, 1+(0.2)*scale);
        self.titleLabel.textColor = [UIColor colorWithRed:(142+ (-109)*scale)/255.f green:(142+ 91*scale)/255.f blue:(142+ 18*scale)/255.f alpha:1.f];
   
    }
}

+(CGSize)cellSizeWithTitle:(NSString *)title isSelected:(BOOL)selected{
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:TITLT_FONT}];
    
//    if (selected) {
//        //size = [title sizeWithAttributes:@{NSFontAttributeName:TITLT_FONT_SELECT}];
//        size =  CGSizeMake(size.width *1.2, size.height*1.2);
//    }else{
//        //size = [title sizeWithAttributes:@{NSFontAttributeName:TITLT_FONT}];
//       
//    }
    
    return CGSizeMake(size.width +16, size.height);
}

@end
