//
//  Enum.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/8/3.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#ifndef Enum_h
#define Enum_h

typedef enum {
    
    ENUM_HP_AUTOSIZE=0,// 自动设置大小
    ENUM_HP_DEFINESIZE=1,//只需要设置为默认大小
    ENUM_HP_AUTOMINSIZE=2 //自动设置大小 默认最小为minWidth
    
}AutoSizeType;

typedef struct {
    NSInteger left;
    NSInteger centre;
    NSInteger right;
}HPCachePoint;

static inline HPCachePoint
HPCachePointMake(NSInteger left, NSInteger centre,NSInteger right)
{
    HPCachePoint point;
    point.left=left;
    point.centre=centre;
    point.right=right;
    return point;
}

#endif /* Enum_h */
