//
//  JKTimeLineView.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/10.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKTimeLineView.h"

@interface JKTimeLineView()

/**
 *  检测按钮是否被点击过
 */
@property (nonatomic, assign) BOOL accountButtonHasBeenClicked;

/**
 *  已展开按钮的序号 (PS:同一时刻只能展开一个按钮)
 */
@property (nonatomic, assign) NSInteger indexPathOfExpandedButton;

/**
 *  编辑
 */
@property (nonatomic, strong) UIButton *editButton;

/**
 *  删除
 */
@property (nonatomic, strong) UIButton *deleteButton;

/**
 *  全部账目按钮
 */
@property (nonatomic, strong) NSMutableArray *accountButtonsArray;

/**
 *  全部账目标签
 */
@property (nonatomic, strong) NSMutableArray *accountLabelsArray;

@end

@implementation JKTimeLineView

#pragma mark - Getters
- (BOOL)detailButtonHasBeenClicked {
    if (!_accountButtonHasBeenClicked) {
        _accountButtonHasBeenClicked = NO;
    }
    return _accountButtonHasBeenClicked;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [self detailButtonCommonInitWithImage:@"编辑"];
        _editButton.tag = 234;
    }
    return _editButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [self detailButtonCommonInitWithImage:@"删除"];
        _deleteButton.tag = 456;
    }
    return _deleteButton;
}

- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}

- (NSMutableArray *)accountButtonsArray {
    if (!_accountButtonsArray) {
        _accountButtonsArray = [[NSMutableArray alloc] init];
        
    }
    return _accountButtonsArray;
}

- (NSMutableArray *)accountLabelsArray {
    if (!_accountLabelsArray) {
        _accountLabelsArray = [[NSMutableArray alloc] init];
    }
    return _accountLabelsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 添加背景单击手势收回详情子按钮
        UITapGestureRecognizer *tapBackGroundView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(backGroundViewTapped:)];
        
        [self addGestureRecognizer:tapBackGroundView];
        
        [self addObserver:self forKeyPath:@"listData" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

+ (JKTimeLineView *)createTimeLineViewWithFrame:(CGRect)frame withData:(NSMutableArray *)dataSource {
    JKTimeLineView *myView = [[JKTimeLineView alloc] initWithFrame:frame];
    myView.listData = dataSource;
    
    return myView;
}

#pragma  mark - drawRect
- (void)drawRect:(CGRect)rect {
    //绘制时间点
    if (_listData.count != 0) {
        // 绘制时间线
        CGContextRef ctf = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctf, 2);
        CGContextSetRGBStrokeColor(ctf, 0.5, 0.5, 0.5, 0.5);
        
        CGPoint aPoints[2];
        aPoints[0] = CGPointMake(WIDTH / 2, SP_W(18));
        aPoints[1] = CGPointMake(WIDTH / 2, _listData.count * SP_W(60));
        CGContextAddLines(ctf, aPoints, 2);
        CGContextDrawPath(ctf, kCGPathStroke);
        
        
        CGContextSetRGBFillColor(ctf, 0.5, 0.5, 0.5, 0.5);
        CGContextFillEllipseInRect(ctf, CGRectMake(WIDTH / 2 - SP_W(4), SP_H(10), SP_W(8), SP_W(8)));
        
        //显示当前日期的标签
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4 - SP_W(8),
                                                                       SP_H(8),
                                                                       WIDTH / 4,
                                                                       SP_W(15))];
        dateLabel.textColor = [UIColor blueColor];
        dateLabel.font = [UIFont systemFontOfSize:14];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        [self addSubview:dateLabel];
    }
    //添加账目
    [self.listData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.accountButtonsArray addObject:[self accountButtonCommonInitWithItem:(JKAccount *)obj atIndexPath:idx]];
        [self.accountLabelsArray addObject:[self accountLabelCommonInitWithItem:(JKAccount *)obj atIndexPath:idx]];
    }];
}

#pragma mark - CommonInit

/**
 *  tag的增量 - 用于锁定本系列Button的tag不会轻易被占用
 */
static NSInteger const kTagIncrementation = 911;

