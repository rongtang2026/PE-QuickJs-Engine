.class Lorg/libsdl/app/SDLSurface;
.super Landroid/view/SurfaceView;
.source "SDLActivity.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;
.implements Landroid/view/View$OnKeyListener;
.implements Landroid/view/View$OnTouchListener;
.implements Landroid/hardware/SensorEventListener;


# instance fields
.field protected mDisplay:Landroid/view/Display;

.field protected mHeight:F

.field public mIsSurfaceReady:Z

.field protected mSensorManager:Landroid/hardware/SensorManager;

.field protected mWidth:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 1691
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    .line 1692
    invoke-virtual {p0}, Lorg/libsdl/app/SDLSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 1694
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLSurface;->setFocusable(Z)V

    .line 1695
    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLSurface;->setFocusableInTouchMode(Z)V

    .line 1696
    invoke-virtual {p0}, Lorg/libsdl/app/SDLSurface;->requestFocus()Z

    .line 1697
    invoke-virtual {p0, p0}, Lorg/libsdl/app/SDLSurface;->setOnKeyListener(Landroid/view/View$OnKeyListener;)V

    .line 1698
    invoke-virtual {p0, p0}, Lorg/libsdl/app/SDLSurface;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 1700
    const-string v0, "window"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/SDLSurface;->mDisplay:Landroid/view/Display;

    .line 1701
    const-string v0, "sensor"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/SensorManager;

    iput-object v0, p0, Lorg/libsdl/app/SDLSurface;->mSensorManager:Landroid/hardware/SensorManager;

    .line 1703
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;

    move-result-object v0

    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLSurface;->setOnGenericMotionListener(Landroid/view/View$OnGenericMotionListener;)V

    .line 1706
    const/high16 v0, 0x3f800000    # 1.0f

    iput v0, p0, Lorg/libsdl/app/SDLSurface;->mWidth:F

    .line 1707
    iput v0, p0, Lorg/libsdl/app/SDLSurface;->mHeight:F

    .line 1709
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/SDLSurface;->mIsSurfaceReady:Z

    .line 1710
    return-void
.end method


# virtual methods
.method public enableSensor(IZ)V
    .locals 4
    .param p1, "sensortype"    # I
    .param p2, "enabled"    # Z

    .line 2037
    if-eqz p2, :cond_0

    .line 2038
    iget-object v0, p0, Lorg/libsdl/app/SDLSurface;->mSensorManager:Landroid/hardware/SensorManager;

    .line 2039
    invoke-virtual {v0, p1}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;

    move-result-object v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    .line 2038
    invoke-virtual {v0, p0, v1, v2, v3}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;ILandroid/os/Handler;)Z

    goto :goto_0

    .line 2042
    :cond_0
    iget-object v0, p0, Lorg/libsdl/app/SDLSurface;->mSensorManager:Landroid/hardware/SensorManager;

    .line 2043
    invoke-virtual {v0, p1}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;

    move-result-object v1

    .line 2042
    invoke-virtual {v0, p0, v1}, Landroid/hardware/SensorManager;->unregisterListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;)V

    .line 2045
    :goto_0
    return-void
.end method

.method public getNativeSurface()Landroid/view/Surface;
    .locals 1

    .line 1726
    invoke-virtual {p0}, Lorg/libsdl/app/SDLSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    return-object v0
.end method

.method public handlePause()V
    .locals 2

    .line 1713
    const/4 v0, 0x1

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Lorg/libsdl/app/SDLSurface;->enableSensor(IZ)V

    .line 1714
    return-void
.end method

.method public handleResume()V
    .locals 1

    .line 1717
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLSurface;->setFocusable(Z)V

    .line 1718
    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLSurface;->setFocusableInTouchMode(Z)V

    .line 1719
    invoke-virtual {p0}, Lorg/libsdl/app/SDLSurface;->requestFocus()Z

    .line 1720
    invoke-virtual {p0, p0}, Lorg/libsdl/app/SDLSurface;->setOnKeyListener(Landroid/view/View$OnKeyListener;)V

    .line 1721
    invoke-virtual {p0, p0}, Lorg/libsdl/app/SDLSurface;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 1722
    invoke-virtual {p0, v0, v0}, Lorg/libsdl/app/SDLSurface;->enableSensor(IZ)V

    .line 1723
    return-void
