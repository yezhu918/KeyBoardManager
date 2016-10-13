//
//  ViewController.m
//  Text
//
//  Created by shiyh on 16/10/10.
//  Copyright © 2016年 xxxx. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *lab = [UILabel new];
    lab.frame = self.view.bounds;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:21];
    lab.text = @"Touch Me !";
    [self.view addSubview:lab];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NextViewController * nextVC = [NextViewController new];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:nextVC];
    nextVC.title = @"NextVC";
    [self presentViewController:nav animated:YES completion:nil];
}


@end
