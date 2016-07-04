//
//  JKInteractiveTransition.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/26.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKInteractiveTransition.h"

@interface JKInteractiveTransition()
/**手势方向*/
@property (nonatomic, assign) JKInteractiveTransitionGestureDirection direction;

@property (nonatomic, assign) CGFloat scrollPercentage;

@end

@implementation JKInteractiveTransition

+ (instancetype)interactiveTransitionWithGestureDirection:(JKInteractiveTransitionGestureDirection)direction {
    return [[self alloc] initWithGestureDirection:direction];
}

- (instancetype)initWithGestureDirection:(JKInteractiveTransitionGestureDirection)direction {
    self = [super init];
    if (self) {
        _direction = direction;
    }
    return self;
}

- (void)addPanGestureForView:(UIView *)theView {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleGesture:)];
    [theView addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
    //手势百分比
    CGFloat percent = 0;
    switch (_direction) {
        case JKInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case JKInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case JKInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = - [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.height;
        }
            break;
        case JKInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.height;
        }
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            break;
        case UIGestureRecognizerStateChanged:{
            [self didUpdatePercentage:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            if (percent > 0.4) {
                [self didUpdatePercentage:1.0];
            } else {
                [self didUpdatePercentage:0];
            }
            break;
        }
        default:
            break;
    }
}

- (void)didUpdatePercentage:(CGFloat)percentage {
    if (_panGesture && percentage >= 0) _panGesture(percentage);
}

@end
