//
//  Mp3Recorder.m
//  BloodSugar
//
//  v0.8.5 Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "RCIMRecoarder.h"
#import <AVFoundation/AVFoundation.h>

@interface RCIMRecoarder()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, assign) CGFloat recoardTime;
@end

@implementation RCIMRecoarder


#pragma mark - Init Methods

- (id)initWithDelegate:(id<RCIMRecoarderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)setRecorder
{
    _recorder = nil;
    NSError *recorderSetupError = nil;
    NSURL *url = [NSURL fileURLWithPath:[self cafPath]];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    [settings setValue:@(16) forKey:AVLinearPCMBitDepthKey];
    [settings setValue:@(NO) forKey:AVLinearPCMIsNonInterleaved];
    [settings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    [settings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                            settings:settings
                                               error:&recorderSetupError];
    if (recorderSetupError) {
        //NSLog(@"%@",recorderSetupError);
    }
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    
    
//    NSDictionary * settings1 = @{AVFormatIDKey:@(kAudioFormatLinearPCM),AVSampleRateKey: @8000.00f,AVNumberOfChannelsKey: @1,AVLinearPCMBitDepthKey: @16,AVLinearPCMIsNonInterleaved: @NO,AVLinearPCMIsFloatKey: @NO,AVLinearPC:'MIsBigEndianKey: @NO};
}

- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(_session == nil) {
        //NSLog(@"Error creating session: %@", [sessionError description]);
    } else {
        [_session setActive:YES error:nil];
    }
}

- (void)startRecord
{
    [self setSesstion];
    [self setRecorder];
    self.recoardTime = 0;
    [_recorder record];
}


- (void)stopRecord
{
    double cTime = _recorder.currentTime;
    self.recoardTime = cTime;
    [_recorder stop];
    
    if (cTime > 1) {
        [self audio_PCMtoMP3];
    } else {
        
        [_recorder deleteRecording];
        
        if ([_delegate respondsToSelector:@selector(failRecord)]) {
            [_delegate failRecord];
        }
    }
}

- (void)cancelRecord
{
    [_recorder stop];
    [_recorder deleteRecording];
}

- (void)deleteMp3Cache
{
    [self deleteFileWithPath:[self mp3Path]];
}

- (void)deleteCafCache
{
    [self deleteFileWithPath:[self cafPath]];
}

- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        //NSLog(@"删除以前的mp3文件");
    }
}

#pragma mark - Convert Utils
- (void)audio_PCMtoMP3
{
//    NSString *cafFilePath = [self cafPath];
//    NSString *mp3FilePath = [[self mp3Path] stringByAppendingPathComponent:[self randomMP3FileName]];
//
//    ////NSLog(@"MP3转换开始");
//    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)]) {
//        [_delegate beginConvert];
//    }
//    @try {
//        int read, write;
//        
//        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
//        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
//        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
//        
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 11025.0);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//        
//        do {
//            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//            if (read == 0)
//                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//            else
//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//            
//            fwrite(mp3_buffer, write, 1, mp3);
//            
//        } while (read != 0);
//        
//        lame_close(lame);
//        fclose(mp3);
//        fclose(pcm);
//    }
//    @catch (NSException *exception) {
//        //NSLog(@"%@",[exception description]);
//        mp3FilePath = nil;
//    }
//    @finally {
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
//        //NSLog(@"MP3转换结束");
//        if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithMP3FileName:)]) {
//            [_delegate endConvertWithMP3FileName:mp3FilePath];
//        }
//        [self deleteCafCache];
//    }
    //pcm -> amr
    NSData * data= [NSData dataWithContentsOfFile:[self cafPath]];
    NSData * audioData = data;//[[RCAMRDataConverter sharedAMRDataConverter]encodeWAVEToAMR:data channel:1 nBitsPerSample:16];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
            //NSLog(@"MP3转换结束");
            if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithData:withTimeInterval:)]) {
                [_delegate endConvertWithData:audioData withTimeInterval:self.recoardTime];
            }
            [self deleteCafCache];
}

#pragma mark - Path Utils
- (NSString *)cafPath {
    NSString *cafPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.wav"];
    return cafPath;
}

- (NSString *)mp3Path {
    NSString *mp3Path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.LeanCloud.RCIMChat.audioCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mp3Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mp3Path;
}

- (NSString *)randomMP3FileName {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"record_%.0f.mp3",timeInterval];
    return fileName;
}

@end
