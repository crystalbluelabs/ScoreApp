//
//  RFScoreScene.m
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFScoreScene.h"
#import "RFScoreSheet.h"
#import "SKTUtils.h"
#import "SKNode+SKTDebugDraw.h"
#import "SKAction+SKTSpecialEffects.h"
#import <AVFoundation/AVFoundation.h>

#define BACKGROUND_COLOR [SKColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]
static const int NUMBER_OF_MEASURES = 35;
static const NSString *SONG_NAME = @"BachPrelude_";
static const int CLEF_WIDTH = 153;
//static const float TEMPO_IN_MS = 3.038;

@implementation RFScoreScene {
    
    // The score
    RFScoreSheet *_score;
    
    // Timing variables
    float _lastUpdateTime;
    float _dt;
    CGPoint _deltaPoint;
    int _currentMeasure;
    
    // Boolean Conditionals for logic control
    BOOL _isScrubbing;
    BOOL _scoreHidden;
    BOOL _toggleAnalysis;
    
    // Layer Nodes
    SKNode *_whiteBack;
    SKNode *_scoreNode;
    SKNode *_trebleNode;
    SKNode *_bassNode;
    SKNode *_analysisNode;
    SKNode *_overlayNode;
    SKNode *_overlayBassNode;
    SKNode *_UILayer;
    AVPlayer *_player;
    
    // Audio Variables
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        _whiteBack = [SKNode node];
        SKSpriteNode *whiteBackG = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:self.frame.size];
        whiteBackG.anchorPoint = CGPointMake(0, 1);
        whiteBackG.position = CGPointMake(0, self.frame.size.height);
        [_whiteBack addChild:whiteBackG];
        _score = [[RFScoreSheet alloc] initWithScore];
        
        _toggleAnalysis = NO;
        
        // Score node
        _scoreNode = [SKNode node];
        
        // Measure nodes
        _trebleNode = [SKNode node];
        _bassNode = [SKNode node];
        _analysisNode = [SKNode node];
        
        [_scoreNode addChild:_trebleNode];
        [_scoreNode addChild:_bassNode];
        [_scoreNode addChild:_analysisNode];
        
        [self addChild:_whiteBack];
        [self addChild:_scoreNode];
        //NSLog(@"Node POS: %f", _scoreNode.position.x);
        
        // Initialize Overlay Node for Track Line and Scores Staff
        _overlayNode = [SKNode node];
        _overlayBassNode = [SKNode node];
        _UILayer = [SKNode node];
        [self addChild:_overlayNode];
        [self addChild:_overlayBassNode];
        [self addChild:_UILayer];
        
        [self initAudio];
        [self initializeScore];
        [self initTrackingLine];
    }
    return self;
}

-(void)initAudio
{
    NSURL *song = [[NSBundle mainBundle] URLForResource:@"BachPrelude" withExtension:@"m4a"];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:song error:&error];
    [_audioPlayer prepareToPlay];
}

-(void)initTrackingLine
{
    // Add Tracking Line
    UIColor *trackLineColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.8];
    CGSize trackLineSize = CGSizeMake(4, 320);
    SKSpriteNode *trackLine = [[SKSpriteNode alloc] initWithColor:trackLineColor size:trackLineSize];
    trackLine.name = @"TrackLine";
    trackLine.anchorPoint = CGPointMake(0, 1);
    trackLine.position = CGPointMake(0, self.size.height);
    trackLine.zPosition = 100;
    trackLine.alpha = .75;
    [_UILayer addChild:trackLine];
    
    // Add Tracking Dot
    UIColor *trackDotColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1];
    CGSize trackDotSize = CGSizeMake(4, 4);
    SKSpriteNode *trackDot = [[SKSpriteNode alloc] initWithColor:trackDotColor size:trackDotSize];
    trackDot.name = @"TrackingDot";
    trackDot.anchorPoint = CGPointMake(0, 1);
    trackDot.position = CGPointMake(0, self.size.height);
    trackDot.zPosition = 101;
    [_UILayer addChild:trackDot];
    _UILayer.zPosition = 11;
}

