.class Lorg/libsdl/app/HIDDeviceUSB;
.super Ljava/lang/Object;
.source "HIDDeviceUSB.java"

# interfaces
.implements Lorg/libsdl/app/HIDDevice;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/libsdl/app/HIDDeviceUSB$InputThread;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "hidapi"


# instance fields
.field protected mConnection:Landroid/hardware/usb/UsbDeviceConnection;

.field protected mDevice:Landroid/hardware/usb/UsbDevice;

.field protected mDeviceId:I

.field protected mFrozen:Z

.field protected mInputEndpoint:Landroid/hardware/usb/UsbEndpoint;

.field protected mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

.field protected mInterface:I

.field protected mInterfaceIndex:I

.field protected mManager:Lorg/libsdl/app/HIDDeviceManager;

.field protected mOutputEndpoint:Landroid/hardware/usb/UsbEndpoint;

.field protected mRunning:Z


# direct methods
.method public constructor <init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;I)V
    .locals 1
    .param p1, "manager"    # Lorg/libsdl/app/HIDDeviceManager;
    .param p2, "usbDevice"    # Landroid/hardware/usb/UsbDevice;
    .param p3, "interface_index"    # I

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 25
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 26
    iput-object p2, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    .line 27
    iput p3, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterfaceIndex:I

    .line 28
    invoke-virtual {p2, p3}, Landroid/hardware/usb/UsbDevice;->getInterface(I)Landroid/hardware/usb/UsbInterface;

    move-result-object v0

    invoke-virtual {v0}, Landroid/hardware/usb/UsbInterface;->getId()I

    move-result v0

    iput v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterface:I

    .line 29
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getIdentifier()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lorg/libsdl/app/HIDDeviceManager;->getDeviceIDForIdentifier(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDeviceId:I

    .line 30
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mRunning:Z

    .line 31
    return-void
.end method


# virtual methods
.method public close()V
    .locals 3

    .line 239
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mRunning:Z

    .line 240
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 241
    :goto_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceUSB$InputThread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 242
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceUSB$InputThread;->interrupt()V

    .line 244
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceUSB$InputThread;->join()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 245
    :catch_0
    move-exception v0

    .line 247
    :goto_1
    goto :goto_0

    .line 249
    :cond_0
    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    .line 251
    :cond_1
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    if-eqz v0, :cond_2

    .line 252
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    iget v2, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterfaceIndex:I

    invoke-virtual {v0, v2}, Landroid/hardware/usb/UsbDevice;->getInterface(I)Landroid/hardware/usb/UsbInterface;

    move-result-object v0

    .line 253
    .local v0, "iface":Landroid/hardware/usb/UsbInterface;
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    invoke-virtual {v2, v0}, Landroid/hardware/usb/UsbDeviceConnection;->releaseInterface(Landroid/hardware/usb/UsbInterface;)Z

    .line 254
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    invoke-virtual {v2}, Landroid/hardware/usb/UsbDeviceConnection;->close()V

    .line 255
    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    .line 257
    .end local v0    # "iface":Landroid/hardware/usb/UsbInterface;
    :cond_2
    return-void
.end method

.method public getDevice()Landroid/hardware/usb/UsbDevice;
    .locals 1

    .line 95
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    return-object v0
.end method

.method public getDeviceName()Ljava/lang/String;
    .locals 5

    .line 99
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getManufacturerName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getProductName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "(0x"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const/4 v1, 0x1

    new-array v2, v1, [Ljava/lang/Object;

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getVendorId()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string v3, "%x"

    invoke-static {v3, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "/0x"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getProductId()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v4

    invoke-static {v3, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public getFeatureReport([B)Z
    .locals 17
    .param p1, "report"    # [B

    .line 194
    move-object/from16 v0, p0

    move-object/from16 v10, p1

    const/4 v11, -0x1

    .line 195
    .local v11, "res":I
    const/4 v1, 0x0

    .line 196
    .local v1, "offset":I
    array-length v2, v10

    .line 197
    .local v2, "length":I
    const/4 v3, 0x0

    .line 198
    .local v3, "skipped_report_id":Z
    const/4 v12, 0x0

    aget-byte v13, v10, v12

    .line 200
    .local v13, "report_number":B
    if-nez v13, :cond_0

    .line 203
    add-int/lit8 v1, v1, 0x1

    .line 204
    add-int/lit8 v2, v2, -0x1

    .line 205
    const/4 v3, 0x1

    move v14, v1

    move v15, v2

    move/from16 v16, v3

    goto :goto_0

    .line 200
    :cond_0
    move v14, v1

    move v15, v2

    move/from16 v16, v3

    .line 208
    .end local v1    # "offset":I
    .end local v2    # "length":I
    .end local v3    # "skipped_report_id":Z
    .local v14, "offset":I
    .local v15, "length":I
    .local v16, "skipped_report_id":Z
    :goto_0
    iget-object v1, v0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    const/16 v2, 0xa1

    const/4 v3, 0x1

    or-int/lit16 v4, v13, 0x300

    iget v5, v0, Lorg/libsdl/app/HIDDeviceUSB;->mInterface:I

    const/16 v9, 0x3e8

    move-object/from16 v6, p1

    move v7, v14

    move v8, v15

    invoke-virtual/range {v1 .. v9}, Landroid/hardware/usb/UsbDeviceConnection;->controlTransfer(IIII[BIII)I

    move-result v1

    .line 216
    .end local v11    # "res":I
    .local v1, "res":I
    if-gez v1, :cond_1

    .line 217
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getFeatureReport() returned "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " on device "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual/range {p0 .. p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "hidapi"

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 218
    return v12

    .line 221
    :cond_1
    if-eqz v16, :cond_2

    .line 222
    add-int/lit8 v1, v1, 0x1

    .line 223
    add-int/lit8 v15, v15, 0x1

    .line 227
    :cond_2
    if-ne v1, v15, :cond_3

    .line 228
    move-object/from16 v2, p1

    .local v2, "data":[B
    goto :goto_1

    .line 230
    .end local v2    # "data":[B
    :cond_3
    invoke-static {v10, v12, v1}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v2

    .line 232
    .restart local v2    # "data":[B
    :goto_1
    iget-object v3, v0, Lorg/libsdl/app/HIDDeviceUSB;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    iget v4, v0, Lorg/libsdl/app/HIDDeviceUSB;->mDeviceId:I

    invoke-virtual {v3, v4, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceFeatureReport(I[B)V

    .line 234
    const/4 v3, 0x1

    return v3
.end method

.method public getId()I
    .locals 1

    .line 39
    iget v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDeviceId:I

    return v0
.end method

.method public getIdentifier()Ljava/lang/String;
    .locals 3

    .line 34
    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/Object;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getDeviceName()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getVendorId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getProductId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x2

    aput-object v1, v0, v2

    iget v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterfaceIndex:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x3

    aput-object v1, v0, v2

    const-string v1, "%s/%x/%x/%d"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public getManufacturerName()Ljava/lang/String;
    .locals 4

    .line 71
    const/4 v0, 0x0

    .line 72
    .local v0, "result":Ljava/lang/String;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v1, v2, :cond_0

    .line 73
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getManufacturerName()Ljava/lang/String;

    move-result-object v0

    .line 75
    :cond_0
    if-nez v0, :cond_1

    .line 76
    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getVendorId()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v2, "%x"

    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 78
    :cond_1
    return-object v0
.end method

.method public getProductId()I
    .locals 1

    .line 49
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v0}, Landroid/hardware/usb/UsbDevice;->getProductId()I

    move-result v0

    return v0
.end method

.method public getProductName()Ljava/lang/String;
    .locals 4

    .line 83
    const/4 v0, 0x0

    .line 84
    .local v0, "result":Ljava/lang/String;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v1, v2, :cond_0

    .line 85
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getProductName()Ljava/lang/String;

    move-result-object v0

    .line 87
    :cond_0
    if-nez v0, :cond_1

    .line 88
    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getProductId()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v2, "%x"

    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 90
    :cond_1
    return-object v0
.end method

.method public getSerialNumber()Ljava/lang/String;
    .locals 3

    .line 54
    const/4 v0, 0x0

    .line 55
    .local v0, "result":Ljava/lang/String;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x15

    if-lt v1, v2, :cond_0

    .line 56
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbDevice;->getSerialNumber()Ljava/lang/String;

    move-result-object v0

    .line 58
    :cond_0
    if-nez v0, :cond_1

    .line 59
    const-string v0, ""

    .line 61
    :cond_1
    return-object v0
.end method

.method public getVendorId()I
    .locals 1

    .line 44
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v0}, Landroid/hardware/usb/UsbDevice;->getVendorId()I

    move-result v0

    return v0
.end method

.method public getVersion()I
    .locals 1

    .line 66
    const/4 v0, 0x0

    return v0
.end method

.method public open()Z
    .locals 7

    .line 104
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceManager;->getUSBManager()Landroid/hardware/usb/UsbManager;

    move-result-object v0

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    invoke-virtual {v0, v1}, Landroid/hardware/usb/UsbManager;->openDevice(Landroid/hardware/usb/UsbDevice;)Landroid/hardware/usb/UsbDeviceConnection;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    .line 105
    const/4 v1, 0x0

    const-string v2, "hidapi"

    if-nez v0, :cond_0

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unable to open USB device "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 107
    return v1

    .line 111
    :cond_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mDevice:Landroid/hardware/usb/UsbDevice;

    iget v3, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterfaceIndex:I

    invoke-virtual {v0, v3}, Landroid/hardware/usb/UsbDevice;->getInterface(I)Landroid/hardware/usb/UsbInterface;

    move-result-object v0

    .line 112
    .local v0, "iface":Landroid/hardware/usb/UsbInterface;
    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    const/4 v4, 0x1

    invoke-virtual {v3, v0, v4}, Landroid/hardware/usb/UsbDeviceConnection;->claimInterface(Landroid/hardware/usb/UsbInterface;Z)Z

    move-result v3

    if-nez v3, :cond_1

    .line 113
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Failed to claim interfaces on USB device "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 114
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->close()V

    .line 115
    return v1

    .line 119
    :cond_1
    const/4 v3, 0x0

    .local v3, "j":I
    :goto_0
    invoke-virtual {v0}, Landroid/hardware/usb/UsbInterface;->getEndpointCount()I

    move-result v5

    if-ge v3, v5, :cond_3

    .line 120
    invoke-virtual {v0, v3}, Landroid/hardware/usb/UsbInterface;->getEndpoint(I)Landroid/hardware/usb/UsbEndpoint;

    move-result-object v5

    .line 121
    .local v5, "endpt":Landroid/hardware/usb/UsbEndpoint;
    invoke-virtual {v5}, Landroid/hardware/usb/UsbEndpoint;->getDirection()I

    move-result v6

    sparse-switch v6, :sswitch_data_0

    goto :goto_1

    .line 123
    :sswitch_0
    iget-object v6, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    if-nez v6, :cond_2

    .line 124
    iput-object v5, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    goto :goto_1

    .line 128
    :sswitch_1
    iget-object v6, p0, Lorg/libsdl/app/HIDDeviceUSB;->mOutputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    if-nez v6, :cond_2

    .line 129
    iput-object v5, p0, Lorg/libsdl/app/HIDDeviceUSB;->mOutputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    .line 119
    .end local v5    # "endpt":Landroid/hardware/usb/UsbEndpoint;
    :cond_2
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 136
    .end local v3    # "j":I
    :cond_3
    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    if-eqz v3, :cond_5

    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceUSB;->mOutputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    if-nez v3, :cond_4

    goto :goto_2

    .line 143
    :cond_4
    iput-boolean v4, p0, Lorg/libsdl/app/HIDDeviceUSB;->mRunning:Z

    .line 144
    new-instance v1, Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    invoke-direct {v1, p0}, Lorg/libsdl/app/HIDDeviceUSB$InputThread;-><init>(Lorg/libsdl/app/HIDDeviceUSB;)V

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInputThread:Lorg/libsdl/app/HIDDeviceUSB$InputThread;

    .line 145
    invoke-virtual {v1}, Lorg/libsdl/app/HIDDeviceUSB$InputThread;->start()V

    .line 147
    return v4

    .line 137
    :cond_5
    :goto_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Missing required endpoint on USB device "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 138
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->close()V

    .line 139
    return v1

    :sswitch_data_0
    .sparse-switch
        0x0 -> :sswitch_1
        0x80 -> :sswitch_0
    .end sparse-switch
.end method

.method public sendFeatureReport([B)I
    .locals 14
    .param p1, "report"    # [B

    .line 152
    const/4 v0, -0x1

    .line 153
    .local v0, "res":I
    const/4 v1, 0x0

    .line 154
    .local v1, "offset":I
    array-length v2, p1

    .line 155
    .local v2, "length":I
    const/4 v3, 0x0

    .line 156
    .local v3, "skipped_report_id":Z
    const/4 v4, 0x0

    aget-byte v4, p1, v4

    .line 158
    .local v4, "report_number":B
    if-nez v4, :cond_0

    .line 159
    add-int/lit8 v1, v1, 0x1

    .line 160
    add-int/lit8 v2, v2, -0x1

    .line 161
    const/4 v3, 0x1

    .line 164
    :cond_0
    iget-object v5, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    const/16 v6, 0x21

    const/16 v7, 0x9

    or-int/lit16 v8, v4, 0x300

    iget v9, p0, Lorg/libsdl/app/HIDDeviceUSB;->mInterface:I

    const/16 v13, 0x3e8

    move-object v10, p1

    move v11, v1

    move v12, v2

    invoke-virtual/range {v5 .. v13}, Landroid/hardware/usb/UsbDeviceConnection;->controlTransfer(IIII[BIII)I

    move-result v0

    .line 172
    if-gez v0, :cond_1

    .line 173
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "sendFeatureReport() returned "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " on device "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-string v6, "hidapi"

    invoke-static {v6, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 174
    const/4 v5, -0x1

    return v5

    .line 177
    :cond_1
    if-eqz v3, :cond_2

    .line 178
    add-int/lit8 v2, v2, 0x1

    .line 180
    :cond_2
    return v2
.end method

.method public sendOutputReport([B)I
    .locals 4
    .param p1, "report"    # [B

    .line 185
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mConnection:Landroid/hardware/usb/UsbDeviceConnection;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mOutputEndpoint:Landroid/hardware/usb/UsbEndpoint;

    array-length v2, p1

    const/16 v3, 0x3e8

    invoke-virtual {v0, v1, p1, v2, v3}, Landroid/hardware/usb/UsbDeviceConnection;->bulkTransfer(Landroid/hardware/usb/UsbEndpoint;[BII)I

    move-result v0

    .line 186
    .local v0, "r":I
    array-length v1, p1

    if-eq v0, v1, :cond_0

    .line 187
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "sendOutputReport() returned "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " on device "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->getDeviceName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "hidapi"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 189
    :cond_0
    return v0
.end method

.method public setFrozen(Z)V
    .locals 0
    .param p1, "frozen"    # Z

    .line 267
    iput-boolean p1, p0, Lorg/libsdl/app/HIDDeviceUSB;->mFrozen:Z

    .line 268
    return-void
.end method

.method public shutdown()V
    .locals 1

    .line 261
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceUSB;->close()V

    .line 262
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceUSB;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 263
    return-void
.end method
