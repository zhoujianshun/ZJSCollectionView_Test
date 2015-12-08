//
//  GroupViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/9/22.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "GroupViewController.h"
#import "CollectionViewCellBasic.h"
#import "MyCollectionReusableView.h"
#import "MyGroup.h"

@interface GroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSMutableDictionary *dict;


@end

static NSString *identify = @"basicIdentify";
static NSString *identifyHeader = @"HeaderIdentify";

@implementation GroupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基本使用";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellBasic" bundle:nil] forCellWithReuseIdentifier:identify];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyHeader];
    
    
    self.dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i <5; i++) {
        NSString *key = [NSString stringWithFormat:@"group:%i",i];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<20; j++) {
            [array addObject:[NSString stringWithFormat:@"%d",j]];
        }
        
        MyGroup *group = [[MyGroup alloc] init];
        group.name = key;
        group.array = array;
        [self.dict setObject:group forKey:key];
    }
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource= self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(self.collectionView.frame.size.width, 50);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dict.allKeys.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
      MyGroup *group = [self.dict valueForKey:self.dict.allKeys[section]];
    
    if (section ==0 ) {
        if (group.array.count>3&&(!group.isOpen)) {
            return 3;
        }
       
    }

    return group.array.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCellBasic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    MyGroup *group = [self.dict valueForKey:self.dict.allKeys[indexPath.section]];

    cell.detailLabel.text = [NSString stringWithFormat:@"%@(%li,%li)",[group.array objectAtIndex:indexPath.row],indexPath.section,indexPath.row];
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        MyCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyHeader forIndexPath:indexPath];
         MyGroup *group = [self.dict valueForKey:self.dict.allKeys[indexPath.section]];
        reusableView.titleLabel.text = [NSString stringWithFormat:@"%@(%li)",group.name,group.array.count];
        if (indexPath.section == 0&&group.array.count>3) {
            
            if (group.isOpen) {
                [reusableView.showButton setTitle:@"hide" forState:UIControlStateNormal];
            }else{
                [reusableView.showButton setTitle:@"show" forState:UIControlStateNormal];
            }
            reusableView.tap = ^(NSInteger section){
                NSLog(@"%li",section);
                MyGroup *group = [self.dict valueForKey:self.dict.allKeys[section]];
                group.isOpen = !group.isOpen;
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            };

            reusableView.showButton.hidden = NO;
        }else{
          reusableView.tap = nil;
            reusableView.showButton.hidden = YES;
        }
        
        return reusableView;
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.collectionView.frame.size.width-10*2-10*2)/3;
    return CGSizeMake(width, width);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 50; // 最小行间距
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10; // 最小列间距
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30, 10, 30, 10);
}

@end
