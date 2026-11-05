.class Lorg/libsdl/app/SDLJoystickHandler_API19;
.super Lorg/libsdl/app/SDLJoystickHandler_API16;
.source "SDLControllerManager.java"


# direct methods
.method constructor <init>()V
    .locals 0

    .line 295
    invoke-direct {p0}, Lorg/libsdl/app/SDLJoystickHandler_API16;-><init>()V

    return-void
.end method


# virtual methods
.method public getButtonMask(Landroid/view/InputDevice;)I
    .locals 6
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 309
    const/4 v0, 0x0

    .line 310
    .local v0, "button_mask":I
    const/16 v1, 0x25

    new-array v2, v1, [I

    fill-array-data v2, :array_0

    .line 351
    .local v2, "keys":[I
    new-array v1, v1, [I

    fill-array-data v1, :array_1

    .line 391
    .local v1, "masks":[I
    invoke-virtual {p1, v2}, Landroid/view/InputDevice;->hasKeys([I)[Z

    move-result-object v3

    .line 392
    .local v3, "has_keys":[Z
    const/4 v4, 0x0

    .local v4, "i":I
    :goto_0
    array-length v5, v2

    if-ge v4, v5, :cond_1

    .line 393
    aget-boolean v5, v3, v4

    if-eqz v5, :cond_0

    .line 394
    aget v5, v1, v4

    or-int/2addr v0, v5

    .line 392
    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 397
    .end local v4    # "i":I
    :cond_1
    return v0

    :array_0
    .array-data 4
        0x60
        0x61
        0x63
        0x64
        0x4
        0x6e
        0x6c
        0x6a
        0x6b
        0x66
        0x67
        0x13
        0x14
        0x15
        0x16
        0x6d
        0x17
        0x68
        0x69
        0x62
        0x65
        0xbc
        0xbd
        0xbe
        0xbf
        0xc0
        0xc1
        0xc2
        0xc3
        0xc4
        0xc5
        0xc6
        0xc7
        0xc8
        0xc9
        0xca
        0xcb
    .end array-data

    :array_1
    .array-data 4
        0x1
        0x2
        0x4
        0x8
        0x10
        0x20
        0x40
        0x80
        0x100
        0x200
        0x400
        0x800
        0x1000
        0x2000
        0x4000
        0x10
        0x1
        0x8000
        0x10000
        0x20000
        0x40000
        0x100000
        0x200000
        0x400000
        0x800000
        0x1000000
        0x2000000
        0x4000000
        0x8000000
        0x10000000
        0x20000000
        0x40000000    # 2.0f
        -0x80000000
        -0x1
        -0x1
        -0x1
        -0x1
    .end array-data
.end method

.method public getProductId(Landroid/view/InputDevice;)I
    .locals 1
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 299
    invoke-virtual {p1}, Landroid/view/InputDevice;->getProductId()I

    move-result v0

    return v0
.end method

.method public getVendorId(Landroid/view/InputDevice;)I
    .locals 1
    .param p1, "joystickDevice"    # Landroid/view/InputDevice;

    .line 304
    invoke-virtual {p1}, Landroid/view/InputDevice;->getVendorId()I

    move-result v0

    return v0
.end method