.end method

.method public onAccuracyChanged(Landroid/hardware/Sensor;I)V
    .locals 0
    .param p1, "sensor"    # Landroid/hardware/Sensor;
    .param p2, "accuracy"    # I

    .line 2050
    return-void
.end method

.method public onCapturedPointerEvent(Landroid/view/MotionEvent;)Z
    .locals 5
    .param p1, "event"    # Landroid/view/MotionEvent;

    .line 2100
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 2103
    .local v0, "action":I
    const/4 v1, 0x1

    const/4 v2, 0x0

    sparse-switch v0, :sswitch_data_0

    .line 2136
    return v2

    .line 2121
    :sswitch_0
    const/16 v3, 0xb

    if-ne v0, v3, :cond_0

    .line 2122
    const/4 v0, 0x0

    goto :goto_0

    .line 2124
    :cond_0
    const/16 v3, 0xc

    if-ne v0, v3, :cond_1

    .line 2125
    const/4 v0, 0x1

    .line 2128
    :cond_1
    :goto_0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    .line 2129
    .local v3, "x":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v2

    .line 2130
    .local v2, "y":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getButtonState()I

    move-result v4

    .line 2132
    .local v4, "button":I
    invoke-static {v4, v0, v3, v2, v1}, Lorg/libsdl/app/SDLActivity;->onNativeMouse(IIFFZ)V

    .line 2133
    return v1

    .line 2105
    .end local v2    # "y":F
    .end local v3    # "x":F
    .end local v4    # "button":I
    :sswitch_1
    const/16 v3, 0xa

    invoke-virtual {p1, v3, v2}, Landroid/view/MotionEvent;->getAxisValue(II)F

    move-result v3

    .line 2106
    .restart local v3    # "x":F
    const/16 v4, 0x9

    invoke-virtual {p1, v4, v2}, Landroid/view/MotionEvent;->getAxisValue(II)F

    move-result v4

    .line 2107
    .local v4, "y":F
    invoke-static {v2, v0, v3, v4, v2}, Lorg/libsdl/app/SDLActivity;->onNativeMouse(IIFFZ)V

    .line 2108
    return v1

    .line 2112
    .end local v3    # "x":F
    .end local v4    # "y":F
    :sswitch_2
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    .line 2113
    .restart local v3    # "x":F
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    .line 2114
    .restart local v4    # "y":F
    invoke-static {v2, v0, v3, v4, v1}, Lorg/libsdl/app/SDLActivity;->onNativeMouse(IIFFZ)V

    .line 2115
    return v1

    nop

    :sswitch_data_0
    .sparse-switch
        0x2 -> :sswitch_2
        0x7 -> :sswitch_2
        0x8 -> :sswitch_1
        0xb -> :sswitch_0
        0xc -> :sswitch_0
    .end sparse-switch
.end method

