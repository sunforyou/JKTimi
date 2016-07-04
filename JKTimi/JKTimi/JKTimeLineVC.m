//
//  JKTimeLineVC.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKTimeLineVC.h"
#import "JKCollectionViewController.h"
#import "JKLoginViewController.h"

/** 添加账目按钮tag */
static NSInteger const kAddNewAccountButtonTag = 501;
/** 编辑账目按钮tag */
static NSInteger const kEditDetailButtonTag = 234;

@interface JKTimeLineVC () <JKTimeLineViewDelegate>

/**
 *  CoreData管家
 */
@property (nonatomic, strong) JKModelManager *singleManager;

/**
 *  数据缓存
 */
@property (nonatomic, strong) NSMutableArray *dataCache;

/**
 *  将被重新编辑的账目的序号
 */
@property (nonatomic, assign) NSInteger indexPathOfSelectedAccount;

/**
 *  时间轴
 */
@property (nonatomic, strong) JKTimeLineView *timeLineView;

/**
 *  滚动背景
 */
@property (nonatomic, strong) UIScrollView *myScrollView;

/**
 *  蒙板-放置按钮和标签
 */
@property (nonatomic, strong) UIView *drawBoard;

/**
 *  新增账目
 */
@property (nonatomic, strong) UIButton *addAccountButton;

/**
 *  收入
 */
@property (nonatomic, strong) UILabel *incomeLabel;

/**
 *  支出
 */
@property (nonatomic, strong) UILabel *outgoingLabel;

/**
 *  因断网或何种原因未能成功上传服务器的账目将在这里缓存，并最终存到Userdefault中
 */
@property (nonatomic, strong) NSMutableArray *accountCacheThatNeedsToHandle;

@end

@implementation JKTimeLineVC

#pragma mark - Getter Methods

- (JKModelManager *)singleManager {
    if (!_singleManager) {
        _singleManager = [[JKModelManager alloc] init];
    }
    return _singleManager;
}

- (NSMutableArray *)dataCache {
    if (!_dataCache) {
        _dataCache = [self.singleManager findAll];
    }
    return _dataCache;
}

- (UIScrollView *)myScrollView {
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _myScrollView.backgroundColor = [UIColor clearColor];
    }
    return _myScrollView;
}

- (JKTimeLineView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [JKTimeLineView createTimeLineViewWithFrame:CGRectZero withData:_dataCache];
        _timeLineView.delegate = self;
        _timeLineView.backgroundColor = [UIColor clearColor];
    }
    return _timeLineView;
}

- (UIView *)drawBoard {
    if (!_drawBoard) {
        _drawBoard = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, WIDTH, 60)];
        [_drawBoard setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0f]];
        
    }
    return _drawBoard;
}

- (UIButton *)addAccountButton {
    if (!_addAccountButton) {
        _addAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 25, 5, 50, 50)];
        [_addAccountButton setImage:[UIImage imageNamed:@"addAmountButton.png"] forState:UIControlStateNormal];
        [_addAccountButton setTag:kAddNewAccountButtonTag];
        
        [_addAccountButton addTarget:self
                              action:@selector(perfomSegueToDetailViewController:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAccountButton;
}

- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 0.25 - 50, 5, 100, 50)];
        _incomeLabel.numberOfLines = 0;
        _incomeLabel.text = @"收入\n";
        _incomeLabel.tintColor = [UIColor lightGrayColor];
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _incomeLabel;
}

- (UILabel *)outgoingLabel {
    if (!_outgoingLabel) {
        _outgoingLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 0.75 - 50, 5, 100, 50)];
        _outgoingLabel.numberOfLines = 0;
        _outgoingLabel.text = @"支出\n";
        _outgoingLabel.tintColor = [UIColor lightGrayColor];
        _outgoingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _outgoingLabel;
}

