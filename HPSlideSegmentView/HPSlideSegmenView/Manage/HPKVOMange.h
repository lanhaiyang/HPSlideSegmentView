//
//  HPKVOMange.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/8/30.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KVOMangeBlock)(id weakObj);

@interface HPKVOMange : NSObject


/**
 添加进管理对象

 @param observerObject kvo 管理的对象
 @param weakObj block弱引用的对象
 @param block 创建监听者
 */
-(void)addObserverWithObject:(id)observerObject  blockWeak:(id)weakObj addObserver:(KVOMangeBlock)block;


/**
 判断监听对象是否已经存在

 @param observerObject 判断监听的对象
 @return 返回是否存在
 */
-(BOOL)containObserverWithObject:(id)observerObject;


/**
 删除监听

 @param observerObject 删除监听的管理对象
 @param weakObj 在block需要弱引用的对象
 @param block 删除监听者
 */
-(void)removeObserverWithObject:(id)observerObject blockWeak:(id)weakObj addObserver:(KVOMangeBlock)block;


/**
 删除所以的监听者

 @param observer 当前使用监听者的类
 */
-(void)removeAllObserverUseObserver:(id)observer;

@end
