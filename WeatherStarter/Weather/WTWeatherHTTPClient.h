//
//  WTWeatherHTTPClient.h
//  Weather
//
//  Created by Jaime García Hernández on 19/07/15.
//  Copyright (c) 2015 Scott Sherwood. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol WeatherHTTPClientDelegate;
@interface WTWeatherHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;

+ (WTWeatherHTTPClient *) sharedWeatherHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSInteger)number;
@end

@protocol WeatherHTTPClientDelegate <NSObject>

@optional
- (void)weatherHTTPClient:(WTWeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
- (void)weatherHTTPClient:(WTWeatherHTTPClient *)client didFailWithError:(NSError *)error;

@end
