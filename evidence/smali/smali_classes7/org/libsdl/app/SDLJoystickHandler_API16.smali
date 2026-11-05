.class Lorg/libsdl/app/SDLJoystickHandler_API16;
.super Lorg/libsdl/app/SDLJoystickHandler;
.source "SDLControllerManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;,
        Lorg/libsdl/app/SDLJoystickHandler_API16$RangeComparator;
    }
.end annotation


# instance fields
.field private mJoysticks:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 172
    invoke-direct {p0}, Lorg/libsdl/app/SDLJoystickHandler;-><init>()V

    .line 174
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    .line 175
    return-void
.end method


# virtual methods
.method public getButtonMask(Landroid/view/InputDevice;)I
    .locals 1
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 291
    const/4 v0, -0x1

    return v0
.end method

.method protected getJoystick(I)Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;
    .locals 2
    .param p1, "device_id"    # I

    .line 238
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    iget-object v1, p0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 239
    iget-object v1, p0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    iget v1, v1, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    if-ne v1, p1, :cond_0

    .line 240
    iget-object v1, p0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    return-object v1

    .line 238
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 243
    .end local v0    # "i":I
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method public getJoystickDescriptor(Landroid/view/InputDevice;)Ljava/lang/String;
    .locals 2
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 276
    invoke-virtual {p1}, Landroid/view/InputDevice;->getDescriptor()Ljava/lang/String;

    move-result-object v0

    .line 278
    .local v0, "desc":Ljava/lang/String;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    .line 279
    return-object v0

    .line 282
    :cond_0
    invoke-virtual {p1}, Landroid/view/InputDevice;->getName()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method public getProductId(Landroid/view/InputDevice;)I
    .locals 1
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 285
    const/4 v0, 0x0

    return v0
.end method

.method public getVendorId(Landroid/view/InputDevice;)I
    .locals 1
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 288
    const/4 v0, 0x0

    return v0
.end method

.method public handleMotionEvent(Landroid/view/MotionEvent;)Z
    .locals 8
    .param p1, "event"    # Landroid/view/MotionEvent;

    .line 248
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getSource()I

    move-result v0

    const v1, 0x1000010

    and-int/2addr v0, v1

    if-eqz v0, :cond_1

    .line 249
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v0

    .line 250
    .local v0, "actionPointerIndex":I
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    .line 251
    .local v1, "action":I
    packed-switch v1, :pswitch_data_0

    goto/16 :goto_2

    .line 253
    :pswitch_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getDeviceId()I

    move-result v2

    invoke-virtual {p0, v2}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getJoystick(I)Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    move-result-object v2

    .line 254
    .local v2, "joystick":Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;
    if-eqz v2, :cond_1

    .line 255
    const/4 v3, 0x0

    .local v3, "i":I
    :goto_0
    iget-object v4, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->axes:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_0

    .line 256
    iget-object v4, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->axes:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/InputDevice$MotionRange;

    .line 258
    .local v4, "range":Landroid/view/InputDevice$MotionRange;
    invoke-virtual {v4}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v5

    invoke-virtual {p1, v5, v0}, Landroid/view/MotionEvent;->getAxisValue(II)F

    move-result v5

    invoke-virtual {v4}, Landroid/view/InputDevice$MotionRange;->getMin()F

    move-result v6

    sub-float/2addr v5, v6

    invoke-virtual {v4}, Landroid/view/InputDevice$MotionRange;->getRange()F

    move-result v6

    div-float/2addr v5, v6

    const/high16 v6, 0x40000000    # 2.0f

    mul-float v5, v5, v6

    const/high16 v6, 0x3f800000    # 1.0f

    sub-float/2addr v5, v6

    .line 259
    .local v5, "value":F
    iget v6, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    invoke-static {v6, v3, v5}, Lorg/libsdl/app/SDLControllerManager;->onNativeJoy(IIF)V

    .line 255
    .end local v4    # "range":Landroid/view/InputDevice$MotionRange;
    .end local v5    # "value":F
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 261
    .end local v3    # "i":I
    :cond_0
    const/4 v3, 0x0

    .restart local v3    # "i":I
    :goto_1
    iget-object v4, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_1

    .line 262
    iget-object v4, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/InputDevice$MotionRange;

    invoke-virtual {v4}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v4

    invoke-virtual {p1, v4, v0}, Landroid/view/MotionEvent;->getAxisValue(II)F

    move-result v4

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v4

    .line 263
    .local v4, "hatX":I
    iget-object v5, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    add-int/lit8 v6, v3, 0x1

    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/view/InputDevice$MotionRange;

    invoke-virtual {v5}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v5

    invoke-virtual {p1, v5, v0}, Landroid/view/MotionEvent;->getAxisValue(II)F

    move-result v5

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v5

    .line 264
    .local v5, "hatY":I
    iget v6, v2, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    div-int/lit8 v7, v3, 0x2

    invoke-static {v6, v7, v4, v5}, Lorg/libsdl/app/SDLControllerManager;->onNativeHat(IIII)V

    .line 261
    .end local v4    # "hatX":I
    .end local v5    # "hatY":I
    add-int/lit8 v3, v3, 0x2

    goto :goto_1

    .line 272
    .end local v0    # "actionPointerIndex":I
    .end local v1    # "action":I
    .end local v2    # "joystick":Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;
    .end local v3    # "i":I
    :cond_1
    :goto_2
    const/4 v0, 0x1

    return v0

    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_0
    .end packed-switch
