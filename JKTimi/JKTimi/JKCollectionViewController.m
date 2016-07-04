//
//  JKCollectionViewController.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/16.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKCollectionViewController.h"
#import "JKCollectionViewCell.h"
#import "JKNumberKeyboardViewController.h"
#import "JKParabolaAnimation.h"

@interface JKCollectionViewController () <JKParabolaAnimationDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>

/** 图片数据源 */
@property (strong, nonatomic) NSMutableArray *imageArray;

/** 自定义键盘 */
@property (strong, nonatomic) JKNumberKeyboardViewController *numberKeyboardViewController;

/** 自定义抛物线动画 */
@property (strong, nonatomic) JKParabolaAnimation *parabolaSharedInstance;

/** 选中的类目 */
@property (strong, nonatomic) NSString *categoryName;

/** 设置tid */
@property (assign, nonatomic) NSInteger tid;

@end

@implementation JKCollectionViewController

@synthesize tid = _tid;

#pragma mark - Getters
- (NSInteger)tid {
    //value == 0 即 还没有设置该key
    NSInteger value = [[NSUserDefaults standardUserDefaults] integerForKey:@"tid"];
    return (0 == value) ? 1 : value;
}

- (void)setTid:(NSInteger)newTid {
    [[NSUserDefaults standardUserDefaults] setInteger:newTid forKey:@"tid"];
    /** 同步到磁盘 
     *  系统过一定时间会执行此方法,若在执行前退出了应用,可能导致保存失效！
     *  手动实现保证NSUserDefaults一直有效 */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self loadNumberKeyboardViewFromXIB];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageArray = [[NSMutableArray alloc] initWithObjects:@"宝贝", @"充值", @"宠物", @"服装", @"腐败", @"工资", @"工作", @"购物", @"护肤", @"家庭", @"酒水", @"就餐", @"丽人", @"零食", @"日用品", @"日杂", @"数码", @"投资", @"香烟", @"鞋帽", @"信用卡", @"学习", @"一般", @"医疗", @"娱乐", @"运动", @"住房", @"转账", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self
                                                                                action:@selector(didSegueToMainViewController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    [self setupCollectionView];
    [self loadNumberKeyboardViewFromXIB];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performSegueWithDataStorage:)
                                                 name:@"SegueToTimeLineViewController"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SegueToTimeLineViewController"
                                                  object:nil];
}

#pragma mark - >>>>>>>>Custom NumberKeyboard About<<<<<<<<
- (void)loadNumberKeyboardViewFromXIB {
    if (!_numberKeyboardViewController) {
        _numberKeyboardViewController = [JKNumberKeyboardViewController viewControllerFromXIB];
    }
    
    if (self.detailItem) {
        JKAccount *accountModel = self.detailItem;
        NSString *price = [NSString stringWithFormat:@"%@",accountModel.money];
        
        [self.numberKeyboardViewController showNumKeyboardViewAnimateWithPrice:price
                                                               withAccountType:accountModel.category];
    } else {
        
        [self.numberKeyboardViewController showNumKeyboardViewAnimateWithPrice:@""
                                                               withAccountType:@"一般"];
    }
    
    [self.view addSubview:_numberKeyboardViewController.view];
}

#pragma mark - >>>>>>>>Custom CollectionView Methods<<<<<<<<

/** 初始化CollectionView */
- (void)setupCollectionView {
    [self.collectionView registerClass:[JKCollectionViewCell class] forCellWithReuseIdentifier:JKDraggableCollectionViewCellIdentifier];
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    self.collectionView.decelerationRate = 0.2;
    
    CGFloat itemWidth = CGRectGetWidth(self.collectionView.bounds) / 2 - 40;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.lineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JKDraggableCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    cell.descLabel.text = [self.imageArray objectAtIndex:indexPath.row];
    cell.draggingDelegate = self;
    return cell;
}

#pragma mark - JKDraggableCollectionViewCellDelegate

/**
 *  授权拖动Cell
 *
 *  @param cell 当前选中的Cell
 *
 *  @return     返回YES,可拖动
 */
- (BOOL)userCanDragCell:(UICollectionViewCell *)cell {
    return YES;
}

/**
 *  结束拖动时调用
 *
 *  @param cell 当前选中的Cell
 */
- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell {
    [super userDidEndDraggingCell:cell];
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    // 更新数据源
    if (flowLayout.finalIndexPath != nil) {
        NSObject *objectToMove = [self.imageArray objectAtIndex:flowLayout.draggedIndexPath.row];
        [self.imageArray removeObjectAtIndex:flowLayout.draggedIndexPath.row];
        [self.imageArray insertObject:objectToMove atIndex:flowLayout.finalIndexPath.row];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKCollectionViewCell *selectedCell = (JKCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self parabolaAnimationShouldStartByCell:selectedCell];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取到collectionView滚动的纵向距离
    CGFloat contentScrolledY = [scrollView.panGestureRecognizer translationInView:self.collectionView].y;
    //同步滚动键盘
    CGFloat distance = 0;
    
    if (fabs(contentScrolledY) < (kCUSTOM_KEYBOARD_HEIGHT - 44) && contentScrolledY <= 0) {
        distance = fabs(contentScrolledY);
    } else {
        distance = (kCUSTOM_KEYBOARD_HEIGHT - 44);
    }
    
    [self.numberKeyboardViewController hideNumKeyboardViewWithAnimationByDistance:distance];
}

/** 当调用此方法时,滚动才是真的停止了 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat distance = HEIGHT - self.numberKeyboardViewController.view.frame.origin.y < 0.5 * (kCUSTOM_KEYBOARD_HEIGHT - 44) ? (kCUSTOM_KEYBOARD_HEIGHT - 44) : 0;
    [self.numberKeyboardViewController displayNumKeyboardViewAnimateByDistance:distance];
}

/** 当手离开屏幕后,仍会保持惯性运动一段时间 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat distance = HEIGHT - self.numberKeyboardViewController.view.frame.origin.y < 0.5 * (kCUSTOM_KEYBOARD_HEIGHT - 44) ? (kCUSTOM_KEYBOARD_HEIGHT - 44) : 0;
    [self.numberKeyboardViewController displayNumKeyboardViewAnimateByDistance:distance];
}

#pragma mark -  >>>>>>Custom ParabolaAnimation Methods <<<<<<
- (void)parabolaAnimationShouldStartByCell:(JKCollectionViewCell *)selectedCell {
    if (!_categoryName) {
        self.categoryName = selectedCell.descLabel.text;
    }
    //抛物线起点坐标
    CGRect originalRect = [selectedCell.superview convertRect:selectedCell.frame toView:self.view];
    CGFloat originalCenterX = originalRect.origin.x + originalRect.size.width / 2;
    CGFloat originalCenterY = originalRect.origin.y + originalRect.size.height / 2;
    
    //抛物线终点坐标
    CGRect destinationRect = [_numberKeyboardViewController.view convertRect:_numberKeyboardViewController.placeholderView.frame toView:self.view];
    CGFloat destinationCenterX = destinationRect.origin.x + destinationRect.size.width / 2;
    CGFloat destinationCenterY = destinationRect.origin.y + destinationRect.size.height / 2;
    
    //指定动画执行对象
    UIImageView *parabolaView = [[UIImageView alloc] initWithFrame:selectedCell.imageView.frame];
    [parabolaView setImage:selectedCell.imageView.image];
    parabolaView.contentMode = UIViewContentModeCenter;
    parabolaView.layer.cornerRadius = kImageDiameter * 0.5;
    [self.view addSubview:parabolaView];
    
    //执行动画
    [self.parabolaSharedInstance pathAnimationQuadCurveForView:parabolaView
                                                     fromPoint:CGPointMake(originalCenterX, originalCenterY)
                                                       toPoint:CGPointMake(destinationCenterX, destinationCenterY)
                                                  withDuration:0.6
                                                       scaleTo:1];
}

/** 抛物线动画结束回调 */
- (void)parabolaAnimationDidFinished {
    [_numberKeyboardViewController.placeholderView setImage:[UIImage imageNamed:self.categoryName]];
    _numberKeyboardViewController.placeholderLabel.text = self.categoryName;
    
    //TODO:这里有个BUG 多次快速点击同一个Cell，会让键盘上标签和图片的显示内容变为空白
    self.categoryName = nil;
}

#pragma mark - >>>>>>>>>>>PerformSegue Methods<<<<<<<<<<<

- (void)performSegueWithDataStorage:(NSNotification *)notification {
    //获取用户输入的数据
    NSDictionary *dict = [notification userInfo];
    NSString *accountName = [dict objectForKey:@"AccountName"];
    NSString *accountMoney = [dict objectForKey:@"AccountMoney"];
    
    //MARK:当用户输入金额为零时,该条账目视为无效数据,不进行保存,并仍然停留在原界面等待下一步操作
    if (accountMoney.floatValue == 0) return;
    
    //将数据存入CoreData
    JKModelManager *manager = [[JKModelManager alloc] init];
    if (self.isNewAccount) {
        JKAccount *accountModel = [[JKAccount alloc] init];
        accountModel.category = accountName;
        accountModel.money = [NSNumber numberWithFloat:accountMoney.floatValue];
        accountModel.timeStamp = [self fetchLocaleTimeZoneCurrentTime];
        accountModel.tid = [NSNumber numberWithInteger:[self tid]];
        [self setTid:[self tid] + 1];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:accountModel forKey:@"AccountNeedServerToAdd"];
        //新增账目
        _updateListDataHandler([manager create:accountModel], dict);
                
    } else {
        JKAccount *accountModel = self.detailItem;
        accountModel.category = accountName;
        accountModel.money = [NSNumber numberWithFloat:accountMoney.floatValue];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:accountModel forKey:@"AccountNeedServerToModify"];
        //编辑账目
        _updateListDataHandler([manager modify:accountModel], dict);
    }
    [self didSegueToMainViewController];
}

/**
 *  转场动画
 */
- (void)didSegueToMainViewController {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
}

#pragma mark - Tool Methods
/**
 *   获取当前时区的时间
 *
 *  @return 当前时区的时间
 */
- (NSDate *)fetchLocaleTimeZoneCurrentTime {
    NSDate *date = [NSDate date];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

#pragma mark - >>>>>>>>>>>>>>Getter Methods<<<<<<<<<<<<<<
- (JKParabolaAnimation *)parabolaSharedInstance {
    if (!_parabolaSharedInstance) {
        _parabolaSharedInstance = [JKParabolaAnimation parabolaAnimationSharedInstance];
        _parabolaSharedInstance.delegate = self;
    }
    return _parabolaSharedInstance;
}

@end