-(void)initializeScore {
    double scoreXPos = CLEF_WIDTH;
    _currentMeasure = 1;
    
    SKSpriteNode *clef = [SKSpriteNode spriteNodeWithImageNamed:@"FullClef_Treble"];
    SKSpriteNode *bassClef = [SKSpriteNode spriteNodeWithImageNamed:@"FullClef_Bass"];
    SKSpriteNode *clefBG = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(CLEF_WIDTH, 160)];
    SKSpriteNode *bassClefBG  = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(CLEF_WIDTH, 160)];
    clefBG.anchorPoint = CGPointMake(0, 1);
    clefBG.position = CGPointMake(0, self.size.height);
    bassClefBG.anchorPoint = CGPointMake(0, 1);
    bassClefBG.position = CGPointMake(0, self.size.height/2);
    CGSize clefSize = CGSizeMake(clef.size.width/2, clef.size.height/2);
    clef.anchorPoint = CGPointMake(0, 1);
    clef.size = clefSize;
    clef.position = CGPointMake(0, self.size.height);
    bassClef.anchorPoint = CGPointMake(0,1);
    bassClef.size = clefSize;
    bassClef.position = CGPointMake(0, self.size.height / 2);
    
    bassClefBG.zPosition = 4;
    bassClef.zPosition = 5;
    clefBG.zPosition = 4;
    clef.zPosition = 5;
    
    [_overlayNode addChild:clefBG];
    [_overlayNode addChild:clef];
    [_overlayBassNode addChild:bassClefBG];
    [_overlayBassNode addChild:bassClef];
    
    
    
    // Create Score
    for (int i = 0; i < NUMBER_OF_MEASURES; ++i) {
        
        // Treble Score Sprite to add to array.
        SKSpriteNode *trebleSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"prelude_treb_%02i.png", i + 1]];
        trebleSprite.anchorPoint = CGPointMake(0,1);
        trebleSprite.size = CGSizeMake([_score.measureWidth[i] floatValue] / 2, 320);
        trebleSprite.position = CGPointMake(scoreXPos, self.size.height);
        
        SKSpriteNode *bassSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"prelude_bass_%02i.png", i + 1]];
        bassSprite.anchorPoint = CGPointMake(0,1);
        bassSprite.size = CGSizeMake([_score.measureWidth[i] floatValue] / 2, 320);
        bassSprite.position = CGPointMake(scoreXPos, self.size.height + 2);
        
        
        SKSpriteNode *analysisSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"prelude_analysis_%02i.png", i + 1]];
        analysisSprite.anchorPoint = CGPointMake(0, 1);
        analysisSprite.size = CGSizeMake([_score.measureWidth[i] floatValue] / 2, 320);
        analysisSprite.position = CGPointMake(scoreXPos, self.size.height - 75);
        
        // Add float value for the X coords of the new sprite to an array for tracking.
        [_score.startPos addObject:[NSNumber numberWithUnsignedInt:scoreXPos]];
        
        // Increment the starting position for the next sprite to be added.
        scoreXPos += trebleSprite.size.width;
        [_score.endPos addObject:[NSNumber numberWithDouble:scoreXPos]];
        _score.endPoint = scoreXPos;
        trebleSprite.name = @"Score";
        trebleSprite.zPosition = 2;
        bassSprite.zPosition = 3;
        [_trebleNode addChild:trebleSprite];            // Treble   Sprite
        [_bassNode addChild:bassSprite];                // Bass     Sprite
        [_analysisNode addChild:analysisSprite];        // Analysis Sprite
    }
    
    [_score.startPos addObject:[NSNumber numberWithDouble:-1.0]];
    
    
    SKSpriteNode *trackingLine = [SKSpriteNode spriteNodeWithImageNamed:@"Trackingline.png"];
    CGSize halvedLine = CGSizeMake(trackingLine.frame.size.width/2, trackingLine.frame.size.height);
    
    trackingLine.size = halvedLine;
    trackingLine.anchorPoint = CGPointMake(0,1);
    trackingLine.position = CGPointMake(clefSize.width, self.size.height);
    trackingLine.zPosition = 3;
    [_overlayNode addChild:trackingLine];
}

