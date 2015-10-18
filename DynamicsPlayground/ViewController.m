//
//  ViewController.m
//  DynamicsPlayground
//
//  Created by Michael on 9/1/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>
{
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    BOOL _firstContact;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self doAnimator];
}

- (void)doAnimator {
    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    UIView *barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    UIView *secondBarrier = [[UIView alloc] initWithFrame:CGRectMake(0, 400, 250, 20)];
    secondBarrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:secondBarrier];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[square]];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[square]];
    _collision.collisionDelegate = self;
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    
    CGPoint secondBarrierRightEdge = CGPointMake(secondBarrier.frame.origin.x + secondBarrier.frame.size.width, secondBarrier.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"secondBarrier" fromPoint:barrier.frame.origin toPoint:secondBarrierRightEdge];
    //    _collision.action = ^{
    //        //NSLog(@"%@, %@", NSStringFromCGAffineTransform(square.transform), NSStringFromCGPoint(square.center));
    //    };
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    itemBehavior.elasticity = 0.6;
    [_animator addBehavior:itemBehavior];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"Boundary contact occurred - %@", identifier);
    
    UIView *view = (UIView *)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];
    
    if (!_firstContact) {
        _firstContact = YES;
        
        UIView *square = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 100)];
        square.backgroundColor = [UIColor grayColor];
        [self.view addSubview:square];
        
        [_collision addItem:square];
        [_gravity addItem:square];
        
        UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:square];
        [_animator addBehavior:attach];
    }
}
@end
