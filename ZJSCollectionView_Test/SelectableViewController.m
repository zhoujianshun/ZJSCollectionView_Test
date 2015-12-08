//
//  SelectableViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "SelectableViewController.h"
#import "ZJSSelectabelCategoryView.h"

@interface SelectableViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet ZJSSelectabelCategoryView *categoryView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SelectableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.categoryView.backgroundColor = [UIColor magentaColor];
    NSArray *array = @[@"全部",
                              @"教材电镀",
                              @"我要做书",
                              @"4D科普",
                              @"课外阅读",
                              @"美慧树系列",
                              @"我们爱科学",
                              @"4D认知卡",
                       @"4D绘本",
                       @"4D魔镜",];
   
    
    self.categoryView.categories = array;
    self.categoryView.selectedIndex = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.categoryView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    self.scrollView.pagingEnabled = YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentSize =CGSizeMake( width*array.count, self.scrollView.bounds.size.height);
    for (int i = 0 ; i<array.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(width*i, 0, width, self.scrollView.bounds.size.height);
        view.backgroundColor = [self randomColor];
        [self.scrollView addSubview:view];
    }
    
    self.scrollView.delegate = self;
}

-(UIColor *)randomColor{
        int i = arc4random()%8;
    switch (i) {
        case 0:
        {
            return [UIColor redColor];
        }
            break;
        case 1:
        {
            return [UIColor yellowColor];
        }
            break;
        case 2:
        {
            return [UIColor blueColor];
        }
            break;
        case 3:
        {
            return [UIColor purpleColor];
        }
            break;
        case 4:
        {
            return [UIColor grayColor];
        }
            break;
        case 5:
        {
            return [UIColor greenColor];
        }
            break;
        case 6:
        {
            return [UIColor orangeColor];
        }
            break;
        case 7:
        {
            return [UIColor brownColor];
        }
            break;
        default:
            break;
    }
    
    return [UIColor magentaColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.categoryView removeObserver:self forKeyPath:@"selectedIndex"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)preTapped:(id)sender {
    if (self.categoryView.selectedIndex>0) {
            [self.categoryView setSelectedIndex:self.categoryView.selectedIndex - 1 withAnimation:YES];
    }

}
- (IBAction)nextTapped:(id)sender {
    if (self.categoryView.selectedIndex < 19) {
            [self.categoryView setSelectedIndex:self.categoryView.selectedIndex + 1 withAnimation:YES] ;
    }

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        self.indexLabel.text = [NSString stringWithFormat:@"%@",[change objectForKey:@"new"]];
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [self.scrollView setContentOffset:CGPointMake(self.categoryView.selectedIndex * width, 0) animated:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset:%f",scrollView.contentOffset.x);
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetX = self.categoryView.selectedIndex * width;
    int index;
    if (offsetX<currentOffsetX) {
         index = (scrollView.contentOffset.x)/width;
    }else{
        index = (scrollView.contentOffset.x + width - 1)/width;
    }

    CGFloat scale = (scrollView.contentOffset.x - offsetX)/width;
    self.categoryView.scale = scale;
    
    [self.categoryView setSelectedIndex:index withAnimation:NO];
    NSLog(@"scale:%f",scale);
}

@end
