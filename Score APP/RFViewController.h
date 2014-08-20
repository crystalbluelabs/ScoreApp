//
//  RFViewController.h
//  Score APP
//

//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface RFViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (weak, nonatomic) IBOutlet UIButton *synopsisButton;

@property (weak, nonatomic) IBOutlet UIButton *annotationButton;
@property (weak, nonatomic) IBOutlet UIButton *preludeButton;
@property (weak, nonatomic) IBOutlet UIButton *fugueButon;

@property (weak, nonatomic) IBOutlet UIButton *toggleButtonLeft;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL showScore;
@property (nonatomic) BOOL shouldRestart;
@property (nonatomic) BOOL movement;


- (IBAction)toggleMovement:(id)sender;
- (IBAction)toggleTabBar:(id)sender;

- (IBAction)preludeButtonPress:(id)sender;
- (IBAction)fugueButtonPress:(id)sender;
- (IBAction)annotationButtonPress:(id)sender;


- (IBAction)playButtonPress:(id)sender;
- (IBAction)scoreButtonPress:(id)sender;
- (IBAction)restartButtonPress:(id)sender;
- (IBAction)purchaseButtonPress:(id)sender;
- (IBAction)synopsisButtonPress:(id)sender;

-(void)setPlayPauseImage:(NSString *)set;

@end
