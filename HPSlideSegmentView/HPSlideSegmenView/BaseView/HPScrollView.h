//
//  HPScrollView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/28.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    HPScroll_Open_Define = 0,
    HPScrollView_Filter_GestureCell = 1
    
}HPGestureSlideType;

@interface HPScrollView : UIScrollView<UIGestureRecognizerDelegate>


@property(nonatomic,assign) HPGestureSlideType gestrueType;

@end
