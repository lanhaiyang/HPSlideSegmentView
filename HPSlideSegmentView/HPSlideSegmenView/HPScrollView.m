//
//  HPScrollView.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/28.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPScrollView.h"

@implementation HPScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