.end method

.method public pollInputDevices()V
    .locals 17

    .line 179
    move-object/from16 v0, p0

    invoke-static {}, Landroid/view/InputDevice;->getDeviceIds()[I

    move-result-object v1

    .line 180
    .local v1, "deviceIds":[I
    const/4 v2, 0x0

    .local v2, "i":I
    :goto_0
    array-length v3, v1

    if-ge v2, v3, :cond_5

    .line 181
    aget v3, v1, v2

    invoke-virtual {v0, v3}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getJoystick(I)Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    move-result-object v3

    .line 182
    .local v3, "joystick":Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;
    if-nez v3, :cond_4

    .line 183
    new-instance v4, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    invoke-direct {v4}, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;-><init>()V

    move-object v3, v4

    .line 184
    aget v4, v1, v2

    invoke-static {v4}, Landroid/view/InputDevice;->getDevice(I)Landroid/view/InputDevice;

    move-result-object v4

    .line 185
    .local v4, "joystickDevice":Landroid/view/InputDevice;
    aget v5, v1, v2

    invoke-static {v5}, Lorg/libsdl/app/SDLControllerManager;->isDeviceSDLJoystick(I)Z

    move-result v5

    if-eqz v5, :cond_4

    .line 186
    aget v5, v1, v2

    iput v5, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    .line 187
    invoke-virtual {v4}, Landroid/view/InputDevice;->getName()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->name:Ljava/lang/String;

    .line 188
    invoke-virtual {v0, v4}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getJoystickDescriptor(Landroid/view/InputDevice;)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->desc:Ljava/lang/String;

    .line 189
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    iput-object v5, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->axes:Ljava/util/ArrayList;

    .line 190
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    iput-object v5, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    .line 192
    invoke-virtual {v4}, Landroid/view/InputDevice;->getMotionRanges()Ljava/util/List;

    move-result-object v5

    .line 193
    .local v5, "ranges":Ljava/util/List;, "Ljava/util/List<Landroid/view/InputDevice$MotionRange;>;"
    new-instance v6, Lorg/libsdl/app/SDLJoystickHandler_API16$RangeComparator;

    invoke-direct {v6}, Lorg/libsdl/app/SDLJoystickHandler_API16$RangeComparator;-><init>()V

    invoke-static {v5, v6}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 194
    invoke-interface {v5}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_1
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_3

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/view/InputDevice$MotionRange;

    .line 195
    .local v7, "range":Landroid/view/InputDevice$MotionRange;
    invoke-virtual {v7}, Landroid/view/InputDevice$MotionRange;->getSource()I

    move-result v8

    const/16 v9, 0x10

    and-int/2addr v8, v9

    if-eqz v8, :cond_2

    .line 196
    invoke-virtual {v7}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v8

    const/16 v10, 0xf

    if-eq v8, v10, :cond_1

    .line 197
    invoke-virtual {v7}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v8

    if-ne v8, v9, :cond_0

    goto :goto_2

    .line 201
    :cond_0
    iget-object v8, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->axes:Ljava/util/ArrayList;

    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_3

    .line 198
    :cond_1
    :goto_2
    iget-object v8, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 204
    .end local v7    # "range":Landroid/view/InputDevice$MotionRange;
    :cond_2
    :goto_3
    goto :goto_1

    .line 206
    :cond_3
    iget-object v6, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v6, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 207
    iget v7, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    iget-object v8, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->name:Ljava/lang/String;

    iget-object v9, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->desc:Ljava/lang/String;

    invoke-virtual {v0, v4}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getVendorId(Landroid/view/InputDevice;)I

    move-result v10

    invoke-virtual {v0, v4}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getProductId(Landroid/view/InputDevice;)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v0, v4}, Lorg/libsdl/app/SDLJoystickHandler_API16;->getButtonMask(Landroid/view/InputDevice;)I

    move-result v13

    iget-object v6, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->axes:Ljava/util/ArrayList;

    invoke-virtual {v6}, Ljava/util/ArrayList;->size()I

    move-result v14

    iget-object v6, v3, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->hats:Ljava/util/ArrayList;

    invoke-virtual {v6}, Ljava/util/ArrayList;->size()I

    move-result v6

    div-int/lit8 v15, v6, 0x2

    const/16 v16, 0x0

    invoke-static/range {v7 .. v16}, Lorg/libsdl/app/SDLControllerManager;->nativeAddJoystick(ILjava/lang/String;Ljava/lang/String;IIZIIII)I

    .line 180
    .end local v3    # "joystick":Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;
    .end local v4    # "joystickDevice":Landroid/view/InputDevice;
    .end local v5    # "ranges":Ljava/util/List;, "Ljava/util/List<Landroid/view/InputDevice$MotionRange;>;"
    :cond_4
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0

    .line 213
    .end local v2    # "i":I
    :cond_5
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 214
    .local v2, "removedDevices":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/Integer;>;"
    const/4 v3, 0x0

    .local v3, "i":I
    :goto_4
    iget-object v4, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_9

    .line 215
    iget-object v4, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    iget v4, v4, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    .line 217
    .local v4, "device_id":I
    const/4 v5, 0x0

    .local v5, "j":I
    :goto_5
    array-length v6, v1

    if-ge v5, v6, :cond_7

    .line 218
    aget v6, v1, v5

    if-ne v4, v6, :cond_6

    goto :goto_6

    .line 217
    :cond_6
    add-int/lit8 v5, v5, 0x1

    goto :goto_5

    .line 220
    :cond_7
    :goto_6
    array-length v6, v1

    if-ne v5, v6, :cond_8

    .line 221
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-virtual {v2, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 214
    .end local v4    # "device_id":I
    .end local v5    # "j":I
    :cond_8
    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    .line 225
    .end local v3    # "i":I
    :cond_9
    const/4 v3, 0x0

    .restart local v3    # "i":I
    :goto_7
    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_c

    .line 226
    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 227
    .restart local v4    # "device_id":I
    invoke-static {v4}, Lorg/libsdl/app/SDLControllerManager;->nativeRemoveJoystick(I)I

    .line 228
    const/4 v5, 0x0

    .restart local v5    # "j":I
    :goto_8
    iget-object v6, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v6}, Ljava/util/ArrayList;->size()I

    move-result v6

    if-ge v5, v6, :cond_b

    .line 229
    iget-object v6, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;

    iget v6, v6, Lorg/libsdl/app/SDLJoystickHandler_API16$SDLJoystick;->device_id:I

    if-ne v6, v4, :cond_a

    .line 230
    iget-object v6, v0, Lorg/libsdl/app/SDLJoystickHandler_API16;->mJoysticks:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 231
    goto :goto_9

    .line 228
    :cond_a
    add-int/lit8 v5, v5, 0x1

    goto :goto_8

    .line 225
    .end local v4    # "device_id":I
    .end local v5    # "j":I
    :cond_b
    :goto_9
    add-int/lit8 v3, v3, 0x1

    goto :goto_7

    .line 235
    .end local v3    # "i":I
    :cond_c
    return-void
.end method
