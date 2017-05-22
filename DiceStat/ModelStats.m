//
//  ModelStats.m
//  DiceStat
//
//  Created by Александр Сорокин on 16.12.16.
//  Copyright © 2016 Александр Сорокин. All rights reserved.
//

#import "ModelStats.h"

NSString* const ModelDidChangedNotification = @"ModelDidChangedNotification";

@implementation ModelStats

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray arrayWithCapacity:11];
        [self resetStats];
    }
    return self;
}

#pragma mark - Methods

- (void) resetStats {
    
    for (int i = 0; i<=10; i++) {
        self.array[i] = [NSNumber numberWithInteger:0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ModelDidChangedNotification
                                                        object:NULL];
};

- (void) changeValue: (int) value atIndex: (int) index{
    if (index >= 0 && index <= 10) {
        
        /*
        NSLog(@" change value to %d", value);
        NSLog(@" at index to %d", index);
        */
        
        //__weak ModelStats *model = [self.model];
        
        NSNumber *number = [NSNumber numberWithInteger:value];
        NSLog(@"Number is= %@", [number stringValue]);
        
        [self.array replaceObjectAtIndex:index withObject:number];
        
        NSLog(@"value at index to %i", self.array[index]);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ModelDidChangedNotification
                                                            object:NULL];
    };
};

- (int) getValueWithIndex: (int) i {
    int value = (int)[self.array[i] integerValue];
    NSLog(@"%d", value);
    return value;
};

@end
