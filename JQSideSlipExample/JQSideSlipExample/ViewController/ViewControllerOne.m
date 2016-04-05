//
//  ViewControllerOne.m
//  JQSideSlipDemo
//
//  Created by Evan on 16/3/30.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "ViewControllerOne.h"
#import "JQSideSlipViewController.h"

@interface ViewControllerOne ()

@end

@implementation ViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
    [self menuView];
}

- (void)menuView
{
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_我的灰"] style:UIBarButtonItemStylePlain target:self  action:@selector(menuAction)];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)menuAction
{
    [self.tabBarController.sideSlipViewController showLeftViewController:YES animated:YES];
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
