//
//  Account+CoreDataProperties.h
//  JKTimi
//
//  Created by 宋旭 on 16/6/8.
//  Copyright © 2016年 sky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *category;
/** 状态码,留用接口 */
@property (nullable, nonatomic, retain) NSNumber *statusCode;
@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *tid;

@end

NS_ASSUME_NONNULL_END
