//
//  JKAccount.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKAccount : NSObject

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSDate *timeStamp;

@end
