//
//  ViewController.m
//  XQRollingCycleView
//
//  Created by 用户 on 16/9/1.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import "ViewController.h"
#import "XQRollingCycleView.h"

@interface ViewController () <XQRollingCycleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *images = @[@"a1.jpg", @"a2.jpg", @"a3.jpg", @"a4.jpg", @"a5.jpg", @"a6.jpg", @"a7.jpg", @"a8.jpg", @"a9.jpg"];
    XQRollingCycleView *rollingCycleView = [XQRollingCycleView rollingCycleViewWithImages:images delegate:self];
    rollingCycleView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 150);
    [self.view addSubview:rollingCycleView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didSelectIndex:(NSInteger)selectIndex RollingCycleView:(XQRollingCycleView *)rollingCycleView
{
    NSLog(@"\nselectIndex-->%ld",selectIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
