//
//  ViewController.m
//  ThreeSevenAce
//
//  Created by NSSimpleApps on 26.10.14.
//  Copyright (c) 2014 NSSimpleApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (assign, nonatomic) BOOL cardViewIsAnimating;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSArray *arrayOfCardImages;

@end

static CFTimeInterval const periodOfRotation = 4.0;

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.arrayOfCardImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"threeOfHearts.jpg"],
                              [UIImage imageNamed:@"sevenOfClubs.jpg"], [UIImage imageNamed:@"aceOfSpades.jpg"], nil];
    
    CALayer *cardLayer = [CALayer layer];
    cardLayer.contents = (id)[self.arrayOfCardImages[0] CGImage];
    cardLayer.frame = CGRectMake(0.f, 0.f, self.cardView.frame.size.width, self.cardView.frame.size.height);
    cardLayer.doubleSided = NO;
    
    UIImage *backOfCardImage = [UIImage imageNamed:@"backOfCard.jpg"];
    
    CALayer *backOfCardLayer = [CALayer layer];
    backOfCardLayer.contents = (id)[backOfCardImage CGImage];
    backOfCardLayer.frame = CGRectMake(0.f, 0.f, self.cardView.frame.size.width, self.cardView.frame.size.height);
    //backOfCardLayer.doubleSided = NO;
    
    [self.cardView.layer addSublayer:backOfCardLayer];
    [self.cardView.layer addSublayer:cardLayer];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(-M_PI_2);
    animation.toValue = @(3*M_PI_2);
    animation.repeatCount = INFINITY;
    animation.duration = periodOfRotation;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/500.0;
    self.cardView.layer.sublayerTransform = transform;
    
    for (CALayer* layer in self.cardView.layer.sublayers) {
        
        [layer addAnimation:animation forKey:@"spiningCard"];
    }
    
    self.cardViewIsAnimating = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:periodOfRotation
                                                  target:self
                                                selector:@selector(changeTopCard)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)nextIndex {
    
    static NSInteger index = 0;
    
    if (index >= [self.arrayOfCardImages count] - 1) {
        
        index = 0;
        return index;
    }
    
    return ++index;
}

- (void)changeTopCard {
    
    CALayer* cardLayer = self.cardView.layer.sublayers[1];
    
    cardLayer.contents = (id)[self.arrayOfCardImages[[self nextIndex]] CGImage];
}

- (IBAction)startRotationAction:(UIButton *)sender {
    
    if (!self.cardViewIsAnimating) {
        
        CFTimeInterval pausedTime = [self.cardView.layer timeOffset];
        self.cardView.layer.speed = 1.0;
        self.cardView.layer.timeOffset = 0.0;
        self.cardView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.cardView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.cardView.layer.beginTime = timeSincePause;
        
        [self.timer fire];
        
        self.cardViewIsAnimating = YES;
    }
}
- (IBAction)stopRotationAction:(UIButton *)sender {
    
    if (self.cardViewIsAnimating) {
        
        CFTimeInterval pausedTime = [self.cardView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.cardView.layer.speed = 0.0;
        self.cardView.layer.timeOffset = pausedTime;
        
        [self.timer invalidate];
        
        self.cardViewIsAnimating = NO;
    }
}

@end
