//
//  JKCollectionViewController.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/16.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "JKDragAndDropCollectionViewLayoutViewController.h"

/** 更新数据源 */
typedef void (^updateDataSourceHandler)(NSMutableArray *newDataSource, NSDictionary *dict);

@interface JKCollectionViewController : JKDragAndDropCollectionViewLayoutViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic) updateDataSourceHandler updateListDataHandler;

/** 接收被选中的账目信息 */
@property (strong, nonatomic) id detailItem;

/** 是否为新建账目 */
@property (assign, nonatomic) BOOL isNewAccount;

@end
