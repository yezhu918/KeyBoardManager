//
//  HKKeyBoardManager.h
//  Text
//
//  Created by shiyh on 16/10/10.
//  Copyright © 2016年 hkqj. All rights reserved.
//
/**
 * --管理键盘确保不遮挡输入框
 * 使用须知：
 * 1. TextField TextView 必须在一个scollerView上
 * 2. TextField.delegate设置 必须在managerTextField调用前(否则功能失效)
 * 3. UITextView.delegate设置 必须在managerTextView调用前(否则功能失效)
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYHKeyBoardManager : NSObject

- (instancetype)initWithScollerView:(UIScrollView *)scrollerView;
- (void)managerTextField:(UITextField *)text;
- (void)managerTextView:(UITextView *)text;

@end