- (NSMutableArray *)accountCacheThatNeedsToHandle {
    if(!_accountCacheThatNeedsToHandle) {
        _accountCacheThatNeedsToHandle = [NSMutableArray array];
    }
    return _accountCacheThatNeedsToHandle;
}

#pragma mark - reloadTimeLineView
/** 刷新总收入与总支出数据 */
- (void)calculateTotalPayments {
    
    //每次计算之前，先行清空旧数据
    self.incomeLabel.text = @"收入\n";
    self.outgoingLabel.text = @"支出\n";
    
    __block double totalIncome = 0;
    __block double totalOutgoing = 0;
    
    [self.dataCache enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKAccount *sampleMdoel = (JKAccount *)obj;
        if ([sampleMdoel.category isEqualToString:@"工资"]) {
            totalIncome += [sampleMdoel.money doubleValue];
        } else {
            totalOutgoing += [sampleMdoel.money doubleValue];
        }
    }];
    self.incomeLabel.text = [self.incomeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%.2f",totalIncome]];
    self.outgoingLabel.text = [self.outgoingLabel.text stringByAppendingString:[NSString stringWithFormat:@"%.2f",totalOutgoing]];
}

/** 刷新页面 */
- (void)reloadTimeLineView {
    [self.myScrollView addSubview:self.timeLineView];
    [self.view addSubview:self.myScrollView];
    [self.view addSubview:self.drawBoard];
    [self.drawBoard addSubview:self.addAccountButton];
    [self.drawBoard addSubview:self.incomeLabel];
    [self.drawBoard addSubview:self.outgoingLabel];
    
    //刷新数据源
    self.timeLineView.listData = self.dataCache;
    //刷新总收支标签
    [self calculateTotalPayments];
    //刷新myScrollView的contentSize
    self.myScrollView.contentSize = CGSizeMake(0, SP_H(50) * (self.dataCache.count + 2) + SP_H(50));
    //刷新timeLineView
    CGFloat height = HEIGHT - NAVIGATIONBAR_HEIGHT > (SP_H(50) * self.dataCache.count + SP_H(50)) ?
    HEIGHT - NAVIGATIONBAR_HEIGHT : (SP_H(50) * self.dataCache.count + SP_H(50));
    [self.timeLineView setFrame:CGRectMake(0, 50, WIDTH, height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"登陆"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(goBackToLoginController)];
    
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    [self.navigationItem setTitle:@"我的账本"];
    [self reloadTimeLineView];
    
    /** 监控缓存变化 */
    [self addObserver:self forKeyPath:@"dataCache" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - JKTimeLineViewDelegate Methods
- (void)editButtonClickedToPerformSegueAtIndexPath:(NSInteger)indexPath sender:(id)sender {
    self.indexPathOfSelectedAccount = indexPath;
    [self perfomSegueToDetailViewController:sender];
}

- (void)showAlertViewWithListData:(NSMutableArray *)dataSource atIndexPath:(NSInteger)indexPath {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"您是否确定要删除所选账目"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //向服务器发送删除请求，从缓存中删掉该项并更新视图
        [self startDeleteAccountRequestWithDataSource:dataSource atIndexPath:indexPath];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - PerformSegue
/** 跳转到账目详情页面 */
- (void)perfomSegueToDetailViewController:(id)sender {
    
    JKCollectionViewController *collectionVC = [[JKCollectionViewController alloc] init];
    
    [self.navigationController pushViewController:collectionVC animated:NO];
    [[self.navigationController.view layer] addAnimation:[self callSystemSegueAnimations]
                                                  forKey:@"animation"];
    
    collectionVC.updateListDataHandler = ^(NSMutableArray *newDataSource, NSDictionary *dict) {
        self.dataCache = newDataSource;
        
        if ([[dict allKeys] containsObject:@"AccountNeedServerToAdd"]) {
            JKAccount *account = [dict objectForKey:@"AccountNeedServerToAdd"];
            [self postRequestWithAccount:account toURL:JKDATABASEURL_ADDACCOUNT];
        }
        if ([[dict allKeys] containsObject:@"AccountNeedServerToModify"]) {
            JKAccount *account = [dict objectForKey:@"AccountNeedServerToModify"];
            [self postRequestWithAccount:account toURL:JKDATABASEURL_MODIFYACCOUNT];
        }
    };
    
    if ([sender tag] == kEditDetailButtonTag) {
        [collectionVC setDetailItem:self.dataCache[_indexPathOfSelectedAccount]];
        [collectionVC setIsNewAccount:NO];
    } else if ([sender tag] == kAddNewAccountButtonTag) {
        [collectionVC setIsNewAccount:YES];
    }
}

/** 呼出系统自带的转场动画 */
- (CATransition *)callSystemSegueAnimations {
    //core animation
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    switch (arc4random() % 2) {
        case 0:
            animation.type = @"cube";
            break;
        case 1:
            animation.type = @"rippleEffect";
            break;
        default:
            break;
    }
    animation.subtype = kCATransitionFromLeft;
    
    return animation;
}

/** 回到登录界面 */
- (void)goBackToLoginController {
    JKLoginViewController *loginVC = [JKLoginViewController generateLoginVC];
    [self.navigationController pushViewController:loginVC animated:NO];
    [[self.navigationController.view layer] addAnimation:[self callSystemSegueAnimations]
                                                  forKey:@"animation"];
}

#pragma mark - KVO Delegate Method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dataCache"]) {
        [self reloadTimeLineView];
    }
}

#pragma mark - Tool Methods

/**
 *  删除服务器、CoreData及本地缓存中的项目
 */
- (void)startDeleteAccountRequestWithDataSource:(NSMutableArray *)dataSource atIndexPath:(NSInteger)indexPath {
    //发送删除请求
    [self postRequestWithAccount:(JKAccount *)dataSource[indexPath] toURL:JKDATABASEURL_DELETEACCOUNT];
    
    //从本地缓存中删除该项
    [dataSource removeObjectAtIndex:indexPath];
    //更新缓存
    [self setDataCache:dataSource];
}

/**
 *  向服务器发送POST请求
 *
 *  @param param 请求所带参数
 *  @param url   请求的目标URL
 */
- (void)postRequestWithAccount:(JKAccount *)account toURL:(NSURL *)URL {
    //设置请求参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    /** 这里做一个区分，因为我写的服务器端的delete和add、modify的传入参数略有差异，删除操作只需要一个id */
    NSString *params = [NSString stringWithFormat:@"id=%@&category=%@&money=%@&modifiedtime=%@",account.tid,account.category,account.money,account.timeStamp];
    if ([URL isEqual:JKDATABASEURL_DELETEACCOUNT]) {
        params = [NSString stringWithFormat:@"id=%@",account.tid];
    }
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    
    //发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            JKLog(@"请求失败:%@",error);
            //将发送失败的账目存入userdefault，等下次登录时再次尝试上传
            NSDictionary *dict = [NSDictionary dictionary];
            [dict setValue:params forKey:@"Params"];
            [dict setValue:URL forKey:@"URL"];
            [self.accountCacheThatNeedsToHandle addObject:dict];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccountNeedsToHandle"];
            [[NSUserDefaults standardUserDefaults] setObject:[_accountCacheThatNeedsToHandle copy]
                                                      forKey:@"AccountNeedsToHandle"];
        } else {
            //解析服务器返回数据
            NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            JKLog(@"%@---%@",res,[NSThread currentThread]);
            
            //弹窗提示操作结果
            dispatch_async(dispatch_get_main_queue(), ^{
                //返回字段包含success即为请求成功
                if ([res containsString:@"Success"]) {
                    [SVProgressHUD showSuccessWithStatus:res];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    if ([URL isEqual:JKDATABASEURL_DELETEACCOUNT]) {
                        [self.singleManager remove:account];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:res];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                }
            });
        }
    }];
    [task resume];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"dataCache"];
}

@end
