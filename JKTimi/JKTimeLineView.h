//
//  JKTimeLineView.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@protocol JKTimeLineViewDelegate <NSObject>

/**
 *  当编辑按钮被按下,跳转至编辑页面并传递要编辑的账目信息
 *
 *  @param indexPath    序号
 *  @param sender       按钮
 */
- (void)editButtonClickedToPerformSegueAtIndexPath:(NSInteger)indexPath sender:(id)sender;

/**
 *  当删除按钮被按下,弹出警告框
 */
- (void)showAlertViewWithListData:(NSMutableArray *)dataSource atIndexPath:(NSInteger)indexPath;

@end

@interface JKTimeLineView : UIView

@property (nonatomic, assign) id<JKTimeLineViewDelegate>delegate;

/**
 *  数据源缓存
 */
@property (nonatomic, strong) NSMutableArray *listData;


/**
 *  生成JKTimeLineView的实例
 *
 *  @param frame
 *  @param dataSource
 *
 *  @return
 */
+ (JKTimeLineView *)createTimeLineViewWithFrame:(CGRect)frame withData:(NSMutableArray *)dataSource;

@end
