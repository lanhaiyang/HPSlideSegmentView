//
//  HPCacheListManage.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/7/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    LEFTTYPE=1<<0,
    CENTRETYPE=1<<1,
    RIGHTTYPE=1<<2
    
}DirectionType;


typedef struct {
    
    NSInteger keyNum;
    DirectionType directionType;
    
}ObjcWithKeyStruct;


CG_INLINE ObjcWithKeyStruct
ObjcWithKeyStructMake(NSInteger keyNum,DirectionType type)
{
    ObjcWithKeyStruct direction;
    direction.keyNum=keyNum;
    direction.directionType=type;
    return direction;
}



typedef void (^LayoutBlock)(id weakObj,id cacheObje,DirectionType direction,NSUInteger key);
typedef id (^CreatBlock)(id weakObj,id cacheObj,NSUInteger key);


@protocol HPCacheListManageDelegate <NSObject>

-(void)removeWithCacheObj:(id)Obj;

/**
 创建缓存对象
 
 @param cacheObj 缓存对象是否存在
 @param key 位置
 */
-(id)hp_notCahceCreat:(id)cacheObj pageIndex:(NSUInteger)key;


/**
 缓存对象布局

 @param cacheObje 缓存对象
 @param direction 位置模块
 @param key 位置
 */
-(void)hp_cacheWithLayout:(id)cacheObje direction:(DirectionType)direction page:(NSUInteger)key;


/**
 当缓存操作完成时执行更新
 */
-(void)hp_updateWihtLayotu;

@end

@interface HPCacheListManage : NSObject

/**
 小于3默认为3
 */
@property(nonatomic,assign) NSUInteger cacheListMax;


@property(nonatomic,weak) id<HPCacheListManageDelegate> delegate;


/**
 缓存策论

 @param left 左边缓存的结构体
 @param centre 中间缓存的结构体
 @param right 右边缓存的结构体
 @param update 是否需要更新创建view的信息
 */
-(void)addCacheWithLeft:(ObjcWithKeyStruct)left
                 Centre:(ObjcWithKeyStruct)centre
                  Right:(ObjcWithKeyStruct)right
          updateContent:(BOOL)update;


/**
 获得缓存对象

 @param key 缓存的key
 @return 返回缓存对象
 */
-(id)cacheWithKey:(id)key;

@end