.method public onKey(Landroid/view/View;ILandroid/view/KeyEvent;)Z
    .locals 4
    .param p1, "v"    # Landroid/view/View;
    .param p2, "keyCode"    # I
    .param p3, "event"    # Landroid/view/KeyEvent;

    .line 1869
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getDeviceId()I

    move-result v0

    .line 1870
    .local v0, "deviceId":I
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getSource()I

    move-result v1

    .line 1879
    .local v1, "source":I
    invoke-static {v0}, Lorg/libsdl/app/SDLControllerManager;->isDeviceSDLJoystick(I)Z

    move-result v2

    const/4 v3, 0x1

    if-eqz v2, :cond_1

    .line 1881
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result v2

    if-nez v2, :cond_0

    .line 1882
    invoke-static {v0, p2}, Lorg/libsdl/app/SDLControllerManager;->onNativePadDown(II)I

    move-result v2

    if-nez v2, :cond_1

    .line 1883
    return v3

    .line 1885
    :cond_0
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result v2

    if-ne v2, v3, :cond_1

    .line 1886
    invoke-static {v0, p2}, Lorg/libsdl/app/SDLControllerManager;->onNativePadUp(II)I

    move-result v2

    if-nez v2, :cond_1

    .line 1887
    return v3

    .line 1892
    :cond_1
    if-nez v1, :cond_2

    .line 1893
    invoke-static {v0}, Landroid/view/InputDevice;->getDevice(I)Landroid/view/InputDevice;

    move-result-object v2

    .line 1894
    .local v2, "device":Landroid/view/InputDevice;
    if-eqz v2, :cond_2

    .line 1895
    invoke-virtual {v2}, Landroid/view/InputDevice;->getSources()I

    move-result v1

    .line 1899
    .end local v2    # "device":Landroid/view/InputDevice;
    :cond_2
    and-int/lit16 v2, v1, 0x101

    if-eqz v2, :cond_5

    .line 1900
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result v2

    if-nez v2, :cond_4

    .line 1902
    invoke-static {p3}, Lorg/libsdl/app/SDLActivity;->isTextInputEvent(Landroid/view/KeyEvent;)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 1903
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getUnicodeChar()I

    move-result v2

    int-to-char v2, v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v3}, Lorg/libsdl/app/SDLInputConnection;->nativeCommitText(Ljava/lang/String;I)V

    .line 1905
    :cond_3
    invoke-static {p2}, Lorg/libsdl/app/SDLActivity;->onNativeKeyDown(I)V

    .line 1906
    return v3

    .line 1908
    :cond_4
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result v2

    if-ne v2, v3, :cond_5

    .line 1910
    invoke-static {p2}, Lorg/libsdl/app/SDLActivity;->onNativeKeyUp(I)V

    .line 1911
    return v3

    .line 1915
    :cond_5
    and-int/lit16 v2, v1, 0x2002

    if-eqz v2, :cond_7

    .line 1918
    const/4 v2, 0x4

    if-eq p2, v2, :cond_6

    const/16 v2, 0x7d

    if-ne p2, v2, :cond_7

    .line 1919
    :cond_6
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result v2

    packed-switch v2, :pswitch_data_0

    goto :goto_0

    .line 1924
    :pswitch_0
    return v3

    .line 1929
    :cond_7
    :goto_0
    const/4 v2, 0x0

    return v2

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method

