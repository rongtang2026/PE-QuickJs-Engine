.class public Lorg/libsdl/app/SDLAudioManager;
.super Ljava/lang/Object;
.source "SDLAudioManager.java"


# static fields
.field protected static final TAG:Ljava/lang/String; = "SDLAudio"

.field protected static mAudioRecord:Landroid/media/AudioRecord;

.field protected static mAudioTrack:Landroid/media/AudioTrack;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static audioClose()V
    .locals 1

    .line 351
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    if-eqz v0, :cond_0

    .line 352
    invoke-virtual {v0}, Landroid/media/AudioTrack;->stop()V

    .line 353
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v0}, Landroid/media/AudioTrack;->release()V

    .line 354
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    .line 356
    :cond_0
    return-void
.end method

.method public static audioOpen(IIII)[I
    .locals 1
    .param p0, "sampleRate"    # I
    .param p1, "audioFormat"    # I
    .param p2, "desiredChannels"    # I
    .param p3, "desiredFrames"    # I

    .line 238
    const/4 v0, 0x0

    invoke-static {v0, p0, p1, p2, p3}, Lorg/libsdl/app/SDLAudioManager;->open(ZIIII)[I

    move-result-object v0

    return-object v0
.end method

.method public static audioSetThreadPriority(ZI)V
    .locals 3
    .param p0, "iscapture"    # Z
    .param p1, "device_id"    # I

    .line 372
    if-eqz p0, :cond_0

    .line 373
    :try_start_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "SDLAudioC"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setName(Ljava/lang/String;)V

    goto :goto_0

    .line 375
    :cond_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "SDLAudioP"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setName(Ljava/lang/String;)V

    .line 379
    :goto_0
    const/16 v0, -0x10

    invoke-static {v0}, Landroid/os/Process;->setThreadPriority(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 383
    goto :goto_1

    .line 381
    :catch_0
    move-exception v0

    .line 382
    .local v0, "e":Ljava/lang/Exception;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "modify thread properties failed "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "SDLAudio"

    invoke-static {v2, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 384
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_1
    return-void
.end method

.method public static audioWriteByteBuffer([B)V
    .locals 5
    .param p0, "buffer"    # [B

    .line 297
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    const-string v1, "SDLAudio"

    if-nez v0, :cond_0

    .line 298
    const-string v0, "Attempted to make audio call with uninitialized audio!"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 299
    return-void

    .line 302
    :cond_0
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v2, p0

    if-ge v0, v2, :cond_3

    .line 303
    sget-object v2, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    array-length v3, p0

    sub-int/2addr v3, v0

    invoke-virtual {v2, p0, v0, v3}, Landroid/media/AudioTrack;->write([BII)I

    move-result v2

    .line 304
    .local v2, "result":I
    if-lez v2, :cond_1

    .line 305
    add-int/2addr v0, v2

    goto :goto_2

    .line 306
    :cond_1
    if-nez v2, :cond_2

    .line 308
    const-wide/16 v3, 0x1

    :try_start_0
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 311
    :goto_1
    goto :goto_2

    .line 309
    :catch_0
    move-exception v3

    goto :goto_1

    .line 316
    .end local v2    # "result":I
    :goto_2
    goto :goto_0

    .line 313
    .restart local v2    # "result":I
    :cond_2
    const-string v3, "SDL audio: error return from write(byte)"

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 314
    return-void

    .line 317
    .end local v0    # "i":I
    .end local v2    # "result":I
    :cond_3
    return-void
.end method

.method public static audioWriteFloatBuffer([F)V
    .locals 5
    .param p0, "buffer"    # [F

    .line 245
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    const-string v1, "SDLAudio"

    if-nez v0, :cond_0

    .line 246
    const-string v0, "Attempted to make audio call with uninitialized audio!"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 247
    return-void

    .line 250
    :cond_0
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v2, p0

    if-ge v0, v2, :cond_3

    .line 251
    sget-object v2, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    array-length v3, p0

    sub-int/2addr v3, v0

    const/4 v4, 0x0

    invoke-virtual {v2, p0, v0, v3, v4}, Landroid/media/AudioTrack;->write([FIII)I

    move-result v2

    .line 252
    .local v2, "result":I
    if-lez v2, :cond_1

    .line 253
    add-int/2addr v0, v2

    goto :goto_2

    .line 254
    :cond_1
    if-nez v2, :cond_2

    .line 256
    const-wide/16 v3, 0x1

    :try_start_0
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 259
    :goto_1
    goto :goto_2

    .line 257
    :catch_0
    move-exception v3

    goto :goto_1

    .line 264
    .end local v2    # "result":I
    :goto_2
    goto :goto_0

    .line 261
    .restart local v2    # "result":I
    :cond_2
    const-string v3, "SDL audio: error return from write(float)"

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 262
    return-void

    .line 265
    .end local v0    # "i":I
    .end local v2    # "result":I
    :cond_3
    return-void
.end method

.method public static audioWriteShortBuffer([S)V
    .locals 5
    .param p0, "buffer"    # [S

    .line 271
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    const-string v1, "SDLAudio"

    if-nez v0, :cond_0

    .line 272
    const-string v0, "Attempted to make audio call with uninitialized audio!"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 273
    return-void

    .line 276
    :cond_0
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    array-length v2, p0

    if-ge v0, v2, :cond_3

    .line 277
    sget-object v2, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    array-length v3, p0

    sub-int/2addr v3, v0

    invoke-virtual {v2, p0, v0, v3}, Landroid/media/AudioTrack;->write([SII)I

    move-result v2

    .line 278
    .local v2, "result":I
    if-lez v2, :cond_1

    .line 279
    add-int/2addr v0, v2

    goto :goto_2

    .line 280
    :cond_1
    if-nez v2, :cond_2

    .line 282
    const-wide/16 v3, 0x1

    :try_start_0
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 285
    :goto_1
    goto :goto_2

    .line 283
    :catch_0
    move-exception v3

    goto :goto_1

    .line 290
    .end local v2    # "result":I
    :goto_2
    goto :goto_0

    .line 287
    .restart local v2    # "result":I
    :cond_2
    const-string v3, "SDL audio: error return from write(short)"

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 288
    return-void

    .line 291
    .end local v0    # "i":I
    .end local v2    # "result":I
    :cond_3
    return-void
.end method

.method public static captureClose()V
    .locals 1

    .line 360
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    if-eqz v0, :cond_0

    .line 361
    invoke-virtual {v0}, Landroid/media/AudioRecord;->stop()V

    .line 362
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->release()V

    .line 363
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    .line 365
    :cond_0
    return-void
.end method

.method public static captureOpen(IIII)[I
    .locals 1
    .param p0, "sampleRate"    # I
    .param p1, "audioFormat"    # I
    .param p2, "desiredChannels"    # I
    .param p3, "desiredFrames"    # I

    .line 323
    const/4 v0, 0x1

    invoke-static {v0, p0, p1, p2, p3}, Lorg/libsdl/app/SDLAudioManager;->open(ZIIII)[I

    move-result-object v0

    return-object v0
.end method

.method public static captureReadByteBuffer([BZ)I
    .locals 4
    .param p0, "buffer"    # [B
    .param p1, "blocking"    # Z

    .line 342
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x17

    if-ge v0, v2, :cond_0

    .line 343
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    array-length v2, p0

    invoke-virtual {v0, p0, v1, v2}, Landroid/media/AudioRecord;->read([BII)I

    move-result v0

    return v0

    .line 345
    :cond_0
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    array-length v2, p0

    xor-int/lit8 v3, p1, 0x1

    invoke-virtual {v0, p0, v1, v2, v3}, Landroid/media/AudioRecord;->read([BIII)I

    move-result v0

    return v0
.end method

.method public static captureReadFloatBuffer([FZ)I
    .locals 4
    .param p0, "buffer"    # [F
    .param p1, "blocking"    # Z

    .line 328
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    array-length v1, p0

    xor-int/lit8 v2, p1, 0x1

    const/4 v3, 0x0

    invoke-virtual {v0, p0, v3, v1, v2}, Landroid/media/AudioRecord;->read([FIII)I

    move-result v0

    return v0
.end method

.method public static captureReadShortBuffer([SZ)I
    .locals 4
    .param p0, "buffer"    # [S
    .param p1, "blocking"    # Z

    .line 333
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x17

    if-ge v0, v2, :cond_0

    .line 334
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    array-length v2, p0

    invoke-virtual {v0, p0, v1, v2}, Landroid/media/AudioRecord;->read([SII)I

    move-result v0

    return v0

    .line 336
    :cond_0
    sget-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    array-length v2, p0

    xor-int/lit8 v3, p1, 0x1

    invoke-virtual {v0, p0, v1, v2, v3}, Landroid/media/AudioRecord;->read([SIII)I

    move-result v0

    return v0
.end method

.method protected static getAudioFormatString(I)Ljava/lang/String;
    .locals 1
    .param p0, "audioFormat"    # I

    .line 22
    packed-switch p0, :pswitch_data_0

    .line 30
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 28
    :pswitch_0
    const-string v0, "float"

    return-object v0

    .line 24
    :pswitch_1
    const-string v0, "8-bit"

    return-object v0

    .line 26
    :pswitch_2
    const-string v0, "16-bit"

    return-object v0

    nop

    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static initialize()V
    .locals 1

    .line 15
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    .line 16
    sput-object v0, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    .line 17
    return-void
.end method

.method public static native nativeSetupJNI()I
.end method

.method protected static open(ZIIII)[I
    .locals 28
    .param p0, "isCapture"    # Z
    .param p1, "sampleRate"    # I
    .param p2, "audioFormat"    # I
    .param p3, "desiredChannels"    # I
    .param p4, "desiredFrames"    # I

    .line 39
    move/from16 v0, p1

    move/from16 v1, p3

    move/from16 v2, p4

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Opening "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "capture"

    const-string v6, "playback"

    if-eqz p0, :cond_0

    move-object v7, v5

    goto :goto_0

    :cond_0
    move-object v7, v6

    :goto_0
    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v7, ", requested "

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v7, " frames of "

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v8, " channel "

    invoke-virtual {v3, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static/range {p2 .. p2}, Lorg/libsdl/app/SDLAudioManager;->getAudioFormatString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v3, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v9, " audio at "

    invoke-virtual {v3, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v10, " Hz"

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v11, "SDLAudio"

    invoke-static {v11, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 42
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v12, 0x15

    const/4 v13, 0x2

    if-ge v3, v12, :cond_3

    .line 43
    if-le v1, v13, :cond_1

    .line 44
    const/4 v1, 0x2

    .line 46
    .end local p3    # "desiredChannels":I
    .local v1, "desiredChannels":I
    :cond_1
    const/16 v3, 0x1f40

    if-ge v0, v3, :cond_2

    .line 47
    const/16 v0, 0x1f40

    .end local p1    # "sampleRate":I
    .local v0, "sampleRate":I
    goto :goto_1

    .line 48
    .end local v0    # "sampleRate":I
    .restart local p1    # "sampleRate":I
    :cond_2
    const v3, 0xbb80

    if-le v0, v3, :cond_3

    .line 49
    const v0, 0xbb80

    .line 53
    .end local p1    # "sampleRate":I
    .restart local v0    # "sampleRate":I
    :cond_3
    :goto_1
    const/16 v3, 0x17

    const/4 v14, 0x4

    move/from16 v15, p2

    if-ne v15, v14, :cond_5

    .line 54
    if-eqz p0, :cond_4

    const/16 v12, 0x17

    .line 55
    .local v12, "minSDKVersion":I
    :cond_4
    sget v13, Landroid/os/Build$VERSION;->SDK_INT:I

    if-ge v13, v12, :cond_5

    .line 56
    const/4 v13, 0x2

    .end local p2    # "audioFormat":I
    .local v13, "audioFormat":I
    goto :goto_2

    .line 59
    .end local v12    # "minSDKVersion":I
    .end local v13    # "audioFormat":I
    .restart local p2    # "audioFormat":I
    :cond_5
    move v13, v15

    .end local p2    # "audioFormat":I
    .restart local v13    # "audioFormat":I
    :goto_2
    packed-switch v13, :pswitch_data_0

    .line 71
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "Requested format "

    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v12

    const-string v15, ", getting ENCODING_PCM_16BIT"

    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-static {v11, v12}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 72
    const/4 v13, 0x2

    .line 73
    const/4 v12, 0x2

    .local v12, "sampleSize":I
    goto :goto_3

    .line 68
    .end local v12    # "sampleSize":I
    :pswitch_0
    const/4 v12, 0x4

    .line 69
    .restart local v12    # "sampleSize":I
    goto :goto_3

    .line 62
    .end local v12    # "sampleSize":I
    :pswitch_1
    const/4 v12, 0x1

    .line 63
    .restart local v12    # "sampleSize":I
    goto :goto_3

    .line 65
    .end local v12    # "sampleSize":I
    :pswitch_2
    const/4 v12, 0x2

    .line 66
    .restart local v12    # "sampleSize":I
    nop

    .line 77
    :goto_3
    const-string v15, " channels, getting stereo"

    const-string v14, "Requested "

    if-eqz p0, :cond_6

    .line 78
    packed-switch v1, :pswitch_data_1

    .line 86
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v11, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 87
    const/4 v1, 0x2

    .line 88
    const/16 v3, 0xc

    .line 89
    .local v3, "channelConfig":I
    goto :goto_4

    .line 83
    .end local v3    # "channelConfig":I
    :pswitch_3
    const/16 v3, 0xc

    .line 84
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 80
    .end local v3    # "channelConfig":I
    :pswitch_4
    const/16 v3, 0x10

    .line 81
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 92
    .end local v3    # "channelConfig":I
    :cond_6
    packed-switch v1, :pswitch_data_2

    .line 124
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v11, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 125
    const/4 v1, 0x2

    .line 126
    const/16 v3, 0xc

    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 115
    .end local v3    # "channelConfig":I
    :pswitch_5
    sget v15, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v15, v3, :cond_7

    .line 116
    const/16 v3, 0x18fc

    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 118
    .end local v3    # "channelConfig":I
    :cond_7
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v14, " channels, getting 5.1 surround"

    invoke-virtual {v3, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v11, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 119
    const/4 v1, 0x6

    .line 120
    const/16 v3, 0xfc

    .line 122
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 112
    .end local v3    # "channelConfig":I
    :pswitch_6
    const/16 v3, 0x4fc

    .line 113
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 109
    .end local v3    # "channelConfig":I
    :pswitch_7
    const/16 v3, 0xfc

    .line 110
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 106
    .end local v3    # "channelConfig":I
    :pswitch_8
    const/16 v3, 0xdc

    .line 107
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 103
    .end local v3    # "channelConfig":I
    :pswitch_9
    const/16 v3, 0xcc

    .line 104
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 100
    .end local v3    # "channelConfig":I
    :pswitch_a
    const/16 v3, 0x1c

    .line 101
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 97
    .end local v3    # "channelConfig":I
    :pswitch_b
    const/16 v3, 0xc

    .line 98
    .restart local v3    # "channelConfig":I
    goto :goto_4

    .line 94
    .end local v3    # "channelConfig":I
    :pswitch_c
    const/4 v3, 0x4

    .line 95
    .restart local v3    # "channelConfig":I
    nop

    .line 168
    :goto_4
    mul-int v21, v12, v1

    .line 174
    .local v21, "frameSize":I
    if-eqz p0, :cond_8

    .line 175
    invoke-static {v0, v3, v13}, Landroid/media/AudioRecord;->getMinBufferSize(III)I

    move-result v14

    move/from16 v22, v14

    .local v14, "minBufferSize":I
    goto :goto_5

    .line 177
    .end local v14    # "minBufferSize":I
    :cond_8
    invoke-static {v0, v3, v13}, Landroid/media/AudioTrack;->getMinBufferSize(III)I

    move-result v14

    move/from16 v22, v14

    .line 179
    .local v22, "minBufferSize":I
    :goto_5
    add-int v14, v22, v21

    const/4 v15, 0x1

    sub-int/2addr v14, v15

    div-int v14, v14, v21

    invoke-static {v2, v14}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 181
    .end local p4    # "desiredFrames":I
    .local v2, "desiredFrames":I
    const/4 v14, 0x4

    new-array v14, v14, [I

    .line 183
    .local v14, "results":[I
    const/16 v23, 0x3

    const/16 v24, 0x0

    const/16 v25, 0x0

    if-eqz p0, :cond_b

    .line 184
    sget-object v16, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    if-nez v16, :cond_a

    .line 185
    new-instance v20, Landroid/media/AudioRecord;

    const/16 v16, 0x0

    mul-int v19, v2, v21

    move-object/from16 v26, v14

    .end local v14    # "results":[I
    .local v26, "results":[I
    move-object/from16 v14, v20

    move/from16 p1, v1

    const/4 v1, 0x1

    .end local v1    # "desiredChannels":I
    .local p1, "desiredChannels":I
    move/from16 v15, v16

    move/from16 v16, v0

    move/from16 v17, v3

    move/from16 v18, v13

    invoke-direct/range {v14 .. v19}, Landroid/media/AudioRecord;-><init>(IIIII)V

    sput-object v20, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    .line 189
    invoke-virtual/range {v20 .. v20}, Landroid/media/AudioRecord;->getState()I

    move-result v14

    if-eq v14, v1, :cond_9

    .line 190
    const-string v1, "Failed during initialization of AudioRecord"

    invoke-static {v11, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 191
    sget-object v1, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v1}, Landroid/media/AudioRecord;->release()V

    .line 192
    sput-object v25, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    .line 193
    return-object v25

    .line 196
    :cond_9
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v14}, Landroid/media/AudioRecord;->startRecording()V

    goto :goto_6

    .line 184
    .end local v26    # "results":[I
    .end local p1    # "desiredChannels":I
    .restart local v1    # "desiredChannels":I
    .restart local v14    # "results":[I
    :cond_a
    move/from16 p1, v1

    move-object/from16 v26, v14

    const/4 v1, 0x1

    .line 199
    .end local v1    # "desiredChannels":I
    .end local v14    # "results":[I
    .restart local v26    # "results":[I
    .restart local p1    # "desiredChannels":I
    :goto_6
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v14}, Landroid/media/AudioRecord;->getSampleRate()I

    move-result v14

    aput v14, v26, v24

    .line 200
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v14}, Landroid/media/AudioRecord;->getAudioFormat()I

    move-result v14

    aput v14, v26, v1

    .line 201
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v14}, Landroid/media/AudioRecord;->getChannelCount()I

    move-result v14

    const/4 v15, 0x2

    aput v14, v26, v15

    .line 202
    aput v2, v26, v23

    goto :goto_7

    .line 205
    .end local v26    # "results":[I
    .end local p1    # "desiredChannels":I
    .restart local v1    # "desiredChannels":I
    .restart local v14    # "results":[I
    :cond_b
    move/from16 p1, v1

    move-object/from16 v26, v14

    const/4 v1, 0x1

    .end local v1    # "desiredChannels":I
    .end local v14    # "results":[I
    .restart local v26    # "results":[I
    .restart local p1    # "desiredChannels":I
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    if-nez v14, :cond_d

    .line 206
    new-instance v27, Landroid/media/AudioTrack;

    const/4 v15, 0x3

    mul-int v19, v2, v21

    const/16 v20, 0x1

    move-object/from16 v14, v27

    move/from16 v16, v0

    move/from16 v17, v3

    move/from16 v18, v13

    invoke-direct/range {v14 .. v20}, Landroid/media/AudioTrack;-><init>(IIIIII)V

    sput-object v27, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    .line 211
    invoke-virtual/range {v27 .. v27}, Landroid/media/AudioTrack;->getState()I

    move-result v14

    if-eq v14, v1, :cond_c

    .line 214
    const-string v1, "Failed during initialization of Audio Track"

    invoke-static {v11, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 215
    sget-object v1, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v1}, Landroid/media/AudioTrack;->release()V

    .line 216
    sput-object v25, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    .line 217
    return-object v25

    .line 220
    :cond_c
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v14}, Landroid/media/AudioTrack;->play()V

    .line 223
    :cond_d
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v14}, Landroid/media/AudioTrack;->getSampleRate()I

    move-result v14

    aput v14, v26, v24

    .line 224
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v14}, Landroid/media/AudioTrack;->getAudioFormat()I

    move-result v14

    aput v14, v26, v1

    .line 225
    sget-object v14, Lorg/libsdl/app/SDLAudioManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v14}, Landroid/media/AudioTrack;->getChannelCount()I

    move-result v14

    const/4 v15, 0x2

    aput v14, v26, v15

    .line 226
    aput v2, v26, v23

    .line 229
    :goto_7
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v14, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-eqz p0, :cond_e

    goto :goto_8

    :cond_e
    move-object v5, v6

    :goto_8
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ", got "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    aget v5, v26, v23

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/4 v5, 0x2

    aget v5, v26, v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    aget v1, v26, v1

    invoke-static {v1}, Lorg/libsdl/app/SDLAudioManager;->getAudioFormatString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    aget v4, v26, v24

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v11, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 231
    return-object v26

    nop

    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x1
        :pswitch_4
        :pswitch_3
    .end packed-switch

    :pswitch_data_2
    .packed-switch 0x1
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
    .end packed-switch
.end method
