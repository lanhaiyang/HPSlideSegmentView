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
    
    switch (self.gestrueType) {
        case HPScroll_Open_Define:
        {
            return YES;
        }
            break;
        case HPScrollView_Filter_GestureCell:
        {
            //UITableViewCell 删除手势
            return gestureRecognizer.state != 0 ? YES : NO;
        }
            break;
        default:
            break;
    }
    

}

@end
