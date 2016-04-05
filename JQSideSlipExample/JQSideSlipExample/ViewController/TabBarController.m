//
//  TabBarController.m
//  JQSideSlipDemo
//
//  Created by Evan on 16/3/30.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TabBarController.h"

#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"
#import "ViewControllerThree.h"
#import "ViewControllerFour.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (void)initialize
{
    // 设置导航栏颜色
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:((float)((0x46bc62 & 0xFF0000) >> 16))/255.0 green:((float)((0x46bc62 & 0xFF00) >> 8))/255.0 blue:((float)(0x46bc62 & 0xFF))/255.0 alpha:1.0]} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewControllerOne *oneVC = [[ViewControllerOne alloc] init];
    oneVC.title = @"主页";
    oneVC.tabBarItem.image = [[UIImage imageNamed:@"icon_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    oneVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ViewControllerTwo *twoVC = [[ViewControllerTwo alloc] init];
    twoVC.title = @"主页";
    twoVC.tabBarItem.image = [[UIImage imageNamed:@"icon_study"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    twoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_study_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ViewControllerThree *threeVC = [[ViewControllerThree alloc] init];
    threeVC.title = @"主页";
    threeVC.tabBarItem.image = [[UIImage imageNamed:@"icon_weicourse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    threeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_weicourse_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ViewControllerFour *fourVC = [[ViewControllerFour alloc] init];
    fourVC.title = @"主页";
    fourVC.tabBarItem.image = [[UIImage imageNamed:@"icon_问吧"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fourVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_问吧_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:oneVC], [[UINavigationController alloc] initWithRootViewController:twoVC], [[UINavigationController alloc] initWithRootViewController:threeVC], [[UINavigationController alloc] initWithRootViewController:fourVC]];
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

@end
