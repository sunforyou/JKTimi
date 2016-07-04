//
//  JKModelManager.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKModelManager.h"

@implementation JKModelManager

- (NSMutableArray*)create:(JKAccount *)model {
    JKAccountModel *accountModel = [JKAccountModel sharedManager];
    [accountModel create:model];
    
    return [accountModel findAll];
}

- (NSMutableArray*)remove:(JKAccount *)model {
    JKAccountModel *accountModel = [JKAccountModel sharedManager];
    [accountModel remove:model];
    
    return [accountModel findAll];
}

- (NSMutableArray *)modify:(JKAccount *)model {
    JKAccountModel *accountModel = [JKAccountModel sharedManager];
    [accountModel modify:model];
    
    return [accountModel findAll];
}

- (NSMutableArray*)findAll {
    JKAccountModel *accountModel = [JKAccountModel sharedManager];
    return [accountModel findAll];
}

@end
