//
//  ViewController.m
//  DiceStat
//
//  Created by Александр Сорокин on 16.12.16.
//  Copyright © 2016 Александр Сорокин. All rights reserved.
//

#import "ViewController.h"
#import "ModelStats.h"
#import "NSArray (sortBy).h"

@interface ViewController ()

@property (strong, nonatomic) ModelStats *model;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *percentLabels;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *minusButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *plusButtons;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;


@property (assign, nonatomic) int total;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sort arrays which contains textView, labels, etc.
    
    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
        if ([obj1 frame].origin.y > [obj2 frame].origin.y) {
            return (NSComparisonResult)NSOrderedDescending;}
        if ([obj1 frame].origin.y < [obj2 frame].origin.y) {
            return (NSComparisonResult)NSOrderedAscending;}
        return (NSComparisonResult)NSOrderedSame;
    };
    
    self.textFields = [self.textFields sortedArrayUsingComparator:comparatorBlock];
    self.percentLabels = [self.percentLabels sortedArrayUsingComparator:comparatorBlock];
    self.plusButtons = [self.plusButtons sortedArrayUsingComparator:comparatorBlock];
    self.minusButtons = [self.minusButtons sortedArrayUsingComparator:comparatorBlock];
    
    //init Model
    ModelStats *model = [[ModelStats alloc] init];
    self.model = model;
    
   
    [self.resetButton addTarget:model action:@selector(resetStats) forControlEvents:UIControlEventTouchDragInside];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(modelDidChanged) name:ModelDidChangedNotification object:NULL];
    
    [model resetStats];
    [self culatePercents];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


- (IBAction)resetModel:(id)sender {
    [self.model resetStats];
}

- (IBAction)changeValue:(UIButton*) button{
    
    
    if ([self.plusButtons containsObject:button]) {
        
        int index = [self.plusButtons indexOfObject: button];
        int currentValue = [self.model getValueWithIndex:index];
        NSLog(@"current index is = %d", index);
        currentValue += 1;
        NSLog(@"inc to value %d", currentValue);
        [self.model changeValue:currentValue atIndex: index];
        
    } else  if ([self.minusButtons containsObject:button]){
        
        int index = [self.minusButtons indexOfObject: button];
        int currentValue = [self.model getValueWithIndex:index];
        NSLog(@"current index is = %d", index);
        currentValue -= 1;
        if (currentValue < 0 ) {
            currentValue = 0;
        };
        
        NSLog(@"dec to value %d", currentValue);
        [self.model changeValue:currentValue atIndex: index];
        
    } else {
        NSLog(@"wrong button label");
    }
}

- (int) calculateTotal {
    int result = 0;
    for (int i = 0; i <= 10; i++) {
        result += [self.model getValueWithIndex:i];
    }
    NSLog(@"calculated total is: %d", result);
    self.totalLabel.text = [NSString stringWithFormat:@"%d", result];
    self.total = result;
    return result;
}

- (void) culatePercents {
    [self calculateTotal];
    for ( int i = 0; i <= 10; i++) {
        float total = [[NSNumber numberWithInt:self.total] floatValue];
        //NSLog(@"int total= %d", self.total);
        //NSLog(@"float total= %f", total);
        float value = [[NSNumber numberWithInt: [self.model getValueWithIndex:i]] floatValue];
        
        float result = ( value *100 ) / total;
        
        NSString *text = [NSString  stringWithFormat:@"%f", result];
   
        UILabel *tl = self.percentLabels[i];
         tl.text = text;
    }
}

#pragma mark - Notification

-(void) modelDidChanged {
    
    //refresh model
    for (int i = 0; i <= 10; i++) {
        UITextField *tf = self.textFields[i];
        tf.text = [NSString stringWithFormat:@"%d",[self.model getValueWithIndex:i]];
    }
    
    //calculate percents
    [self culatePercents];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