-(void)checkPOS
{
    double currentPOS = ABS(_scoreNode.position.x);
    double currentStartPOS;
    double nextStartPOS;
    
    //NSLog(@"Start Check POS");
    
    for (int i = 0; i < [_score.startPos count]; i++)
    {
        currentStartPOS = ABS([[_score.startPos objectAtIndex:i] doubleValue]) - CLEF_WIDTH;
        //NSLog(@"%f - %f", currentStartPOS, currentPOS);
        if (currentStartPOS < currentPOS)
        {
            if (([[_score.startPos objectAtIndex:i] floatValue] == -1.0)) return;
            nextStartPOS = [[_score.startPos objectAtIndex:i + 1] doubleValue] - CLEF_WIDTH;
            
            //NSLog(@"%f - %f", nextStartPOS, currentPOS);
            if (nextStartPOS > currentPOS)
            {
                _currentMeasure = i + 1;
                NSLog(@"Current Measure! %i", _currentMeasure);
                return;
            }
        }
    }
}

-(void)updateScorePOS {
    double width;
    double thisMeasure;
    double nextMeasure;
    float speed;
    double currentStart;
    double nextStart;
    float timeForMeasure;
    
    double currentPOS;
    float audioPerc;                    //audio sync per measure
    double thisTime;
    double nextTime;
    double currentTime;
    double currentTimeInMeasure;
    double timePerc;
    
    if(_parentViewController.isPlaying){
        [_parentViewController setPlayPauseImage:@"pause"];
        nextMeasure = [_score.startPos[_currentMeasure] doubleValue];
        
        width = [_score.measureWidth[_currentMeasure - 1] doubleValue] / 2;
        thisMeasure = [_score.startPos[_currentMeasure - 1] doubleValue] + (width * 0.04);
        
        currentStart = [_score.startTime[_currentMeasure - 1] doubleValue];
        nextStart = [_score.startTime[_currentMeasure] doubleValue];
        timeForMeasure = nextStart - currentStart;
        speed = width / timeForMeasure;
        
        currentTime = _audioPlayer.currentTime;
        currentTimeInMeasure = currentTime - currentStart;
        timePerc = currentTimeInMeasure / timeForMeasure;
        double xPos = (timePerc * width) + thisMeasure - CLEF_WIDTH;
        _scoreNode.position = CGPointMake(-1*(xPos), 0);
        /*
        CGPoint moveAmt = CGPointMake(-speed * _dt, 0);
        NSLog(@"Time for measure - - - - - - - - %f", timeForMeasure);
        if (_scoreNode.position.x <= 0) {
            _scoreNode.position = CGPointAdd(_scoreNode.position, moveAmt);
        }*/
    }
    if(_isScrubbing){
        CGPoint newPoint = CGPointAdd(_scoreNode.position, _deltaPoint);
        newPoint.y = _scoreNode.position.y;
        thisMeasure = [_score.startPos[_currentMeasure - 1] doubleValue];
        nextMeasure = [_score.startPos[_currentMeasure] doubleValue];
        
        thisTime = [_score.startTime[_currentMeasure - 1] doubleValue];
        nextTime = [_score.startTime[_currentMeasure] doubleValue];
        
        currentPOS = ABS(_scoreNode.position.x - CLEF_WIDTH) - thisMeasure;
        audioPerc = (nextTime - thisTime) * (currentPOS / ([_score.measureWidth[_currentMeasure - 1] doubleValue] / 2));
        //NSLog(@"&&&&&&&&&&&&&&&   %f", audioPerc + thisTime);
        _audioPlayer.currentTime = audioPerc + thisTime;
        [_audioPlayer prepareToPlay];
        if(newPoint.x <= 0) {
            _scoreNode.position = newPoint;
        }
        _deltaPoint = CGPointZero;
    }
}

