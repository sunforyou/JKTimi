//
//  JKModelManager.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account+CoreDataProperties.h"
#import "JKAccountModel.h"

@interface JKModelManager : NSObject

/**
 *  插入Account
 *
 *  @param model: JKAccount
 *
 *  @return 改动后的数据库
 */
- (NSMutableArray *)create:(JKAccount *)model;

/**
 *  删除Account
 *
 *  @param model: JKAccount
 *
 *  @return 改动后的数据库
 */
- (NSMutableArray *)remove:(JKAccount *)model;

/**
 *  修改Account
 *
 *  @param model: JKAccount
 *
 *  @return 改动后的数据库
 */
- (NSMutableArray *)modify:(JKAccount *)model;

/**
 *  查询当前数据
 *
 *  @return 当前数据
 */
- (NSMutableArray *)findAll;

@end
