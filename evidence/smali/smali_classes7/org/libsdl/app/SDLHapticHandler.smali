.class Lorg/libsdl/app/SDLHapticHandler;
.super Ljava/lang/Object;
.source "SDLControllerManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    }
.end annotation


# instance fields
.field private mHaptics:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 443
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 444
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    .line 445
    return-void
.end method


# virtual methods
.method protected getHaptic(I)Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    .locals 2
    .param p1, "device_id"    # I

    .line 535
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 536
    iget-object v1, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    iget v1, v1, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    if-ne v1, p1, :cond_0

    .line 537
    iget-object v1, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    return-object v1

    .line 535
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 540
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method public pollHapticDevices()V
    .locals 10

    .line 463
    const v0, 0xf423f

    .line 464
    .local v0, "deviceId_VIBRATOR_SERVICE":I
    const/4 v1, 0x0

    .line 466
    .local v1, "hasVibratorService":Z
    invoke-static {}, Landroid/view/InputDevice;->getDeviceIds()[I

    move-result-object v2

    .line 472
    .local v2, "deviceIds":[I
    array-length v3, v2

    add-int/lit8 v3, v3, -0x1

    .local v3, "i":I
    :goto_0
    const/4 v4, -0x1

    if-le v3, v4, :cond_1

    .line 473
    aget v4, v2, v3

    invoke-virtual {p0, v4}, Lorg/libsdl/app/SDLHapticHandler;->getHaptic(I)Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    move-result-object v4

    .line 474
    .local v4, "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    if-nez v4, :cond_0

    .line 475
    aget v5, v2, v3

    invoke-static {v5}, Landroid/view/InputDevice;->getDevice(I)Landroid/view/InputDevice;

    move-result-object v5

    .line 476
    .local v5, "device":Landroid/view/InputDevice;
    invoke-virtual {v5}, Landroid/view/InputDevice;->getVibrator()Landroid/os/Vibrator;

    move-result-object v6

    .line 477
    .local v6, "vib":Landroid/os/Vibrator;
    invoke-virtual {v6}, Landroid/os/Vibrator;->hasVibrator()Z

    move-result v7

    if-eqz v7, :cond_0

    .line 478
    new-instance v7, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    invoke-direct {v7, p0}, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;-><init>(Lorg/libsdl/app/SDLHapticHandler;)V

    move-object v4, v7

    .line 479
    aget v7, v2, v3

    iput v7, v4, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    .line 480
    invoke-virtual {v5}, Landroid/view/InputDevice;->getName()Ljava/lang/String;

    move-result-object v7

    iput-object v7, v4, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->name:Ljava/lang/String;

    .line 481
    iput-object v6, v4, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->vib:Landroid/os/Vibrator;

    .line 482
    iget-object v7, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v7, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 483
    iget v7, v4, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    iget-object v8, v4, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->name:Ljava/lang/String;

    invoke-static {v7, v8}, Lorg/libsdl/app/SDLControllerManager;->nativeAddHaptic(ILjava/lang/String;)I

    .line 472
    .end local v4    # "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    .end local v5    # "device":Landroid/view/InputDevice;
    .end local v6    # "vib":Landroid/os/Vibrator;
    :cond_0
    add-int/lit8 v3, v3, -0x1

    goto :goto_0

    .line 489
    .end local v3    # "i":I
    :cond_1
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v3

    const-string v4, "vibrator"

    invoke-virtual {v3, v4}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/os/Vibrator;

    .line 490
    .local v3, "vib":Landroid/os/Vibrator;
    const v4, 0xf423f

    if-eqz v3, :cond_2

    .line 491
    invoke-virtual {v3}, Landroid/os/Vibrator;->hasVibrator()Z

    move-result v1

    .line 493
    if-eqz v1, :cond_2

    .line 494
    invoke-virtual {p0, v4}, Lorg/libsdl/app/SDLHapticHandler;->getHaptic(I)Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    move-result-object v5

    .line 495
    .local v5, "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    if-nez v5, :cond_2

    .line 496
    new-instance v6, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    invoke-direct {v6, p0}, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;-><init>(Lorg/libsdl/app/SDLHapticHandler;)V

    move-object v5, v6

    .line 497
    iput v4, v5, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    .line 498
    const-string v6, "VIBRATOR_SERVICE"

    iput-object v6, v5, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->name:Ljava/lang/String;

    .line 499
    iput-object v3, v5, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->vib:Landroid/os/Vibrator;

    .line 500
    iget-object v6, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 501
    iget v6, v5, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    iget-object v7, v5, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->name:Ljava/lang/String;

    invoke-static {v6, v7}, Lorg/libsdl/app/SDLControllerManager;->nativeAddHaptic(ILjava/lang/String;)I

    .line 507
    .end local v5    # "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    :cond_2
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 508
    .local v5, "removedDevices":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/Integer;>;"
    const/4 v6, 0x0

    .local v6, "i":I
    :goto_1
    iget-object v7, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    move-result v7

    if-ge v6, v7, :cond_7

    .line 509
    iget-object v7, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v7, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    iget v7, v7, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    .line 511
    .local v7, "device_id":I
    const/4 v8, 0x0

    .local v8, "j":I
    :goto_2
    array-length v9, v2

    if-ge v8, v9, :cond_4

    .line 512
    aget v9, v2, v8

    if-ne v7, v9, :cond_3

    goto :goto_3

    .line 511
    :cond_3
    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 515
    :cond_4
    :goto_3
    if-ne v7, v4, :cond_5

    if-eqz v1, :cond_5

    goto :goto_4

    .line 517
    :cond_5
    array-length v9, v2

    if-ne v8, v9, :cond_6

    .line 518
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 508
    .end local v7    # "device_id":I
    .end local v8    # "j":I
    :cond_6
    :goto_4
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 522
    .end local v6    # "i":I
    :cond_7
    const/4 v4, 0x0

    .local v4, "i":I
    :goto_5
    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v6

    if-ge v4, v6, :cond_a

    .line 523
    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    .line 524
    .local v6, "device_id":I
    invoke-static {v6}, Lorg/libsdl/app/SDLControllerManager;->nativeRemoveHaptic(I)I

    .line 525
    const/4 v7, 0x0

    .local v7, "j":I
    :goto_6
    iget-object v8, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v8

    if-ge v7, v8, :cond_9

    .line 526
    iget-object v8, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    iget v8, v8, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->device_id:I

    if-ne v8, v6, :cond_8

    .line 527
    iget-object v8, p0, Lorg/libsdl/app/SDLHapticHandler;->mHaptics:Ljava/util/ArrayList;

    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 528
    goto :goto_7

    .line 525
    :cond_8
    add-int/lit8 v7, v7, 0x1

    goto :goto_6

    .line 522
    .end local v6    # "device_id":I
    .end local v7    # "j":I
    :cond_9
    :goto_7
    add-int/lit8 v4, v4, 0x1

    goto :goto_5

    .line 532
    .end local v4    # "i":I
    :cond_a
    return-void
.end method

.method public run(IFI)V
    .locals 4
    .param p1, "device_id"    # I
    .param p2, "intensity"    # F
    .param p3, "length"    # I

    .line 448
    invoke-virtual {p0, p1}, Lorg/libsdl/app/SDLHapticHandler;->getHaptic(I)Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    move-result-object v0

    .line 449
    .local v0, "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    if-eqz v0, :cond_0

    .line 450
    iget-object v1, v0, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->vib:Landroid/os/Vibrator;

    int-to-long v2, p3

    invoke-virtual {v1, v2, v3}, Landroid/os/Vibrator;->vibrate(J)V

    .line 452
    :cond_0
    return-void
.end method

.method public stop(I)V
    .locals 2
    .param p1, "device_id"    # I

    .line 455
    invoke-virtual {p0, p1}, Lorg/libsdl/app/SDLHapticHandler;->getHaptic(I)Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;

    move-result-object v0

    .line 456
    .local v0, "haptic":Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;
    if-eqz v0, :cond_0

    .line 457
    iget-object v1, v0, Lorg/libsdl/app/SDLHapticHandler$SDLHaptic;->vib:Landroid/os/Vibrator;

    invoke-virtual {v1}, Landroid/os/Vibrator;->cancel()V

    .line 459
    :cond_0
    return-void
.end method