/** 生成账目条目 */
- (UIButton *)accountButtonCommonInitWithItem:(JKAccount *)item atIndexPath:(NSInteger)indexPath {
    
    CGRect buttonRect = CGRectMake(WIDTH / 2 - SP_W(10),
                                   SP_W(60) + SP_W(60) * (_listData.count - 1 - indexPath) - SP_W(10),
                                   SP_W(20),
                                   SP_W(20));
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
    button.tag = indexPath + kTagIncrementation;
    [button setImage:[UIImage imageNamed:item.category] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accountCircleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    return button;
    
}

/** 生成账目条目详细信息 */
- (UILabel *)accountLabelCommonInitWithItem:(JKAccount *)item atIndexPath:(NSInteger)indexPath {
    
    CGRect incomeLabelRect = CGRectMake(20,
                                        SP_W(60) + SP_W(60) * (_listData.count - 1 - indexPath) - SP_W(30) / 2,
                                        WIDTH / 2 - 40,
                                        SP_W(30));
    
    CGRect outgoingsLabelRect = CGRectMake(WIDTH / 2 + 20,
                                           SP_W(60) + SP_W(60) * (_listData.count - 1 - indexPath) - SP_W(30) / 2,
                                           WIDTH / 2 - 20,
                                           SP_W(30));
    //收入
    UILabel *label = [[UILabel alloc] initWithFrame:outgoingsLabelRect];
    NSString *money = [NSString stringWithFormat:@"%.2f",[item.money doubleValue]];
    label.text = [item.category stringByAppendingString:money];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    
    if ([item.category isEqual:@"工资"]) {
        //支出
        [label setFrame:incomeLabelRect];
        label.textAlignment = NSTextAlignmentRight;
    }
    [self addSubview:label];
    
    return label;
}

/**
 *  生成详情按钮 - edit 、 delete
 *
 *  @param imageName
 *
 *  @return
 */
- (UIButton *)detailButtonCommonInitWithImage:(NSString *)imageName
{
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectZero];
    detailButton.alpha = 0;
    [detailButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [detailButton addTarget:self
                     action:@selector(detialButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:detailButton];
    return detailButton;
}

#pragma mark - ButtonClicked
- (void)accountCircleButtonClicked:(id)sender {
    if (!_accountButtonHasBeenClicked) {
        [self expandDetailButton:sender];
    } else {
        [self recycleDetailButtonByAnimation];
    }
}

/**
 *  详情按钮点击事件
 *
 *  @param sender tag == 234 编辑  tag == 456 删除
 */
- (void)detialButtonClicked:(id)sender {
    
    if ([sender tag] == 234) {
        //传递将要被编辑的账目
        if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonClickedToPerformSegueAtIndexPath:sender:)])
        {
            [self recycleDetailButtonByAnimation];
            [self.delegate editButtonClickedToPerformSegueAtIndexPath:_indexPathOfExpandedButton sender:sender];
        }
        
    } else if ([sender tag] == 456) {
        //弹窗警告
        if (self.delegate && [self.delegate respondsToSelector:@selector(showAlertViewWithListData:atIndexPath:)])
        {
            [self.delegate showAlertViewWithListData:self.listData
                                         atIndexPath:_indexPathOfExpandedButton];
        }
    }
}

/**
 *  单击背景回收详情按钮
 *
 *  @param recognizer TapGesture
 */
- (void)backGroundViewTapped:(UIGestureRecognizer *)recognizer {
    [self recycleDetailButtonByAnimation];
}

/**
 *  展开子按钮动画
 *
 *  @param currentCenterButtonFrame 当前被点击的上级按钮
 */
- (void)expandDetailButton:(id)sender {
    
    self.indexPathOfExpandedButton = [sender tag] - kTagIncrementation;
    
    //给出详情按钮展开动画起始位置
    [self.editButton setFrame:[sender frame]];
    [self.deleteButton setFrame:[sender frame]];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //edit、delete的平移
        CGRect rect = [sender frame];
        rect.origin.x -= WIDTH * 0.25;
        
        self.editButton.frame = rect;
        self.editButton.alpha = 1;
        
        rect.origin.x += WIDTH * 0.5;
        self.deleteButton.frame = rect;
        self.deleteButton.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.accountButtonHasBeenClicked = YES;
        if (_indexPathOfExpandedButton > self.accountLabelsArray.count - 1) return;
        //accountLabel的消失
        [(UILabel *)self.accountLabelsArray[self.accountLabelsArray.count - 1 - _indexPathOfExpandedButton] setAlpha:0];
    }];
}

/** 回收子按钮动画 */
- (void)recycleDetailButtonByAnimation {
    if (_editButton.alpha == 0 || _deleteButton.alpha == 0) return;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect editRect = self.editButton.frame;
        editRect.origin.x += WIDTH * 0.25;
        [self.editButton setFrame:editRect];
        
        CGRect deleteRect = self.deleteButton.frame;
        deleteRect.origin.x -= WIDTH * 0.25;
        [self.deleteButton setFrame:deleteRect];
        
        self.editButton.alpha = 0;
        self.deleteButton.alpha = 0;
        
        self.editButton = nil;
        self.deleteButton = nil;
        
    } completion:^(BOOL finished) {
        self.accountButtonHasBeenClicked = NO;
        if (self.indexPathOfExpandedButton > self.accountLabelsArray.count - 1) return;
        if (0 < self.accountLabelsArray.count) {
            [(UILabel *)self.accountLabelsArray[self.accountLabelsArray.count - 1 - _indexPathOfExpandedButton] setAlpha:1];
        }
    }];
}

/** 重载界面 */
- (void)reloadTimeLineView {
    //移除全部旧有控件,准备重新加载控件
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.accountButtonsArray removeAllObjects];
    [self.accountLabelsArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - KVO Delegate Method
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqualToString:@"listData"]) {
        [self reloadTimeLineView];
    }
}

@end
