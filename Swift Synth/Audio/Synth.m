//
//  Synth.m
//  Swift Synth
//
//  Created by Gene Backlin on 6/12/20.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "Synth.h"
#import <UIKit/UIKit.h>

@interface Synth()

@end

@implementation Synth

static AVAudioEngine *audioEngine = nil;

static Signal _signal;
float frameTime = 0;
float deltaTime = 0;

// MARK: - Initialization

+ (instancetype)shared {
    static Synth *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Synth alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    _signal = Oscillator.sine;

    double sampleRate = 0.0;
    
    audioEngine = [[AVAudioEngine alloc] init];
    
    AVAudioMixerNode *mainMixer = [audioEngine mainMixerNode];
    AVAudioOutputNode *outputNode = [audioEngine outputNode];
    AVAudioFormat *format = [outputNode inputFormatForBus:0];
    
    sampleRate = format.sampleRate;
    deltaTime = (1 / (float)sampleRate);
        
    AVAudioFormat *inputFormat = [[AVAudioFormat alloc] initWithCommonFormat:format.commonFormat sampleRate:sampleRate channels:1 interleaved:format.isInterleaved];
    
    AVAudioSourceNode *node = self.node;
    
    [audioEngine attachNode:node];
    [audioEngine connect:node to:mainMixer format:inputFormat];
    [audioEngine connect:mainMixer to:outputNode format:nil];
    [mainMixer setOutputVolume:0];

    NSError *error = nil;
    [audioEngine startAndReturnError:&error];
    if (error!= nil) {
        NSLog(@"Could not start audioEngine: %@", error.localizedDescription);
    }

    return self;
}

// MARK: - Accessors and modifiers

- (float)volume {
    return audioEngine.mainMixerNode.outputVolume;
}
- (void)setVolume:(float)newValue {
    audioEngine.mainMixerNode.outputVolume = newValue;
}

- (void)setWaveformTo:(Signal)newValue {
    _signal = newValue;
}

- (AVAudioSourceNode *) node {
    return [[AVAudioSourceNode alloc] initWithRenderBlock:^OSStatus(BOOL * _Nonnull isSilence, const AudioTimeStamp * _Nonnull timestamp, AVAudioFrameCount frameCount, AudioBufferList * _Nonnull outputData) {
        for(int frame = 0; frame < frameCount; frame++) {
            float sampleVal = _signal(frameTime);
            frameTime += deltaTime;
            
            for(int i = 0; i < outputData->mNumberBuffers; ++i){
                Float32 *audioData = (Float32 *)outputData->mBuffers[i].mData;
                audioData[frame] = sampleVal;
            }
        }
        return noErr;
    }];
}

@end
