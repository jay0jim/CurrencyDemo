//
//  DataModel.h
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Resources;
@class Currency;

@interface DataModel : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *allCurrencyDic;

// displayArray用于存放自选货币的简写，NSString类型
@property (strong, nonatomic, readonly) NSMutableArray *displayArray;

@property (strong, nonatomic, readonly) NSArray *namesArray;
@property (strong, nonatomic, readonly) NSMutableArray *fullNamesArray;
@property (strong, nonatomic, readonly) NSMutableArray *chineseNamesArray;

+ (id)sharedInstance;

// 获取数据
- (void)startFetchData;

// 自选操作
- (void)addDisplayCurrencyName:(NSString *)name;
- (void)removeDisplayCurrencyName:(NSString *)name;

// 文件处理
- (void)saveDisplay;
- (void)loadDisplay;

@end
