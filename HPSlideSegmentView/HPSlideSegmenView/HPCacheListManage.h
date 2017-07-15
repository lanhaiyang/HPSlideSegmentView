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
typedef id (^CreatBlock)(id weakObj,NSUInteger key);


@protocol HPCacheListManageDelegate <NSObject>

-(void)removeWithCacheObj:(id)Obj;

@end

@interface HPCacheListManage : NSObject

/**
 默认小于3默认为3
 */
@property(nonatomic,assign) NSUInteger cacheListMax;
@property(nonatomic,weak) id<HPCacheListManageDelegate> delegate;


/**
 缓存策论

 @param left 左边缓存的结构体
 @param centre 中间缓存的结构体
 @param right 右边缓存的结构体
 @param weakObj 需要在block中弱引用的对象
 @param layoutBlock 布局block (weakObj,缓存的对象,位置模块,位置)
 @param creatBlock 创建缓存对象的block (weakObj,位置)
 */
-(void)addCacheWithLeft:(ObjcWithKeyStruct)left
                 Centre:(ObjcWithKeyStruct)centre
                  Right:(ObjcWithKeyStruct)right
                weakObj:(id)weakObj
            layoutBlock:(LayoutBlock)layoutBlock
     notCahceCreatBlock:(CreatBlock)creatBlock;


/**
 获得缓存对象

 @param key 缓存的key
 @return 返回缓存对象
 */
-(id)cacheWithKey:(id)key;

@end
