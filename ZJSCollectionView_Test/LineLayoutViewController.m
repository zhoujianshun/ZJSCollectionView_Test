//
//  LineLayoutViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/11.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "LineLayoutViewController.h"

#import "CollectionViewCellBasic.h"
#import "CircleLayout.h"
#import "LineLayout.h"

@interface LineLayoutViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *array;

@end

static NSString *identify = @"basicIdentify";

@implementation LineLayoutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"lineLayout";

    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellBasic" bundle:nil] forCellWithReuseIdentifier:identify];
    
    self.array = [[NSMutableArray alloc] init];
    for (int i= 0; i<10; i++) {
        [self.array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource= self;
    
    self.collectionView.collectionViewLayout = [[LineLayout alloc] init];
    self.collectionView.backgroundColor = [UIColor purpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCellBasic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    cell.detailLabel.text = [self.array objectAtIndex:row];
    
    
    return cell;

}
- (IBAction)change:(id)sender {
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[CircleLayout class]]) {
        
        [self.collectionView setCollectionViewLayout:[[LineLayout alloc] init] animated:YES];
        
    }else{
        
        
        [self.collectionView setCollectionViewLayout:[[CircleLayout alloc] init] animated:YES];
        
    }
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(100, 100);
//}

@end
