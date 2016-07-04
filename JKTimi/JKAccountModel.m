//
//  JKAccountModel.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKAccountModel.h"

@implementation JKAccountModel

static JKAccountModel *sharedManager = nil;

- (NSManagedObjectContext *)myManagedObjectContext {
    if (!_myManagedObjectContext) {
        _myManagedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _myManagedObjectContext;
}

+ (JKAccountModel *)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager myManagedObjectContext];
    });
    return sharedManager;
}

#pragma mark Core Data Operation Methods

- (void)create:(JKAccount *)model {
    
    NSManagedObjectContext *cxt = [self myManagedObjectContext];
    
    Account *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                     inManagedObjectContext:cxt];
    
    [account setValue:model.category forKey:@"category"];
    [account setValue:model.money forKey:@"money"];
    [account setValue:model.timeStamp forKey:@"timeStamp"];
    [account setValue:model.tid forKey:@"tid"];
    [account setValue:model.statusCode forKey:@"statusCode"];
    
    account.tid = model.tid;
    account.statusCode = model.statusCode;
    account.category = model.category;
    account.money = model.money;
    account.timeStamp = model.timeStamp;
    
    NSError *savingError = nil;
    if ([cxt save:&savingError]){
        NSLog(@"CoreData添加数据成功");
    } else {
        NSLog(@"CoreData添加数据失败");
    }
}

- (void)remove:(JKAccount *)model {
    
    NSManagedObjectContext *cxt = [self myManagedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Account"
                                                         inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //通过Account的属性--category从CoreDate中抓取对应类目
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp = %@", model.timeStamp];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        Account *account = [listData lastObject];
        [cxt deleteObject:account];
        
        NSError *savingError = nil;
        if ([cxt save:&savingError]){
            NSLog(@"CoreData删除数据成功");
        } else {
            NSLog(@"CoreData删除数据失败");
        }
    }
}

- (void)modify:(JKAccount *)model {
    NSManagedObjectContext *cxt = [self myManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Account"
                                                         inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp = %@", model.timeStamp];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        Account *account = [listData lastObject];
        account.category = model.category;
        account.money = model.money;
        account.statusCode = model.statusCode;
        
        NSError *savingError = nil;
        if ([cxt save:&savingError]){
            NSLog(@"CoreData修改数据成功");
        } else {
            NSLog(@"CoreData修改数据失败");
        }
    }
}

- (NSMutableArray*)findAll {
    NSManagedObjectContext *cxt = [self myManagedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Account"
                                                         inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (Account *model in listData) {
        JKAccount *account = [[JKAccount alloc] init];
        account.statusCode = model.statusCode;
        account.timeStamp = model.timeStamp;
        account.category = model.category;
        account.money = model.money;
        account.tid = model.tid;
        [resListData addObject:account];
    }
    return resListData;
}

@end
