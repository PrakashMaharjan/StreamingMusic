//
//  ViewController.h
//  FMApp
//
//  Created by Prakash Maharjan on 3/17/17.
//  Copyright © 2017 Prakash Maharjan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// outlets for play, pause  button, volume slider and status label
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeControlSlider;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//action for volume slider
- (IBAction)sliderChanged:(UISlider *)sender;

@end

