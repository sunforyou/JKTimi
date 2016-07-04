//
//  JKAccountModel.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account+CoreDataProperties.h"
#import "JKAccount.h"
#import "AppDelegate.h"

@interface JKAccountModel : NSObject

@property (nonatomic, strong) NSManagedObjectContext *myManagedObjectContext;

@property (nonatomic, strong) Account *myManagedObject;

/**
 *  生成模型单例
 *
 *  @return 模型实例
 */
+ (JKAccountModel *)sharedManager;

/**
 *  增加
 *
 *  @param model: JKAccountModel
 */
- (void)create:(JKAccount *)model;

/**
 *  删除
 *
 *  @param model: JKAccountModel
 */
- (void)remove:(JKAccount *)model;

/**
 *  修改
 *
 *  @param model: JKAccountModel
 */
- (void)modify:(JKAccount *)model;

/**
 *  查询
 *
 *  @return 返回当前所有模型
 */
- (NSMutableArray *)findAll;

@end
