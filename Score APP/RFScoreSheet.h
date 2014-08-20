//
//  RFScoreSheet.h
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFScoreSheet : NSObject

@property (nonatomic, strong) NSMutableArray *score;
@property (nonatomic) int currentFrame;
@property (nonatomic) int tempo;
@property (nonatomic) float PPS;
@property (nonatomic, strong) NSMutableArray *startPos; // Length of each measure for calcuations.
@property (nonatomic, strong) NSMutableArray *endPos; // Length of each measure for calcuations.
@property (nonatomic, strong) NSArray *startTime;
@property (nonatomic, strong) NSMutableArray *measureWidth;
@property (nonatomic) float endPoint;
@property (nonatomic) CGPoint timeSignature;

-(id)initWithScore;

@end