-(void)updateTrackDot
{
    float currentPOS = ABS(_scoreNode.position.x);
    //NSLog(@"Current Position: %f - %f", currentPOS, _score.endPoint);
    float dotPercent = currentPOS / _score.endPoint;
    [_overlayNode enumerateChildNodesWithName:@"TrackingDot" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *dot = (SKSpriteNode *)node;
        dot.position = CGPointMake(self.size.width * dotPercent, self.size.height);
    }];
    
    // Update Tracking Color
    SKSpriteNode *trackingLine = [[SKSpriteNode alloc] init];
    trackingLine = (SKSpriteNode *)[_overlayNode childNodeWithName:@"TrackLine"];
    SKSpriteNode *trackingDot = [[SKSpriteNode alloc] init];
    trackingDot = (SKSpriteNode *)[_overlayNode childNodeWithName:@"TrackingDot"];
    
    if (_parentViewController.movement) {
        trackingLine.color = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:.75];
        trackingDot.color = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1];
    } else {
        trackingLine.color = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:.75];
        trackingDot.color = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1];
    }
}

-(void)toggleAnalysis
{
    // toggle code here
    SKAction *moveTrebScore;
    SKAction *moveBassScore;
    SKAction *moveAnalysis;
    
    if (!_toggleAnalysis) {
        moveTrebScore = [SKAction moveToY:10 duration:1];
        moveBassScore = [SKAction moveToY:45 duration:1];
        moveAnalysis = [SKAction moveToY:60 duration:1];
        _toggleAnalysis = YES;
    } else {
        moveTrebScore = [SKAction moveToY:0 duration:1];
        moveBassScore = [SKAction moveToY:0 duration:1];
        moveAnalysis = [SKAction moveToY:-75 duration:1];
        _toggleAnalysis = NO;
    }
    
    [_trebleNode runAction:moveTrebScore];
    [_overlayNode runAction:moveTrebScore];
    [_bassNode runAction:moveBassScore];
    [_overlayBassNode runAction:moveBassScore];
    [_analysisNode runAction:moveAnalysis];
}

-(void)updateScoreView
{
    //NSLog(@"Update Score! %hhd", _parentViewController.showScore);
    if(_parentViewController.showScore) {
        [self toggleScore:YES];
    } else {
        [self toggleScore:NO];
    }
}

-(void)toggleScore:(BOOL)on
{
    if(on){
        _whiteBack.hidden = NO;
        _scoreNode.hidden = NO;
        _overlayNode.hidden = NO;
        //NSLog(@"Score ON");
    } else {
        _whiteBack.hidden = YES;
        _scoreNode.hidden = YES;
        _overlayNode.hidden = YES;
        //NSLog(@"Score OFF");
    }
}

-(void)restartPlayer
{
    CGPoint newPoint;
    newPoint.x = 0;
    newPoint.y = _scoreNode.position.y;
    _scoreNode.position = newPoint;
    _audioPlayer.currentTime = 0;
    [_audioPlayer prepareToPlay];
}

#pragma mark - iOS Functions

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _parentViewController.isPlaying = NO;
    [_audioPlayer pause];
    [_parentViewController setPlayPauseImage:@"play"];
    _isScrubbing = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint =
    [[touches anyObject] locationInNode:self];
    CGPoint previousPoint =
    [[touches anyObject] previousLocationInNode:self];
    _deltaPoint = CGPointSubtract(currentPoint, previousPoint);
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _deltaPoint = CGPointZero;
    _parentViewController.isPlaying = NO;
    [_parentViewController setPlayPauseImage:@"play"];
    _isScrubbing = NO;
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    _deltaPoint = CGPointZero;
    _parentViewController.isPlaying = NO;
    [_parentViewController setPlayPauseImage:@"play"];
    _isScrubbing = NO;
}

#pragma mark - Helper Functions

-(double)withTwoPlaces:(double)val {
    return (ceil((val * 100)) / 100);
}

-(double)measureEasing:(double)t begining:(double)b change:(double)c totalTime:(double)d {
    t /= d;
    t--;
    return c * sqrt(1 - t*t) + b;
}

-(void)update:(CFTimeInterval)currentTime {
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    [self updateScorePOS];
    [self updateTrackDot];
    [self updateScoreView];
    [self checkPOS];
}

@end
