//
//  UIView+HPSlideSegmentRect.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/15.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "UIView+HPSlideSegmentRect.h"

@implementation UIView (HPSlideSegmentRect)

-(void)setWidth:(CGFloat)width
{
    self.bounds=CGRectMake(0, 0, width, self.height);
}

-(void)setHeight:(CGFloat)height
{
    self.bounds=CGRectMake(0, 0, self.width, height);
}


-(void)setX:(CGFloat)x
{
    self.frame=CGRectMake(x, self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y
{
    self.frame=CGRectMake(self.x, y, self.width, self.height);
}


-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)width
{
    return self.bounds.size.width;
}

-(CGFloat)height
{
    return self.bounds.size.height;
}

@end
