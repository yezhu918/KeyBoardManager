//
//  ViewController.m
//  Text
//
//  Created by shiyh on 16/10/10.
//  Copyright © 2016年 xxxx. All rights reserved.
//

#import "NextViewController.h"
#import "SYHKeyBoardManager.h"

@interface NextViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic , strong) UITextField * inputView;

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * dataSource;

@property (nonatomic , strong) SYHKeyBoardManager * keyBoardManager;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationController.navigationBar.translucent = NO;
    
    _keyBoardManager  = [[SYHKeyBoardManager alloc] initWithScollerView:self.tableView];
    
    for (NSInteger i = 0; i <15; i++) {
        UITextField * t = [self cinputView];
        [_keyBoardManager managerTextField:t];
        [self.dataSource addObject:t];
    }
    
    for (NSInteger i = 0; i <15; i++) {
        UITextView * t = [self _cinputView];
        [_keyBoardManager managerTextView:t];
        [self.dataSource addObject:t];
    }
    
    for (NSInteger i = 0; i <15; i++) {
        UITextField * t = [self cinputView];
        [_keyBoardManager managerTextField:t];
        [self.dataSource addObject:t];
    }
    
    for (NSInteger i = 0; i <15; i++) {
        UITextView * t = [self _cinputView];
        [_keyBoardManager managerTextView:t];
        [self.dataSource addObject:t];
    }
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITextField *)cinputView{
 
    UITextField * inputView = [UITextField new];
    inputView.frame = CGRectMake(10, 1, self.view.frame.size.width - 60, 42);
    inputView.backgroundColor = [UIColor lightGrayColor];
    inputView.delegate = self;
    return inputView;
}

- (UITextView *)_cinputView{
    
    UITextView * inputView = [UITextView new];
    inputView.frame = CGRectMake(10,1, self.view.frame.size.width - 60, 42);
    inputView.backgroundColor = [UIColor lightGrayColor];
     inputView.delegate = self;
    return inputView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
      NSLog(@"===textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"===textFieldDidEndEditing");
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

    NSLog(@"===textViewDidBeginEditing");
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"===textViewDidBeginEditing");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UITextField * t = self.dataSource[indexPath.row];
    [cell.contentView addSubview:t];
    t.text = [NSString stringWithFormat:@"第%ld个-inputText",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

@end
