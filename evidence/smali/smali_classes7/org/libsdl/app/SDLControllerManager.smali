.class public Lorg/libsdl/app/SDLControllerManager;
.super Ljava/lang/Object;
.source "SDLControllerManager.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "SDLControllerManager"

.field protected static mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

.field protected static mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static handleJoystickMotionEvent(Landroid/view/MotionEvent;)Z
    .locals 1
    .param p0, "event"    # Landroid/view/MotionEvent;

    .line 58
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;

    invoke-virtual {v0, p0}, Lorg/libsdl/app/SDLJoystickHandler;->handleMotionEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    return v0
.end method

.method public static hapticRun(IFI)V
    .locals 1
    .param p0, "device_id"    # I
    .param p1, "intensity"    # F
    .param p2, "length"    # I

    .line 79
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    invoke-virtual {v0, p0, p1, p2}, Lorg/libsdl/app/SDLHapticHandler;->run(IFI)V

    .line 80
    return-void
.end method

.method public static hapticStop(I)V
    .locals 1
    .param p0, "device_id"    # I

    .line 87
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    invoke-virtual {v0, p0}, Lorg/libsdl/app/SDLHapticHandler;->stop(I)V

    .line 88
    return-void
.end method

.method public static initialize()V
    .locals 2

    .line 39
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;

    if-nez v0, :cond_1

    .line 40
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x13

    if-lt v0, v1, :cond_0

    .line 41
    new-instance v0, Lorg/libsdl/app/SDLJoystickHandler_API19;

    invoke-direct {v0}, Lorg/libsdl/app/SDLJoystickHandler_API19;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLControllerManager;->mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;

    goto :goto_0

    .line 43
    :cond_0
    new-instance v0, Lorg/libsdl/app/SDLJoystickHandler_API16;

    invoke-direct {v0}, Lorg/libsdl/app/SDLJoystickHandler_API16;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLControllerManager;->mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;

    .line 47
    :cond_1
    :goto_0
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    if-nez v0, :cond_3

    .line 48
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_2

    .line 49
    new-instance v0, Lorg/libsdl/app/SDLHapticHandler_API26;

    invoke-direct {v0}, Lorg/libsdl/app/SDLHapticHandler_API26;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    goto :goto_1

    .line 51
    :cond_2
    new-instance v0, Lorg/libsdl/app/SDLHapticHandler;

    invoke-direct {v0}, Lorg/libsdl/app/SDLHapticHandler;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    .line 54
    :cond_3
    :goto_1
    return-void
.end method

.method public static isDeviceSDLJoystick(I)Z
    .locals 5
    .param p0, "deviceId"    # I

    .line 92
    invoke-static {p0}, Landroid/view/InputDevice;->getDevice(I)Landroid/view/InputDevice;

    move-result-object v0

    .line 95
    .local v0, "device":Landroid/view/InputDevice;
    const/4 v1, 0x0

    if-eqz v0, :cond_3

    if-gez p0, :cond_0

    goto :goto_0

    .line 98
    :cond_0
    invoke-virtual {v0}, Landroid/view/InputDevice;->getSources()I

    move-result v2

    .line 113
    .local v2, "sources":I
    and-int/lit8 v3, v2, 0x10

    if-nez v3, :cond_1

    and-int/lit16 v3, v2, 0x201

    const/16 v4, 0x201

    if-eq v3, v4, :cond_1

    and-int/lit16 v3, v2, 0x401

    const/16 v4, 0x401

    if-ne v3, v4, :cond_2

    :cond_1
    const/4 v1, 0x1

    :cond_2
    return v1

    .line 96
    .end local v2    # "sources":I
    :cond_3
    :goto_0
    return v1
.end method

.method public static native nativeAddHaptic(ILjava/lang/String;)I
.end method

.method public static native nativeAddJoystick(ILjava/lang/String;Ljava/lang/String;IIZIIII)I
.end method

.method public static native nativeRemoveHaptic(I)I
.end method

.method public static native nativeRemoveJoystick(I)I
.end method

.method public static native nativeSetupJNI()I
.end method

.method public static native onNativeHat(IIII)V
.end method

.method public static native onNativeJoy(IIF)V
.end method

.method public static native onNativePadDown(II)I
.end method

.method public static native onNativePadUp(II)I
.end method

.method public static pollHapticDevices()V
    .locals 1

    .line 72
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mHapticHandler:Lorg/libsdl/app/SDLHapticHandler;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLHapticHandler;->pollHapticDevices()V

    .line 73
    return-void
.end method

.method public static pollInputDevices()V
    .locals 1

    .line 65
    sget-object v0, Lorg/libsdl/app/SDLControllerManager;->mJoystickHandler:Lorg/libsdl/app/SDLJoystickHandler;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLJoystickHandler;->pollInputDevices()V

    .line 66
    return-void
.end method
