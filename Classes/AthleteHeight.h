//
//  AthleteHeight.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Inches,
    Centimeters
} HeightUnits;

@interface AthleteHeight : NSObject {
    NSNumber *height;
    HeightUnits units;
}

@property (nonatomic, retain) NSNumber *height;
@property (nonatomic) HeightUnits units;

- (id)initWithHeight:(NSNumber *)aHeight usingUnits:(HeightUnits)aUnit;

- (NSNumber *)heightAsInches;
- (NSNumber *)heightAsCentimeters;

@end
