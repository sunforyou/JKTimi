//
//  JKPushAndPopAnimationTransition.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/24.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKPushAndPopAnimationTransition.h"
#import <QuartzCore/QuartzCore.h>

@interface JKPushAndPopAnimationTransition ()

@property (nonatomic, assign, getter = isPopInitialized) BOOL popInitialized;

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

@end

@implementation JKPushAndPopAnimationTransition

+ (instancetype)transitionWithType:(JKPushAndPopAnimationTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(JKPushAndPopAnimationTransitionType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_animationType) {
        case JKAnimationTransitionTypeSlide:
            [self doSliderAnimateTransition:transitionContext];
            
            break;
            
        case JKAnimationTransitionTypeShuffle:
            [self doShuffleAnimateTransition:transitionContext];
            break;
    }
}

#pragma mark - Animated Transitioning

- (void)doSliderAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Insert 'to' view into the hierarchy
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    //90 degree transform away from the user
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, M_PI / 2.0, 0.0, 1.0, 0.0);
    t.m34 = 1.0 / -2000;
    
    //Set anchor points for the views
    if (self.type == JKPushAndPopAnimationTransitionTypePush) {
        [self setAnchorPoint:CGPointMake(1.0, 0.5) forView:toViewController.view];
        [self setAnchorPoint:CGPointMake(0.0, 0.5) forView:fromViewController.view];
    } else if (self.type == JKPushAndPopAnimationTransitionTypePop) {
        [self setAnchorPoint:CGPointMake(0.0, 0.5) forView:toViewController.view];
        [self setAnchorPoint:CGPointMake(1.0, 0.5) forView:fromViewController.view];
    }
    
    //Set appropriate z indexes
    fromViewController.view.layer.zPosition = 2.0;
    toViewController.view.layer.zPosition = 1.0;
    
    //Apply full transform to the 'to' view to start out with
    toViewController.view.layer.transform = t;
    
    //Animate the transition, applying transform to 'from' view and removing it from 'to' view
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.layer.transform = t;
        toViewController.view.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        //Reset z indexes (otherwise this will affect other transitions)
        fromViewController.view.layer.zPosition = 0.0;
        toViewController.view.layer.zPosition = 0.0;
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)doShuffleAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Take a snapshot of the 'from' view
    UIView *fromSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    fromSnapshot.frame = fromViewController.view.frame;
    [containerView insertSubview:fromSnapshot aboveSubview:fromViewController.view];
    [fromViewController.view removeFromSuperview];
    
    //Add the 'to' view to the hierarchy
    toViewController.view.frame = fromSnapshot.frame;
    [containerView insertSubview:toViewController.view belowSubview:fromSnapshot];
    
    //The amount of horizontal movement need to fit the views side by side in the middle of the animation
    CGFloat width = floorf(fromSnapshot.frame.size.width/2.0)+5.0;
    
    //Animate using keyframe animations
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:0 animations:^{
        
        //Apply z-index translations to make the views move away from the user
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.20 animations:^{
            CATransform3D fromT = CATransform3DIdentity;
            fromT.m34 = 1.0 / -2000;
            fromT = CATransform3DTranslate(fromT, 0.0, 0.0, -590.0);
            fromSnapshot.layer.transform = fromT;
            
            CATransform3D toT = CATransform3DIdentity;
            toT.m34 = 1.0 / -2000;
            toT = CATransform3DTranslate(fromT, 0.0, 0.0, -600.0);
            toViewController.view.layer.transform = toT;
        }];
        
        //Adjust the views horizontally to clear eachother
        [UIView addKeyframeWithRelativeStartTime:0.20 relativeDuration:0.20 animations:^{
            if (self.type == JKPushAndPopAnimationTransitionTypePush) {
                fromSnapshot.layer.transform = CATransform3DTranslate(fromSnapshot.layer.transform, -width, 0.0, 0.0);
                toViewController.view.layer.transform = CATransform3DTranslate(toViewController.view.layer.transform, width, 0.0, 0.0);
            } else if (self.type == JKPushAndPopAnimationTransitionTypePop) {
                fromSnapshot.layer.transform = CATransform3DTranslate(fromSnapshot.layer.transform, width, 0.0, 0.0);
                toViewController.view.layer.transform = CATransform3DTranslate(toViewController.view.layer.transform, -width, 0.0, 0.0);
            }
        }];
        
        //Pull the 'to' view in front of the 'from' view
        [UIView addKeyframeWithRelativeStartTime:0.40 relativeDuration:0.20 animations:^{
            fromSnapshot.layer.transform = CATransform3DTranslate(fromSnapshot.layer.transform, 0.0, 0.0, -200);
            toViewController.view.layer.transform = CATransform3DTranslate(toViewController.view.layer.transform, 0.0, 0.0, 500);
        }];
        
        //Adjust the views horizontally to place them back on top of eachother
        [UIView addKeyframeWithRelativeStartTime:0.60 relativeDuration:0.20 animations:^{
            CATransform3D fromT = fromSnapshot.layer.transform;
            CATransform3D toT = toViewController.view.layer.transform;
            if (self.type == JKPushAndPopAnimationTransitionTypePush) {
                fromT = CATransform3DTranslate(fromT, floorf(width), 0.0, 200.0);
                toT = CATransform3DTranslate(fromT, floorf(-(width*0.03)), 0.0, 0.0);
            } else if (self.type == JKPushAndPopAnimationTransitionTypePop) {
                fromT = CATransform3DTranslate(fromT, floorf(-width), 0.0, 200.0);
                toT = CATransform3DTranslate(fromT, floorf(width*0.03), 0.0, 0.0);
            }
            fromSnapshot.layer.transform = fromT;
            toViewController.view.layer.transform = toT;
        }];
        
        //Move the 'to' view to its final position
        [UIView addKeyframeWithRelativeStartTime:0.80 relativeDuration:0.20 animations:^{
            toViewController.view.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        [fromSnapshot removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - Helper Methods

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = oldOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

@end
