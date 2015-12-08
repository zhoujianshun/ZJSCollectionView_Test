//
//  ViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/11.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "ViewController.h"
#import "Group2ViewController.h"

@interface ViewController ()<UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
        Group2ViewController *vc = [Group2ViewController group2ViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

@end
