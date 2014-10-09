//
//  ViewController.m
//  Prototype
//
//  Created by 阿涛 on 14-8-28.
//  Copyright (c) 2014年 PM. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){
    
    int currentValue;//当前靶心的值
    int difficulty;//命中难度
    int targetValue;//游戏目标值
    int score;//游戏总分数
    int round;//游戏总回合数
    int tailNumber;//当前靶心的值个位数
    BOOL openedSwitch;//开启秘籍
    
}

- (IBAction)sliderMoved:(id)sender;

- (IBAction)showAlert:(id)sender;

- (IBAction)setDifficulty:(id)sender;

- (IBAction)startOver:(id)sender;

- (IBAction)showInfo:(id)sender;

- (IBAction)switchEggshell:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UISlider *sliderDiffculty;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UILabel *difficultyLable;
@property (strong, nonatomic) IBOutlet UILabel *paintedeggshellLable;
@property (strong, nonatomic) IBOutlet UISwitch *eggSwitch;

@end

@implementation ViewController

@synthesize slider,sliderDiffculty,targetLabel,scoreLabel,roundLabel,audioPlayer,difficultyLable,eggSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
    
    difficulty=1;
    self.difficultyLable.text=[NSString stringWithFormat:@"%d",difficulty];
    openedSwitch=false;
    self.eggSwitch.on=false;
    self.paintedeggshellLable.text=@"";
    
    [self startNewGame];
    
    [self playBackgroundMusic];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startNewGame{
    score = 0;
    round = 0;
    [self startNewRound];
}

-(void)startNewRound{
    targetValue = 1+(arc4random()%100);
    currentValue = 50;
    self.slider.value = currentValue;
    round +=1;
    tailNumber=0;
    
    [self updateLabels];
}

-(void)updateLabels{
    self.targetLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d",round];
    //self.paintedeggshellLable.text=[NSString stringWithFormat:@"%d",tailNumber];
}

- (IBAction)showAlert:(id)sender {
    
    int difference=abs(targetValue-currentValue);
    
    int points = (100-difference)/5;
    
    NSString *title;
    
    if(difference <=(5-difficulty)){
        title = @"完美表现，你太NB了!";
        points=200;
        
    }else if(difference <(10-difficulty)){
        title = @"太棒了,差一点就到了!";
    
    }else if(difference <(15-difficulty)){
        title = @"还不错！";
    }else{
        title = @"差太远了吧!";
    }
    
    score += points;
    
    NSString *message = [NSString stringWithFormat:@"恭喜高富帅,您的得分是: %d",points];
    
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"继续玩～！" otherButtonTitles:nil, nil]show];
}

- (IBAction)setDifficulty:(id)sender {
    UISlider *inslider = (UISlider*)sender;
    difficulty = (int)lroundf(inslider.value);
    self.difficultyLable.text=[NSString stringWithFormat:@"%d",difficulty];
}

- (IBAction)sliderMoved:(id)sender {
    UISlider *inslider = (UISlider*)sender;
    currentValue = (int)lroundf(inslider.value);
    tailNumber=fmod(currentValue,10);
    
    if(openedSwitch){
        self.paintedeggshellLable.text=[NSString stringWithFormat:@"%d",tailNumber];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:
    (NSInteger)buttonIndex{
    [self startNewRound];
}

- (IBAction)startOver:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; transition.duration = 3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self startNewGame];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo:(id)sender {
    AboutViewController *controller = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)switchEggshell:(id)sender {
    UISwitch *ineggSwitch =(UISwitch*)sender;
    openedSwitch = ineggSwitch.on;
    if(!openedSwitch) {
        self.paintedeggshellLable.text=@"";
    } else {
        self.paintedeggshellLable.text=[NSString stringWithFormat:@"%d",tailNumber];
    }
    
}

-(void)playBackgroundMusic{
    NSString *musicPath =[[NSBundle mainBundle]pathForResource:@"01 Prelude Nr.1 C-dur,BWV846" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicPath]; NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error]; audioPlayer.numberOfLoops = -1;
    if(audioPlayer ==nil){
        NSString *errorInfo = [NSString stringWithString:[error description]];
        NSLog(@"the error is:%@",errorInfo);
    }else{
        [audioPlayer play];
    }
}

@end
