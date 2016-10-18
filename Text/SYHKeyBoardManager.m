//
//  YHKeyBoardManager.m
//  Text
//
//  Created by shiyh on 16/10/10.
//  Copyright © 2016年 hkqj. All rights reserved.
//

#import "SYHKeyBoardManager.h"
#import <objc/runtime.h>

static CGFloat kSpaceTextFromKkeyBoard = 15.0f;
static NSString * const ExchangObject = @"ExchangObject";
static NSString * const IsExchangSHowMothed = @"SHowMothed";
static NSString * const IsExchangHideMothed = @"HideMothed";

@interface SYHKeyBoardManager()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic ,assign) CGFloat keyBoardHeight;
@property (nonatomic ,assign) CGFloat lastkeyBoardHeight;
@property (nonatomic , weak) UIScrollView * scorllerView;
@property (nonatomic , weak) UIView * firstResponderView;

@end

@implementation SYHKeyBoardManager

- (instancetype)initWithScollerView:(UIScrollView *)scrollerView{

    if (self = [super init]) {
        self.scorllerView = scrollerView;
        
        NSAssert(self.scorllerView,@"TextField Or TextView 所在的滚动视图不能为空...");
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notikeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        NSAssert(self.scorllerView,@"TextField Or TextView 所在的滚动视图不能为空...");
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)managerTextField:(UITextField *)text{
    
    if(text.delegate == nil){
        text.delegate = self;
    }else{
        [self exchangeUITextFieldDelegateMethed:text];
        objc_setAssociatedObject(text, (__bridge const void *)(ExchangObject), self, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)managerTextView:(UITextView *)text{
    if(text.delegate == nil){
        text.delegate = self;
    }else{
        [self exchangeUITextViewDelegateMethed:text];
        objc_setAssociatedObject(text, (__bridge const void *)(ExchangObject), self, OBJC_ASSOCIATION_ASSIGN);
    }
}

#pragma - mark NotificationHandle


- (void)notikeyboardWillShow:(NSNotification *)notification {
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;
//    NSLog(@"notikeyboardWillShow = %f",self.keyBoardHeight);
    ///二次键盘弹出修正位置
    if (self.keyBoardHeight != self.lastkeyBoardHeight  && self.firstResponderView ) {
        [self showKeyBoardHandle:self.firstResponderView];
    }

}

#pragma - mark Show-HideKeyBoardHandle

- (void)showKeyBoardHandle:(UIView *)targetView{
    
    self.firstResponderView = targetView;
    self.lastkeyBoardHeight = self.keyBoardHeight;
//    NSLog(@"showKeyBoardHandle = %f",self.keyBoardHeight);
    
    CGRect rect = [self.scorllerView.window convertRect:targetView.frame fromView:targetView.superview];
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat offset = maxY -(self.scorllerView.window.bounds.size.height - self.keyBoardHeight);
    
    if (self.scorllerView.contentOffset.y !=0) {
        offset = offset + self.scorllerView.contentOffset.y +kSpaceTextFromKkeyBoard;
    }
    
    if (offset > 0) {
        CGPoint contentOffset = CGPointMake(0, offset + kSpaceTextFromKkeyBoard);
        [ self.scorllerView setContentOffset:contentOffset animated:YES];
    }
}

- (void)hideKeyBoardHandle{
    
    self.firstResponderView = nil;
    [ self.scorllerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma - mark Delegates
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self showKeyBoardHandle:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self hideKeyBoardHandle];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showKeyBoardHandle:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self hideKeyBoardHandle];
}

#pragma - mark Exchange DelegateMotheds
- (void)exchangeUITextFieldDelegateMethed:(UITextField *)textField{
    
    id targetDelegate = textField.delegate;
    
    if (targetDelegate) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class1 = [targetDelegate class];
            Class class2 = [self class];
            
            SEL originalSelector = @selector(textFieldDidBeginEditing:);
            SEL swizzledSelector = @selector(swizzledShowKeyBoard:);
            SEL _originalSelector = @selector(textFieldDidEndEditing:);
            SEL _swizzledSelector = @selector(swizzledHideKeyBoard:);
            
            Method originalMethod = class_getInstanceMethod(class1, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class2, swizzledSelector);
            Method _originalMethod = class_getInstanceMethod(class1, _originalSelector);
            Method _swizzledMethod = class_getInstanceMethod(class2, _swizzledSelector);
            
            BOOL didAddMethod = class_addMethod(class1,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod));
            
            BOOL _didAddMethod = class_addMethod(class1,_originalSelector,
                                                 method_getImplementation(_swizzledMethod),
                                                 method_getTypeEncoding(_swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class2,swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
                method_exchangeImplementations(originalMethod, swizzledMethod);
            } else {
                objc_setAssociatedObject(class1, (__bridge const void *)(IsExchangSHowMothed), @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
            
            if (_didAddMethod) {
                class_replaceMethod(class2,
                                    _swizzledSelector,
                                    method_getImplementation(_originalMethod),
                                    method_getTypeEncoding(_originalMethod));
            } else {
                objc_setAssociatedObject(class1, (__bridge const void *)(IsExchangHideMothed), @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                method_exchangeImplementations(_originalMethod, _swizzledMethod);
            }
        });
    }
}

- (void)exchangeUITextViewDelegateMethed:(UITextView *)textView{
    
    id targetDelegate = textView.delegate;
    
    if (targetDelegate) {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            Class class1 = [targetDelegate class];
            Class class2 = [self class];
        
            SEL originalSelector = @selector(textViewDidBeginEditing:);
            SEL swizzledSelector = @selector(_swizzledShowKeyBoard:);
            SEL _originalSelector = @selector(textViewDidEndEditing:);
            SEL _swizzledSelector = @selector(_swizzledHideKeyBoard:);
            
            Method originalMethod = class_getInstanceMethod(class1, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class2, swizzledSelector);
            Method _originalMethod = class_getInstanceMethod(class1, _originalSelector);
            Method _swizzledMethod = class_getInstanceMethod(class2, _swizzledSelector);
            
            BOOL didAddMethod = class_addMethod(class1,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod));
            
            BOOL _didAddMethod = class_addMethod(class1,_originalSelector,
                                                 method_getImplementation(_swizzledMethod),
                                                 method_getTypeEncoding(_swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class2,swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
                method_exchangeImplementations(originalMethod, swizzledMethod);
            } else {
               objc_setAssociatedObject(class1, (__bridge const void *)(IsExchangSHowMothed), @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
            
            if (_didAddMethod) {
                class_replaceMethod(class2,
                                    _swizzledSelector,
                                    method_getImplementation(_originalMethod),
                                    method_getTypeEncoding(_originalMethod));
            } else {
                objc_setAssociatedObject(class1, (__bridge const void *)(IsExchangHideMothed), @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                method_exchangeImplementations(_originalMethod, _swizzledMethod);
            }
         
        });
    }
}

-(void)_swizzledShowKeyBoard:(UITextView *)targetView{
    SYHKeyBoardManager * manager = objc_getAssociatedObject(targetView, (__bridge const void *)(ExchangObject));
    if (manager) {
        [manager showKeyBoardHandle:targetView];
        BOOL isExchange = [objc_getAssociatedObject(self, (__bridge const void *)(IsExchangSHowMothed)) boolValue];
        if (isExchange) {
            [manager _swizzledShowKeyBoard:targetView];
        }
    }
}

-(void)_swizzledHideKeyBoard:(UITextView *)targetView{

    SYHKeyBoardManager * manager = objc_getAssociatedObject(targetView, (__bridge const void *)(ExchangObject));
    if (manager) {
        [manager hideKeyBoardHandle];
        BOOL isExchange = [objc_getAssociatedObject(self, (__bridge const void *)(IsExchangHideMothed)) boolValue];
        if (isExchange) {
            [manager _swizzledHideKeyBoard:targetView];
        }
    }
}

-(void)swizzledShowKeyBoard:(UITextField *)targetView{
    SYHKeyBoardManager * manager = objc_getAssociatedObject(targetView, (__bridge const void *)(ExchangObject));
    if (manager) {
        [manager showKeyBoardHandle:targetView];
        BOOL isExchange = [objc_getAssociatedObject(self, (__bridge const void *)(IsExchangSHowMothed)) boolValue];
        if (isExchange) {
           [manager swizzledShowKeyBoard:targetView];
        }
    }
}

-(void)swizzledHideKeyBoard:(UITextField *)targetView{
    SYHKeyBoardManager * manager = objc_getAssociatedObject(targetView, (__bridge const void *)(ExchangObject));
        if (manager) {
        [manager hideKeyBoardHandle];
        BOOL isExchange = [objc_getAssociatedObject(self, (__bridge const void *)(IsExchangHideMothed)) boolValue];
        if (isExchange) {
          [manager swizzledHideKeyBoard:targetView];
        }
    }
}

@end
