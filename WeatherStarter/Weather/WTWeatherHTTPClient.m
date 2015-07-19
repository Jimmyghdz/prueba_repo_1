//
//  WTWeatherHTTPClient.m
//  Weather
//
//  Created by Jaime García Hernández on 19/07/15.
//  Copyright (c) 2015 Scott Sherwood. All rights reserved.
//

#import "WTWeatherHTTPClient.h"
static NSString * const WorldWeatherOnlineApiKey = @"aef6d0c348dd0866f774e6113fb85";
static NSString * const WoeldWeatherOnlineURLString = @"http://api.worldweatheronline.com/free/v1/";

@implementation WTWeatherHTTPClient

+ (WTWeatherHTTPClient *)sharedWeatherHTTPClient{
    static WTWeatherHTTPClient *_sharedWeatherHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WoeldWeatherOnlineURLString]];
    });
    return _sharedWeatherHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSInteger)number{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    parameters[@"num_of_days"]=@(number);
    parameters[@"q"] = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    parameters[@"format"]=@"json";
    parameters[@"key"] = WorldWeatherOnlineApiKey;
    
    [self GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];//llama a una dirección particular para ver el clima en linea
}
@end
