//
//  JKNumberKeyboardViewController.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/20.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@interface JKNumberKeyboardViewController : UIViewController

/**
 *  抛物线动画终点占位图
 */
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

/**
 *  类目标签
 */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

/**
 *  生成键盘控制器实例
 */
+ (instancetype)viewControllerFromXIB;

/**
 *  推出键盘
 *
 *  @param priceString  账目金额
 *  @param category     账目类型
 */
- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString withAccountType:(NSString *)category;

- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString;

- (void)displayNumKeyboardViewAnimateByDistance:(CGFloat)distance;

/**
 *  隐藏键盘
 *
 *  @param isConfirm input YES to transform value
 */
- (void)hideNumKeyboardViewWithAnimationByDistance:(CGFloat)distance;

@end
