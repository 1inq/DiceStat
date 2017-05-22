//
//  ModelStats.h
//  DiceStat
//
//  Created by Александр Сорокин on 16.12.16.
//  Copyright © 2016 Александр Сорокин. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const ModelDidChangedNotification;

@interface ModelStats : NSObject

@property (strong, nonatomic) NSMutableArray *array;

- (void) resetStats;
- (void) changeValue: (int) value atIndex: (int) index;
- (int) getValueWithIndex: (int) index;


@end
