//
//  RFScoreSheet.m
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFScoreSheet.h"

static const int NUMBER_OF_MEASURES = 35;
static const int SONG_TEMPO = 50;
static const float SONG_PPS = 4.8;
static const NSString *SONG_NAME = @"BachPrelude_";

@implementation RFScoreSheet

-(id)initWithScore
{
    if (self = [self init]) {
        [self initializeScore];
    }
    return self;
}

-(void)initializeScore
{
    
    self.score = [[NSMutableArray alloc] init];
    self.startPos = [[NSMutableArray alloc] init];
    self.endPos = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NUMBER_OF_MEASURES; ++i) {
        NSString *measure = [[NSString alloc] init];
        measure = [NSString stringWithFormat:@"%@%02i.png", SONG_NAME, i];
        [self.score addObject:measure];
    }
    self.currentFrame = 0;
    self.tempo = SONG_TEMPO;
    self.PPS = SONG_PPS;
    /* self.startTime = @[@0, @5.038, @10.112, @15.232, @20.292,
                       @25.231, @30.324, @35.375, @40.507, @45.569,
                       @50.607, @55.635, @60.557, @65.410, @70.286,
                       @75.139, @80.480, @85.519, @90.627, @95.712,
                       @100.693, @105.848, @110.991, @116.030, @121.010,
                       @125.863, @130.879, @135.825, @140.863, @145.879,
                       @150.767, @155.945, @161.204, @166.545, @173.093]; */
    
    self.startTime = @[@0, @5.238, @10.312, @15.432, @20.492,
                       @25.231, @30.524, @35.575, @40.707, @45.769,
                       @50.807, @55.835, @60.757, @65.610, @70.486,
                       @75.339, @80.680, @85.542, @90.827, @95.912,
                       @100.893, @106.048, @111.191, @116.230, @121.210,
                       @126.063, @131.079, @136.025, @141.063, @146.079,
                       @150.967, @156.145, @161.404, @166.745, @173.293];
    
    NSLog(@"%@", self.score);
    
    self.measureWidth = [[NSMutableArray alloc] initWithArray: @[@997, @1026, @995, @984, @1029,
                                                                 @1001, @1017, @1025, @1025, @1038,
                                                                 @1014, @1073, @1024, @1049, @1031,
                                                                 @1562, @1556, @1561, @1572, @1585,
                                                                 @1574, @1589, @1570, @1582, @1574,
                                                                 @1610, @1595, @1603, @1590, @1588,
                                                                 @1594, @1590, @1579, @2442, @725]];
}

@end
