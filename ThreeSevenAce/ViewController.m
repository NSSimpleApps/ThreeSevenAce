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

@end

static CFTimeInterval const periodOfRotation = 4.0;

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CALayer *cardLayer = [CALayer layer];
    cardLayer.frame = CGRectMake(0.f, 0.f, self.cardView.frame.size.width, self.cardView.frame.size.height);
    cardLayer.doubleSided = NO;
    
    CALayer *backOfCardLayer = [CALayer layer];
    backOfCardLayer.contents = (id)[UIImage imageNamed:@"backOfCard.jpg"].CGImage;
    backOfCardLayer.frame = CGRectMake(0.f, 0.f, self.cardView.frame.size.width, self.cardView.frame.size.height);
    //backOfCardLayer.doubleSided = NO;
    
    [self.cardView.layer addSublayer:backOfCardLayer];
    [self.cardView.layer addSublayer:cardLayer];
    
    CABasicAnimation* rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotation.fromValue = @(-M_PI_2);
    rotation.toValue = @(3*M_PI_2);
    rotation.repeatCount = INFINITY;
    rotation.duration = periodOfRotation;
    
    CAKeyframeAnimation *animContents = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animContents.calculationMode = kCAAnimationDiscrete;
    
    NSArray *values = @[(id)[UIImage imageNamed:@"threeOfHearts.jpg"].CGImage,
                        (id)[UIImage imageNamed:@"sevenOfClubs.jpg"].CGImage,
                        (id)[UIImage imageNamed:@"aceOfSpades.jpg"].CGImage];
    
    animContents.values = values;
    animContents.duration = values.count*periodOfRotation;
    animContents.fillMode = kCAFillModeForwards;
    animContents.repeatCount = INFINITY;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/500.0;
    
    self.cardView.layer.sublayerTransform = transform;
    
    for (CALayer* layer in self.cardView.layer.sublayers) {
        
        [layer addAnimation:rotation forKey:@"spinningCard"];
    }
    
    [cardLayer addAnimation:animContents forKey:@"changeContents"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopRotation:(UIButton *)sender {
    
    CFTimeInterval pausedTime = [self.cardView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.cardView.layer.speed = 0.0;
    self.cardView.layer.timeOffset = pausedTime;
    
    [sender removeTarget:self action:_cmd forControlEvents:UIControlEventTouchUpInside];
    [sender setTitle:@"Start rotation" forState:UIControlStateNormal];
    
    [sender addTarget:self action:@selector(startRotation:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)startRotation:(UIButton *)sender {
    
    CFTimeInterval pausedTime = (self.cardView.layer).timeOffset;
    self.cardView.layer.speed = 1.0;
    self.cardView.layer.timeOffset = 0.0;
    self.cardView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.cardView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.cardView.layer.beginTime = timeSincePause;
    
    [sender removeTarget:self action:_cmd forControlEvents:UIControlEventTouchUpInside];
    [sender setTitle:@"Stop rotation" forState:UIControlStateNormal];
    
    [sender addTarget:self action:@selector(stopRotation:) forControlEvents:UIControlEventTouchUpInside];
}

@end
