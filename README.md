# PastLook
识别图片中的文字
1. 引入api文件授权
```
// 授权方法2（更安全）： 下载授权文件，添加至资源
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [WHToast showMessage:@"初始化失败,请稍后重试" duration:1.0f finishHandler:^{
        }];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
```

2. //识别图片
            [[AipOcrService shardService] detectWebImageFromImage:self.showImage
                                                      withOptions:nil
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];
![photo](https://github.com/dt8888/PastLook/blob/master/photo.png)
