//
//  JKInteractiveTransition.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/26.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JKInteractiveTransitionGestureDirection) {//手势的方向
    JKInteractiveTransitionGestureDirectionLeft = 0 << 16,
    JKInteractiveTransitionGestureDirectionRight = 1 << 16,
    JKInteractiveTransitionGestureDirectionUp = 2 << 16,
    JKInteractiveTransitionGestureDirectionDown = 3 << 16,
};

typedef void (^GestureHandler)(CGFloat rate);

@interface JKInteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;

//初始化方法

+ (instancetype)interactiveTransitionWithGestureDirection:(JKInteractiveTransitionGestureDirection)direction;

- (instancetype)initWithGestureDirection:(JKInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForView:(UIView *)theView;

@property (nonatomic, copy) GestureHandler panGesture;

@end