.method public onSensorChanged(Landroid/hardware/SensorEvent;)V
    .locals 9
    .param p1, "event"    # Landroid/hardware/SensorEvent;

    .line 2054
    iget-object v0, p1, Landroid/hardware/SensorEvent;->sensor:Landroid/hardware/Sensor;

    invoke-virtual {v0}, Landroid/hardware/Sensor;->getType()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    .line 2058
    const/4 v0, 0x0

    .line 2061
    .local v0, "newOrientation":I
    iget-object v2, p0, Lorg/libsdl/app/SDLSurface;->mDisplay:Landroid/view/Display;

    invoke-virtual {v2}, Landroid/view/Display;->getRotation()I

    move-result v2

    const/4 v3, 0x0

    packed-switch v2, :pswitch_data_0

    .line 2078
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v2, v2, v3

    .line 2079
    .local v2, "x":F
    iget-object v3, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v1, v3, v1

    .line 2080
    .local v1, "y":F
    const/4 v0, 0x3

    move v8, v2

    move v2, v1

    move v1, v8

    goto :goto_0

    .line 2068
    .end local v1    # "y":F
    .end local v2    # "x":F
    :pswitch_0
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v1, v2, v1

    .line 2069
    .local v1, "x":F
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v2, v2, v3

    neg-float v2, v2

    .line 2070
    .local v2, "y":F
    const/4 v0, 0x2

    .line 2071
    goto :goto_0

    .line 2073
    .end local v1    # "x":F
    .end local v2    # "y":F
    :pswitch_1
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v2, v2, v3

    neg-float v2, v2

    .line 2074
    .local v2, "x":F
    iget-object v3, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v1, v3, v1

    neg-float v1, v1

    .line 2075
    .local v1, "y":F
    const/4 v0, 0x4

    .line 2076
    move v8, v2

    move v2, v1

    move v1, v8

    goto :goto_0

    .line 2063
    .end local v1    # "y":F
    .end local v2    # "x":F
    :pswitch_2
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v1, v2, v1

    neg-float v1, v1

    .line 2064
    .local v1, "x":F
    iget-object v2, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v2, v2, v3

    .line 2065
    .local v2, "y":F
    const/4 v0, 0x1

    .line 2066
    nop

    .line 2084
    :goto_0
    sget v3, Lorg/libsdl/app/SDLActivity;->mCurrentOrientation:I

    if-eq v0, v3, :cond_0

    .line 2085
    sput v0, Lorg/libsdl/app/SDLActivity;->mCurrentOrientation:I

    .line 2086
    invoke-static {v0}, Lorg/libsdl/app/SDLActivity;->onNativeOrientationChanged(I)V

    .line 2089
    :cond_0
    neg-float v3, v1

    const v4, 0x411ce80a

    div-float/2addr v3, v4

    div-float v5, v2, v4

    iget-object v6, p1, Landroid/hardware/SensorEvent;->values:[F

    const/4 v7, 0x2

    aget v6, v6, v7

    div-float/2addr v6, v4

    invoke-static {v3, v5, v6}, Lorg/libsdl/app/SDLActivity;->onNativeAccel(FFF)V

    .line 2095
    .end local v0    # "newOrientation":I
    .end local v1    # "x":F
    .end local v2    # "y":F
    :cond_1
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 18
    .param p1, "v"    # Landroid/view/View;
    .param p2, "event"    # Landroid/view/MotionEvent;

    .line 1936
    move-object/from16 v1, p0

    move-object/from16 v2, p2

    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getDeviceId()I

    move-result v0

    .line 1937
    .local v0, "touchDevId":I
    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v3

    .line 1938
    .local v3, "pointerCount":I
    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v10

    .line 1941
    .local v10, "action":I
    const/4 v4, -0x1

    .line 1950
    .local v4, "i":I
    if-gez v0, :cond_0

    .line 1951
    add-int/lit8 v0, v0, -0x1

    move/from16 v17, v0

    goto :goto_0

    .line 1950
    :cond_0
    move/from16 v17, v0

    .line 1957
    .end local v0    # "touchDevId":I
    .local v17, "touchDevId":I
    :goto_0
    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getSource()I

    move-result v0

    const/16 v5, 0x2002

    if-eq v0, v5, :cond_7

    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getSource()I

    move-result v0

    const/16 v5, 0x3002

    if-ne v0, v5, :cond_1

    goto/16 :goto_6

    .line 1972
    :cond_1
    const/high16 v0, 0x3f800000    # 1.0f

    packed-switch v10, :pswitch_data_0

    :pswitch_0
    goto/16 :goto_8

    .line 2012
    :pswitch_1
    const/4 v4, 0x0

    :goto_1
    if-ge v4, v3, :cond_8

    .line 2013
    invoke-virtual {v2, v4}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v5

    .line 2014
    .local v5, "pointerFingerId":I
    invoke-virtual {v2, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    iget v7, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    div-float/2addr v6, v7

    .line 2015
    .local v6, "x":F
    invoke-virtual {v2, v4}, Landroid/view/MotionEvent;->getY(I)F

    move-result v7

    iget v8, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    div-float/2addr v7, v8

    .line 2016
    .local v7, "y":F
    invoke-virtual {v2, v4}, Landroid/view/MotionEvent;->getPressure(I)F

    move-result v8

    .line 2017
    .local v8, "p":F
    cmpl-float v9, v8, v0

    if-lez v9, :cond_2

    .line 2020
    const/high16 v8, 0x3f800000    # 1.0f

    .line 2022
    :cond_2
    const/4 v13, 0x1

    move/from16 v11, v17

    move v12, v5

    move v14, v6

    move v15, v7

    move/from16 v16, v8

    invoke-static/range {v11 .. v16}, Lorg/libsdl/app/SDLActivity;->onNativeTouch(IIIFFF)V

    .line 2012
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 1974
    .end local v5    # "pointerFingerId":I
    .end local v6    # "x":F
    .end local v7    # "y":F
    .end local v8    # "p":F
    :pswitch_2
    const/4 v4, 0x0

    move v11, v4

    .end local v4    # "i":I
    .local v11, "i":I
    :goto_2
    if-ge v11, v3, :cond_4

    .line 1975
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v12

    .line 1976
    .local v12, "pointerFingerId":I
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getX(I)F

    move-result v4

    iget v5, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    div-float v13, v4, v5

    .line 1977
    .local v13, "x":F
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    iget v5, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    div-float v14, v4, v5

    .line 1978
    .local v14, "y":F
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getPressure(I)F

    move-result v4

    .line 1979
    .local v4, "p":F
    cmpl-float v5, v4, v0

    if-lez v5, :cond_3

    .line 1982
    const/high16 v4, 0x3f800000    # 1.0f

    move v15, v4

    goto :goto_3

    .line 1979
    :cond_3
    move v15, v4

    .line 1984
    .end local v4    # "p":F
    .local v15, "p":F
    :goto_3
    move/from16 v4, v17

    move v5, v12

    move v6, v10

    move v7, v13

    move v8, v14

    move v9, v15

    invoke-static/range {v4 .. v9}, Lorg/libsdl/app/SDLActivity;->onNativeTouch(IIIFFF)V

    .line 1974
    add-int/lit8 v11, v11, 0x1

    goto :goto_2

    .end local v12    # "pointerFingerId":I
    .end local v13    # "x":F
    .end local v14    # "y":F
    .end local v15    # "p":F
    :cond_4
    move v4, v11

    goto/16 :goto_8

    .line 1991
    .end local v11    # "i":I
    .local v4, "i":I
    :pswitch_3
    const/4 v4, 0x0

    .line 1995
    :pswitch_4
    const/4 v5, -0x1

    if-ne v4, v5, :cond_5

    .line 1996
    invoke-virtual/range {p2 .. p2}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v4

    move v11, v4

    goto :goto_4

    .line 1995
    :cond_5
    move v11, v4

    .line 1999
    .end local v4    # "i":I
    .restart local v11    # "i":I
    :goto_4
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v12

    .line 2000
    .restart local v12    # "pointerFingerId":I
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getX(I)F

    move-result v4

    iget v5, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    div-float v13, v4, v5

    .line 2001
    .restart local v13    # "x":F
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getY(I)F

    move-result v4

    iget v5, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    div-float v14, v4, v5

    .line 2002
    .restart local v14    # "y":F
    invoke-virtual {v2, v11}, Landroid/view/MotionEvent;->getPressure(I)F

    move-result v4

    .line 2003
    .local v4, "p":F
    cmpl-float v0, v4, v0

    if-lez v0, :cond_6

    .line 2006
    const/high16 v4, 0x3f800000    # 1.0f

    move v0, v4

    goto :goto_5

    .line 2003
    :cond_6
    move v0, v4

    .line 2008
    .end local v4    # "p":F
    .local v0, "p":F
    :goto_5
    move/from16 v4, v17

    move v5, v12

    move v6, v10

    move v7, v13

    move v8, v14

    move v9, v0

    invoke-static/range {v4 .. v9}, Lorg/libsdl/app/SDLActivity;->onNativeTouch(IIIFFF)V

    .line 2009
    move v4, v11

    goto :goto_8

    .line 1959
    .end local v0    # "p":F
    .end local v11    # "i":I
    .end local v12    # "pointerFingerId":I
    .end local v13    # "x":F
    .end local v14    # "y":F
    .local v4, "i":I
    :cond_7
    :goto_6
    :try_start_0
    invoke-virtual/range {p2 .. p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v5, "getButtonState"

    const/4 v6, 0x0

    new-array v7, v6, [Ljava/lang/Class;

    invoke-virtual {v0, v5, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v5, v6, [Ljava/lang/Object;

    invoke-virtual {v0, v2, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1962
    .local v0, "mouseButton":I
    goto :goto_7

    .line 1960
    .end local v0    # "mouseButton":I
    :catch_0
    move-exception v0

    .line 1961
    .local v0, "e":Ljava/lang/Exception;
    const/4 v5, 0x1

    move v0, v5

    .line 1966
    .local v0, "mouseButton":I
    :goto_7
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;

    move-result-object v5

    .line 1967
    .local v5, "motionListener":Lorg/libsdl/app/SDLGenericMotionListener_API12;
    invoke-virtual {v5, v2}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->getEventX(Landroid/view/MotionEvent;)F

    move-result v6

    .line 1968
    .restart local v6    # "x":F
    invoke-virtual {v5, v2}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->getEventY(Landroid/view/MotionEvent;)F

    move-result v7

    .line 1970
    .restart local v7    # "y":F
    invoke-virtual {v5}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->inRelativeMode()Z

    move-result v8

    invoke-static {v0, v10, v6, v7, v8}, Lorg/libsdl/app/SDLActivity;->onNativeMouse(IIFFZ)V

    .line 1971
    .end local v5    # "motionListener":Lorg/libsdl/app/SDLGenericMotionListener_API12;
    nop

    .line 2031
    .end local v0    # "mouseButton":I
    .end local v6    # "x":F
    .end local v7    # "y":F
    :cond_8
    :goto_8
    const/4 v0, 0x1

    return v0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_4
        :pswitch_4
    .end packed-switch
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 20
    .param p1, "holder"    # Landroid/view/SurfaceHolder;
    .param p2, "format"    # I
    .param p3, "width"    # I
    .param p4, "height"    # I

    .line 1753
    move-object/from16 v1, p0

    move/from16 v2, p2

    move/from16 v9, p3

    move/from16 v10, p4

    const-string v0, "SDL"

    const-string v3, "surfaceChanged()"

    invoke-static {v0, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1755
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    if-nez v0, :cond_0

    .line 1756
    return-void

    .line 1759
    :cond_0
    const v0, 0x15151002

    .line 1760
    .local v0, "sdlFormat":I
    packed-switch v2, :pswitch_data_0

    .line 1779
    const-string v3, "SDL"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "pixel format unknown "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    move v11, v0

    goto :goto_0

    .line 1770
    :pswitch_0
    const-string v3, "SDL"

    const-string v4, "pixel format RGB_565"

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1771
    const v0, 0x15151002

    .line 1772
    move v11, v0

    goto :goto_0

    .line 1774
    :pswitch_1
    const-string v3, "SDL"

    const-string v4, "pixel format RGB_888"

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1776
    const v0, 0x16161804

    .line 1777
    move v11, v0

    goto :goto_0

    .line 1766
    :pswitch_2
    const-string v3, "SDL"

    const-string v4, "pixel format RGBX_8888"

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1767
    const v0, 0x16261804

    .line 1768
    move v11, v0

    goto :goto_0

    .line 1762
    :pswitch_3
    const-string v3, "SDL"

    const-string v4, "pixel format RGBA_8888"

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1763
    const v0, 0x16462004

    .line 1764
    move v11, v0

    .line 1783
    .end local v0    # "sdlFormat":I
    .local v11, "sdlFormat":I
    :goto_0
    int-to-float v0, v9

    iput v0, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    .line 1784
    int-to-float v0, v10

    iput v0, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    .line 1785
    move/from16 v3, p3

    .line 1786
    .local v3, "nDeviceWidth":I
    move/from16 v4, p4

    .line 1789
    .local v4, "nDeviceHeight":I
    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x11

    if-lt v0, v5, :cond_1

    .line 1790
    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 1791
    .local v0, "realMetrics":Landroid/util/DisplayMetrics;
    iget-object v5, v1, Lorg/libsdl/app/SDLSurface;->mDisplay:Landroid/view/Display;

    invoke-virtual {v5, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 1792
    iget v5, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    move v3, v5

    .line 1793
    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move v4, v5

    goto :goto_1

    .line 1796
    .end local v0    # "realMetrics":Landroid/util/DisplayMetrics;
    :catchall_0
    move-exception v0

    :cond_1
    :goto_1
    move v12, v3

    move v13, v4

    .line 1798
    .end local v3    # "nDeviceWidth":I
    .end local v4    # "nDeviceHeight":I
    .local v12, "nDeviceWidth":I
    .local v13, "nDeviceHeight":I
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v3

    monitor-enter v3

    .line 1800
    :try_start_1
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->notifyAll()V

    .line 1801
    monitor-exit v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 1803
    const-string v0, "SDL"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Window size: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "x"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1804
    const-string v0, "SDL"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Device size: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "x"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1805
    iget-object v0, v1, Lorg/libsdl/app/SDLSurface;->mDisplay:Landroid/view/Display;

    invoke-virtual {v0}, Landroid/view/Display;->getRefreshRate()F

    move-result v8

    move/from16 v3, p3

    move/from16 v4, p4

    move v5, v12

    move v6, v13

    move v7, v11

    invoke-static/range {v3 .. v8}, Lorg/libsdl/app/SDLActivity;->nativeSetScreenResolution(IIIIIF)V

    .line 1806
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeResize()V

    .line 1810
    const/4 v0, 0x0

    .line 1811
    .local v0, "skip":Z
    sget-object v3, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v3}, Lorg/libsdl/app/SDLActivity;->getRequestedOrientation()I

    move-result v3

    .line 1813
    .local v3, "requestedOrientation":I
    const/4 v4, -0x1

    const/4 v5, 0x1

    if-ne v3, v4, :cond_2

    goto :goto_3

    .line 1817
    :cond_2
    if-eq v3, v5, :cond_5

    const/4 v4, 0x7

    if-ne v3, v4, :cond_3

    goto :goto_2

    .line 1822
    :cond_3
    if-eqz v3, :cond_4

    const/4 v4, 0x6

    if-ne v3, v4, :cond_6

    .line 1823
    :cond_4
    iget v4, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    iget v6, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    cmpg-float v4, v4, v6

    if-gez v4, :cond_6

    .line 1824
    const/4 v0, 0x1

    goto :goto_3

    .line 1819
    :cond_5
    :goto_2
    iget v4, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    iget v6, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    cmpl-float v4, v4, v6

    if-lez v4, :cond_6

    .line 1820
    const/4 v0, 0x1

    .line 1829
    :cond_6
    :goto_3
    if-eqz v0, :cond_7

    .line 1830
    iget v4, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    iget v6, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    invoke-static {v4, v6}, Ljava/lang/Math;->min(FF)F

    move-result v4

    float-to-double v6, v4

    .line 1831
    .local v6, "min":D
    iget v4, v1, Lorg/libsdl/app/SDLSurface;->mWidth:F

    iget v8, v1, Lorg/libsdl/app/SDLSurface;->mHeight:F

    invoke-static {v4, v8}, Ljava/lang/Math;->max(FF)F

    move-result v4

    float-to-double v14, v4

    .line 1833
    .local v14, "max":D
    div-double v16, v14, v6

    const-wide v18, 0x3ff3333333333333L    # 1.2

    cmpg-double v4, v16, v18

    if-gez v4, :cond_7

    .line 1834
    const-string v4, "SDL"

    const-string v8, "Don\'t skip on such aspect-ratio. Could be a square resolution."

    invoke-static {v4, v8}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1835
    const/4 v0, 0x0

    .line 1840
    .end local v6    # "min":D
    .end local v14    # "max":D
    :cond_7
    if-eqz v0, :cond_8

    .line 1841
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v6, 0x18

    if-lt v4, v6, :cond_8

    .line 1842
    sget-object v4, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v4}, Lorg/libsdl/app/SDLActivity;->isInMultiWindowMode()Z

    move-result v4

    if-eqz v4, :cond_8

    .line 1843
    const-string v4, "SDL"

    const-string v6, "Don\'t skip in Multi-Window"

    invoke-static {v4, v6}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1844
    const/4 v0, 0x0

    .line 1849
    :cond_8
    if-eqz v0, :cond_9

    .line 1850
    const-string v4, "SDL"

    const-string v5, "Skip .. Surface is not ready."

    invoke-static {v4, v5}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1851
    const/4 v4, 0x0

    iput-boolean v4, v1, Lorg/libsdl/app/SDLSurface;->mIsSurfaceReady:Z

    .line 1852
    return-void

    .line 1856
    :cond_9
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeSurfaceChanged()V

    .line 1859
    iput-boolean v5, v1, Lorg/libsdl/app/SDLSurface;->mIsSurfaceReady:Z

    .line 1861
    sget-object v4, Lorg/libsdl/app/SDLActivity$NativeState;->RESUMED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v4, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 1862
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 1863
    return-void

    .line 1801
    .end local v0    # "skip":Z
    .end local v3    # "requestedOrientation":I
    :catchall_1
    move-exception v0

    :try_start_2
    monitor-exit v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    throw v0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 1732
    const-string v0, "SDL"

    const-string v1, "surfaceCreated()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1733
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeSurfaceCreated()V

    .line 1734
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 1739
    const-string v0, "SDL"

    const-string v1, "surfaceDestroyed()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1742
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->PAUSED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 1743
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 1745
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/SDLSurface;->mIsSurfaceReady:Z

    .line 1746
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeSurfaceDestroyed()V

    .line 1747
    return-void
.end method
