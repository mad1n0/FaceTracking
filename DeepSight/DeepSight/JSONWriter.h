//
//  CSModelWriter.h
//  CrowdSensing-iOS
//
//  Created by Minos Katevas on 13/07/2015.
//  Copyright (c) 2015 Kleomenis Katevas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONWriter : NSObject

@property (nonatomic, readonly) NSString* sensorType;

- (instancetype)initWithSensorType:(NSString*)sensorType
                              withHeader:(NSString *)header
                            withFilename:(NSString *)filename
                                  inPath:(NSURL *)path;

- (void)readData:(NSString *)sensorData;

-(void)writeString:(NSString *)string;

- (void)close;

@end
