.class public Lorg/libsdl/app/HIDDeviceManager;
.super Ljava/lang/Object;
.source "HIDDeviceManager.java"


# static fields
.field private static final ACTION_USB_PERMISSION:Ljava/lang/String; = "org.libsdl.app.USB_PERMISSION"

.field private static final TAG:Ljava/lang/String; = "hidapi"

.field private static sManager:Lorg/libsdl/app/HIDDeviceManager;

.field private static sManagerRefCount:I


# instance fields
.field private final mBluetoothBroadcast:Landroid/content/BroadcastReceiver;

.field private mBluetoothDevices:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Landroid/bluetooth/BluetoothDevice;",
            "Lorg/libsdl/app/HIDDeviceBLESteamController;",
            ">;"
        }
    .end annotation
.end field

.field private mBluetoothManager:Landroid/bluetooth/BluetoothManager;

.field private mContext:Landroid/content/Context;

.field private mDevicesById:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Lorg/libsdl/app/HIDDevice;",
            ">;"
        }
    .end annotation
.end field

.field private mHandler:Landroid/os/Handler;

.field private mIsChromebook:Z

.field private mLastBluetoothDevices:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/bluetooth/BluetoothDevice;",
            ">;"
        }
    .end annotation
.end field

.field private mNextDeviceId:I

.field private mSharedPreferences:Landroid/content/SharedPreferences;

.field private final mUsbBroadcast:Landroid/content/BroadcastReceiver;

.field private mUsbManager:Landroid/hardware/usb/UsbManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 32
    const/4 v0, 0x0

    sput v0, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 5
    .param p1, "context"    # Landroid/content/Context;

    .line 104
    const-string v0, "hidapi"

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 53
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    .line 54
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    .line 55
    const/4 v1, 0x0

    iput v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mNextDeviceId:I

    .line 56
    const/4 v2, 0x0

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mSharedPreferences:Landroid/content/SharedPreferences;

    .line 57
    iput-boolean v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mIsChromebook:Z

    .line 63
    new-instance v2, Lorg/libsdl/app/HIDDeviceManager$1;

    invoke-direct {v2, p0}, Lorg/libsdl/app/HIDDeviceManager$1;-><init>(Lorg/libsdl/app/HIDDeviceManager;)V

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbBroadcast:Landroid/content/BroadcastReceiver;

    .line 80
    new-instance v2, Lorg/libsdl/app/HIDDeviceManager$2;

    invoke-direct {v2, p0}, Lorg/libsdl/app/HIDDeviceManager$2;-><init>(Lorg/libsdl/app/HIDDeviceManager;)V

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothBroadcast:Landroid/content/BroadcastReceiver;

    .line 105
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    .line 109
    :try_start_0
    invoke-static {v0}, Lorg/libsdl/app/SDL;->loadLibrary(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 135
    nop

    .line 137
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceRegisterCallback()V

    .line 139
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    invoke-virtual {v2, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mSharedPreferences:Landroid/content/SharedPreferences;

    .line 140
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const-string v2, "org.chromium.arc.device_management"

    invoke-virtual {v0, v2}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mIsChromebook:Z

    .line 149
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mSharedPreferences:Landroid/content/SharedPreferences;

    const-string v2, "next_device_id"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mNextDeviceId:I

    .line 152
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->initializeUSB()V

    .line 153
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->initializeBluetooth()V

    .line 154
    return-void

    .line 110
    :catchall_0
    move-exception v2

    .line 111
    .local v2, "e":Ljava/lang/Throwable;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Couldn\'t load hidapi: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v2}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 113
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 114
    .local v0, "builder":Landroid/app/AlertDialog$Builder;
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    .line 115
    const-string v1, "SDL HIDAPI Error"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 116
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Please report the following error to the SDL maintainers: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v2}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 117
    new-instance v1, Lorg/libsdl/app/HIDDeviceManager$3;

    invoke-direct {v1, p0, p1}, Lorg/libsdl/app/HIDDeviceManager$3;-><init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/content/Context;)V

    const-string v3, "Quit"

    invoke-virtual {v0, v3, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 132
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 134
    return-void
.end method

.method private native HIDDeviceRegisterCallback()V
.end method

.method private native HIDDeviceReleaseCallback()V
.end method

.method static synthetic access$000(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;)V
    .locals 0
    .param p0, "x0"    # Lorg/libsdl/app/HIDDeviceManager;
    .param p1, "x1"    # Landroid/hardware/usb/UsbDevice;

    .line 27
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->handleUsbDeviceAttached(Landroid/hardware/usb/UsbDevice;)V

    return-void
.end method

.method static synthetic access$100(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;)V
    .locals 0
    .param p0, "x0"    # Lorg/libsdl/app/HIDDeviceManager;
    .param p1, "x1"    # Landroid/hardware/usb/UsbDevice;

    .line 27
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->handleUsbDeviceDetached(Landroid/hardware/usb/UsbDevice;)V

    return-void
.end method

.method static synthetic access$200(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;Z)V
    .locals 0
    .param p0, "x0"    # Lorg/libsdl/app/HIDDeviceManager;
    .param p1, "x1"    # Landroid/hardware/usb/UsbDevice;
    .param p2, "x2"    # Z

    .line 27
    invoke-direct {p0, p1, p2}, Lorg/libsdl/app/HIDDeviceManager;->handleUsbDevicePermission(Landroid/hardware/usb/UsbDevice;Z)V

    return-void
.end method

.method public static acquire(Landroid/content/Context;)Lorg/libsdl/app/HIDDeviceManager;
    .locals 1
    .param p0, "context"    # Landroid/content/Context;

    .line 35
    sget v0, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    if-nez v0, :cond_0

    .line 36
    new-instance v0, Lorg/libsdl/app/HIDDeviceManager;

    invoke-direct {v0, p0}, Lorg/libsdl/app/HIDDeviceManager;-><init>(Landroid/content/Context;)V

    sput-object v0, Lorg/libsdl/app/HIDDeviceManager;->sManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 38
    :cond_0
    sget v0, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    .line 39
    sget-object v0, Lorg/libsdl/app/HIDDeviceManager;->sManager:Lorg/libsdl/app/HIDDeviceManager;

    return-object v0
.end method

.method private close()V
    .locals 2

    .line 519
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->shutdownUSB()V

    .line 520
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->shutdownBluetooth()V

    .line 521
    monitor-enter p0

    .line 522
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/HIDDevice;

    .line 523
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    invoke-interface {v1}, Lorg/libsdl/app/HIDDevice;->shutdown()V

    .line 524
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    goto :goto_0

    .line 525
    :cond_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    .line 526
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    .line 527
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceReleaseCallback()V

    .line 528
    monitor-exit p0

    .line 529
    return-void

    .line 528
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private connectHIDDeviceUSB(Landroid/hardware/usb/UsbDevice;)V
    .locals 19
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;

    .line 355
    move-object/from16 v14, p0

    move-object/from16 v15, p1

    monitor-enter p0

    .line 356
    const/4 v0, 0x0

    .local v0, "interface_index":I
    :goto_0
    :try_start_0
    invoke-virtual/range {p1 .. p1}, Landroid/hardware/usb/UsbDevice;->getInterfaceCount()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 357
    invoke-virtual {v15, v0}, Landroid/hardware/usb/UsbDevice;->getInterface(I)Landroid/hardware/usb/UsbInterface;

    move-result-object v1

    move-object v13, v1

    .line 358
    .local v13, "usbInterface":Landroid/hardware/usb/UsbInterface;
    invoke-direct {v14, v15, v13}, Lorg/libsdl/app/HIDDeviceManager;->isHIDDeviceInterface(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 359
    new-instance v1, Lorg/libsdl/app/HIDDeviceUSB;

    invoke-direct {v1, v14, v15, v0}, Lorg/libsdl/app/HIDDeviceUSB;-><init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;I)V

    move-object v12, v1

    .line 360
    .local v12, "device":Lorg/libsdl/app/HIDDeviceUSB;
    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getId()I

    move-result v2

    .line 361
    .local v2, "id":I
    iget-object v1, v14, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v3, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 362
    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getIdentifier()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getVendorId()I

    move-result v4

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getProductId()I

    move-result v5

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getSerialNumber()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getVersion()I

    move-result v7

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getManufacturerName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v12}, Lorg/libsdl/app/HIDDeviceUSB;->getProductName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v13}, Landroid/hardware/usb/UsbInterface;->getId()I

    move-result v10

    invoke-virtual {v13}, Landroid/hardware/usb/UsbInterface;->getInterfaceClass()I

    move-result v11

    invoke-virtual {v13}, Landroid/hardware/usb/UsbInterface;->getInterfaceSubclass()I

    move-result v16

    invoke-virtual {v13}, Landroid/hardware/usb/UsbInterface;->getInterfaceProtocol()I

    move-result v17

    move-object/from16 v1, p0

    move-object/from16 v18, v12

    .end local v12    # "device":Lorg/libsdl/app/HIDDeviceUSB;
    .local v18, "device":Lorg/libsdl/app/HIDDeviceUSB;
    move/from16 v12, v16

    move-object/from16 v16, v13

    .end local v13    # "usbInterface":Landroid/hardware/usb/UsbInterface;
    .local v16, "usbInterface":Landroid/hardware/usb/UsbInterface;
    move/from16 v13, v17

    invoke-virtual/range {v1 .. v13}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceConnected(ILjava/lang/String;IILjava/lang/String;ILjava/lang/String;Ljava/lang/String;IIII)V

    goto :goto_1

    .line 358
    .end local v2    # "id":I
    .end local v16    # "usbInterface":Landroid/hardware/usb/UsbInterface;
    .end local v18    # "device":Lorg/libsdl/app/HIDDeviceUSB;
    .restart local v13    # "usbInterface":Landroid/hardware/usb/UsbInterface;
    :cond_0
    move-object/from16 v16, v13

    .line 356
    .end local v13    # "usbInterface":Landroid/hardware/usb/UsbInterface;
    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 365
    .end local v0    # "interface_index":I
    :cond_1
    monitor-exit p0

    .line 366
    return-void

    .line 365
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private getDevice(I)Lorg/libsdl/app/HIDDevice;
    .locals 4
    .param p1, "id"    # I

    .line 544
    monitor-enter p0

    .line 545
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/libsdl/app/HIDDevice;

    .line 546
    .local v0, "result":Lorg/libsdl/app/HIDDevice;
    if-nez v0, :cond_0

    .line 547
    const-string v1, "hidapi"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "No device for id: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 548
    const-string v1, "hidapi"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Available devices: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v3}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 550
    :cond_0
    monitor-exit p0

    return-object v0

    .line 551
    .end local v0    # "result":Lorg/libsdl/app/HIDDevice;
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private handleUsbDeviceAttached(Landroid/hardware/usb/UsbDevice;)V
    .locals 0
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;

    .line 324
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->connectHIDDeviceUSB(Landroid/hardware/usb/UsbDevice;)V

    .line 325
    return-void
.end method

.method private handleUsbDeviceDetached(Landroid/hardware/usb/UsbDevice;)V
    .locals 6
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;

    .line 328
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 329
    .local v0, "devices":Ljava/util/List;, "Ljava/util/List<Ljava/lang/Integer;>;"
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lorg/libsdl/app/HIDDevice;

    .line 330
    .local v2, "device":Lorg/libsdl/app/HIDDevice;
    invoke-interface {v2}, Lorg/libsdl/app/HIDDevice;->getDevice()Landroid/hardware/usb/UsbDevice;

    move-result-object v3

    invoke-virtual {p1, v3}, Landroid/hardware/usb/UsbDevice;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 331
    invoke-interface {v2}, Lorg/libsdl/app/HIDDevice;->getId()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 333
    .end local v2    # "device":Lorg/libsdl/app/HIDDevice;
    :cond_0
    goto :goto_0

    .line 334
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 335
    .local v2, "id":I
    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lorg/libsdl/app/HIDDevice;

    .line 336
    .local v3, "device":Lorg/libsdl/app/HIDDevice;
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 337
    invoke-interface {v3}, Lorg/libsdl/app/HIDDevice;->shutdown()V

    .line 338
    invoke-virtual {p0, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 339
    .end local v2    # "id":I
    .end local v3    # "device":Lorg/libsdl/app/HIDDevice;
    goto :goto_1

    .line 340
    :cond_2
    return-void
.end method

.method private handleUsbDevicePermission(Landroid/hardware/usb/UsbDevice;Z)V
    .locals 4
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;
    .param p2, "permission_granted"    # Z

    .line 343
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/HIDDevice;

    .line 344
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    invoke-interface {v1}, Lorg/libsdl/app/HIDDevice;->getDevice()Landroid/hardware/usb/UsbDevice;

    move-result-object v2

    invoke-virtual {p1, v2}, Landroid/hardware/usb/UsbDevice;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 345
    const/4 v2, 0x0

    .line 346
    .local v2, "opened":Z
    if-eqz p2, :cond_0

    .line 347
    invoke-interface {v1}, Lorg/libsdl/app/HIDDevice;->open()Z

    move-result v2

    .line 349
    :cond_0
    invoke-interface {v1}, Lorg/libsdl/app/HIDDevice;->getId()I

    move-result v3

    invoke-virtual {p0, v3, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceOpenResult(IZ)V

    .line 351
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    .end local v2    # "opened":Z
    :cond_1
    goto :goto_0

    .line 352
    :cond_2
    return-void
.end method

.method private initializeBluetooth()V
    .locals 6

    .line 369
    const-string v0, "hidapi"

    const-string v1, "Initializing Bluetooth"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 371
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "android.permission.BLUETOOTH"

    invoke-virtual {v1, v3, v2}, Landroid/content/pm/PackageManager;->checkPermission(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_0

    .line 372
    const-string v1, "Couldn\'t initialize Bluetooth, missing android.permission.BLUETOOTH"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 373
    return-void

    .line 377
    :cond_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    const-string v2, "bluetooth"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/bluetooth/BluetoothManager;

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothManager:Landroid/bluetooth/BluetoothManager;

    .line 378
    if-nez v1, :cond_1

    .line 380
    return-void

    .line 383
    :cond_1
    invoke-virtual {v1}, Landroid/bluetooth/BluetoothManager;->getAdapter()Landroid/bluetooth/BluetoothAdapter;

    move-result-object v1

    .line 384
    .local v1, "btAdapter":Landroid/bluetooth/BluetoothAdapter;
    if-nez v1, :cond_2

    .line 386
    return-void

    .line 390
    :cond_2
    invoke-virtual {v1}, Landroid/bluetooth/BluetoothAdapter;->getBondedDevices()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/bluetooth/BluetoothDevice;

    .line 392
    .local v3, "device":Landroid/bluetooth/BluetoothDevice;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Bluetooth device available: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 393
    invoke-virtual {p0, v3}, Lorg/libsdl/app/HIDDeviceManager;->isSteamController(Landroid/bluetooth/BluetoothDevice;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 394
    invoke-virtual {p0, v3}, Lorg/libsdl/app/HIDDeviceManager;->connectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)Z

    .line 397
    .end local v3    # "device":Landroid/bluetooth/BluetoothDevice;
    :cond_3
    goto :goto_0

    .line 400
    :cond_4
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 401
    .local v0, "filter":Landroid/content/IntentFilter;
    const-string v2, "android.bluetooth.device.action.ACL_CONNECTED"

    invoke-virtual {v0, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 402
    const-string v2, "android.bluetooth.device.action.ACL_DISCONNECTED"

    invoke-virtual {v0, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 403
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothBroadcast:Landroid/content/BroadcastReceiver;

    invoke-virtual {v2, v3, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 405
    iget-boolean v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mIsChromebook:Z

    if-eqz v2, :cond_5

    .line 406
    new-instance v2, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mHandler:Landroid/os/Handler;

    .line 407
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mLastBluetoothDevices:Ljava/util/List;

    .line 417
    :cond_5
    return-void
.end method

.method private initializeUSB()V
    .locals 3

    .line 175
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    const-string v1, "usb"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/usb/UsbManager;

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbManager:Landroid/hardware/usb/UsbManager;

    .line 221
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 222
    .local v0, "filter":Landroid/content/IntentFilter;
    const-string v1, "android.hardware.usb.action.USB_DEVICE_ATTACHED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 223
    const-string v1, "android.hardware.usb.action.USB_DEVICE_DETACHED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 224
    const-string v1, "org.libsdl.app.USB_PERMISSION"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 225
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbBroadcast:Landroid/content/BroadcastReceiver;

    invoke-virtual {v1, v2, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 227
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbManager:Landroid/hardware/usb/UsbManager;

    invoke-virtual {v1}, Landroid/hardware/usb/UsbManager;->getDeviceList()Ljava/util/HashMap;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/usb/UsbDevice;

    .line 228
    .local v2, "usbDevice":Landroid/hardware/usb/UsbDevice;
    invoke-direct {p0, v2}, Lorg/libsdl/app/HIDDeviceManager;->handleUsbDeviceAttached(Landroid/hardware/usb/UsbDevice;)V

    .line 229
    .end local v2    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    goto :goto_0

    .line 230
    :cond_0
    return-void
.end method

.method private isHIDDeviceInterface(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z
    .locals 3
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;
    .param p2, "usbInterface"    # Landroid/hardware/usb/UsbInterface;

    .line 245
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceClass()I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x3

    if-ne v0, v2, :cond_0

    .line 246
    return v1

    .line 248
    :cond_0
    invoke-direct {p0, p1, p2}, Lorg/libsdl/app/HIDDeviceManager;->isXbox360Controller(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z

    move-result v0

    if-nez v0, :cond_2

    invoke-direct {p0, p1, p2}, Lorg/libsdl/app/HIDDeviceManager;->isXboxOneController(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 251
    :cond_1
    const/4 v0, 0x0

    return v0

    .line 249
    :cond_2
    :goto_0
    return v1
.end method

.method private isXbox360Controller(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z
    .locals 10
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;
    .param p2, "usbInterface"    # Landroid/hardware/usb/UsbInterface;

    .line 255
    const/16 v0, 0x5d

    .line 256
    .local v0, "XB360_IFACE_SUBCLASS":I
    const/4 v1, 0x1

    .line 257
    .local v1, "XB360_IFACE_PROTOCOL":I
    const/16 v2, 0x81

    .line 258
    .local v2, "XB360W_IFACE_PROTOCOL":I
    const/16 v3, 0x15

    new-array v3, v3, [I

    fill-array-data v3, :array_0

    .line 282
    .local v3, "SUPPORTED_VENDORS":[I
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceClass()I

    move-result v4

    const/4 v5, 0x0

    const/16 v6, 0xff

    if-ne v4, v6, :cond_2

    .line 283
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceSubclass()I

    move-result v4

    const/16 v6, 0x5d

    if-ne v4, v6, :cond_2

    .line 284
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceProtocol()I

    move-result v4

    const/4 v6, 0x1

    if-eq v4, v6, :cond_0

    .line 285
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceProtocol()I

    move-result v4

    const/16 v7, 0x81

    if-ne v4, v7, :cond_2

    .line 286
    :cond_0
    invoke-virtual {p1}, Landroid/hardware/usb/UsbDevice;->getVendorId()I

    move-result v4

    .line 287
    .local v4, "vendor_id":I
    array-length v7, v3

    const/4 v8, 0x0

    :goto_0
    if-ge v8, v7, :cond_2

    aget v9, v3, v8

    .line 288
    .local v9, "supportedVid":I
    if-ne v4, v9, :cond_1

    .line 289
    return v6

    .line 287
    .end local v9    # "supportedVid":I
    :cond_1
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 293
    .end local v4    # "vendor_id":I
    :cond_2
    return v5

    nop

    :array_0
    .array-data 4
        0x79
        0x44f
        0x45e
        0x46d
        0x56e
        0x6a3
        0x738
        0x7ff
        0xe6f
        0xf0d
        0x1038
        0x11c9
        0x12ab
        0x1430
        0x146b
        0x1532
        0x15e4
        0x162e
        0x1689
        0x1bad
        0x24c6
    .end array-data
.end method

.method private isXboxOneController(Landroid/hardware/usb/UsbDevice;Landroid/hardware/usb/UsbInterface;)Z
    .locals 8
    .param p1, "usbDevice"    # Landroid/hardware/usb/UsbDevice;
    .param p2, "usbInterface"    # Landroid/hardware/usb/UsbInterface;

    .line 297
    const/16 v0, 0x47

    .line 298
    .local v0, "XB1_IFACE_SUBCLASS":I
    const/16 v1, 0xd0

    .line 299
    .local v1, "XB1_IFACE_PROTOCOL":I
    const/4 v2, 0x7

    new-array v2, v2, [I

    fill-array-data v2, :array_0

    .line 309
    .local v2, "SUPPORTED_VENDORS":[I
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getId()I

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_1

    .line 310
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceClass()I

    move-result v3

    const/16 v5, 0xff

    if-ne v3, v5, :cond_1

    .line 311
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceSubclass()I

    move-result v3

    const/16 v5, 0x47

    if-ne v3, v5, :cond_1

    .line 312
    invoke-virtual {p2}, Landroid/hardware/usb/UsbInterface;->getInterfaceProtocol()I

    move-result v3

    const/16 v5, 0xd0

    if-ne v3, v5, :cond_1

    .line 313
    invoke-virtual {p1}, Landroid/hardware/usb/UsbDevice;->getVendorId()I

    move-result v3

    .line 314
    .local v3, "vendor_id":I
    array-length v5, v2

    const/4 v6, 0x0

    :goto_0
    if-ge v6, v5, :cond_1

    aget v7, v2, v6

    .line 315
    .local v7, "supportedVid":I
    if-ne v3, v7, :cond_0

    .line 316
    const/4 v4, 0x1

    return v4

    .line 314
    .end local v7    # "supportedVid":I
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 320
    .end local v3    # "vendor_id":I
    :cond_1
    return v4

    nop

    :array_0
    .array-data 4
        0x45e
        0x738
        0xe6f
        0xf0d
        0x1532
        0x24c6
        0x2e24
    .end array-data
.end method

.method public static release(Lorg/libsdl/app/HIDDeviceManager;)V
    .locals 2
    .param p0, "manager"    # Lorg/libsdl/app/HIDDeviceManager;

    .line 43
    sget-object v0, Lorg/libsdl/app/HIDDeviceManager;->sManager:Lorg/libsdl/app/HIDDeviceManager;

    if-ne p0, v0, :cond_0

    .line 44
    sget v1, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    add-int/lit8 v1, v1, -0x1

    sput v1, Lorg/libsdl/app/HIDDeviceManager;->sManagerRefCount:I

    .line 45
    if-nez v1, :cond_0

    .line 46
    invoke-direct {v0}, Lorg/libsdl/app/HIDDeviceManager;->close()V

    .line 47
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/HIDDeviceManager;->sManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 50
    :cond_0
    return-void
.end method

.method private shutdownBluetooth()V
    .locals 2

    .line 421
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothBroadcast:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 424
    goto :goto_0

    .line 422
    :catch_0
    move-exception v0

    .line 425
    :goto_0
    return-void
.end method

.method private shutdownUSB()V
    .locals 2

    .line 238
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbBroadcast:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 241
    goto :goto_0

    .line 239
    :catch_0
    move-exception v0

    .line 242
    :goto_0
    return-void
.end method


# virtual methods
.method native HIDDeviceConnected(ILjava/lang/String;IILjava/lang/String;ILjava/lang/String;Ljava/lang/String;IIII)V
.end method

.method native HIDDeviceDisconnected(I)V
.end method

.method native HIDDeviceFeatureReport(I[B)V
.end method

.method native HIDDeviceInputReport(I[B)V
.end method

.method native HIDDeviceOpenPending(I)V
.end method

.method native HIDDeviceOpenResult(IZ)V
.end method

.method public chromebookConnectionHandler()V
    .locals 8

    .line 431
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mIsChromebook:Z

    if-nez v0, :cond_0

    .line 432
    return-void

    .line 435
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 436
    .local v0, "disconnected":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/bluetooth/BluetoothDevice;>;"
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 438
    .local v1, "connected":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Landroid/bluetooth/BluetoothDevice;>;"
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothManager:Landroid/bluetooth/BluetoothManager;

    const/4 v3, 0x7

    invoke-virtual {v2, v3}, Landroid/bluetooth/BluetoothManager;->getConnectedDevices(I)Ljava/util/List;

    move-result-object v2

    .line 440
    .local v2, "currentConnected":Ljava/util/List;, "Ljava/util/List<Landroid/bluetooth/BluetoothDevice;>;"
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_2

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/bluetooth/BluetoothDevice;

    .line 441
    .local v4, "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    iget-object v5, p0, Lorg/libsdl/app/HIDDeviceManager;->mLastBluetoothDevices:Ljava/util/List;

    invoke-interface {v5, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_1

    .line 442
    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 444
    .end local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    :cond_1
    goto :goto_0

    .line 445
    :cond_2
    iget-object v3, p0, Lorg/libsdl/app/HIDDeviceManager;->mLastBluetoothDevices:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/bluetooth/BluetoothDevice;

    .line 446
    .restart local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    invoke-interface {v2, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_3

    .line 447
    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 449
    .end local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    :cond_3
    goto :goto_1

    .line 451
    :cond_4
    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mLastBluetoothDevices:Ljava/util/List;

    .line 453
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_2
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/bluetooth/BluetoothDevice;

    .line 454
    .restart local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    invoke-virtual {p0, v4}, Lorg/libsdl/app/HIDDeviceManager;->disconnectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)V

    .line 455
    .end local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    goto :goto_2

    .line 456
    :cond_5
    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_3
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_6

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/bluetooth/BluetoothDevice;

    .line 457
    .restart local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    invoke-virtual {p0, v4}, Lorg/libsdl/app/HIDDeviceManager;->connectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)Z

    .line 458
    .end local v4    # "bluetoothDevice":Landroid/bluetooth/BluetoothDevice;
    goto :goto_3

    .line 460
    :cond_6
    move-object v3, p0

    .line 461
    .local v3, "finalThis":Lorg/libsdl/app/HIDDeviceManager;
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager;->mHandler:Landroid/os/Handler;

    new-instance v5, Lorg/libsdl/app/HIDDeviceManager$4;

    invoke-direct {v5, p0, v3}, Lorg/libsdl/app/HIDDeviceManager$4;-><init>(Lorg/libsdl/app/HIDDeviceManager;Lorg/libsdl/app/HIDDeviceManager;)V

    const-wide/16 v6, 0x2710

    invoke-virtual {v4, v5, v6, v7}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 467
    return-void
.end method

.method public closeDevice(I)V
    .locals 4
    .param p1, "deviceID"    # I

    .line 640
    const-string v0, "hidapi"

    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "closeDevice deviceID="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 642
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->getDevice(I)Lorg/libsdl/app/HIDDevice;

    move-result-object v1

    .line 643
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    if-nez v1, :cond_0

    .line 644
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 645
    return-void

    .line 648
    :cond_0
    invoke-interface {v1}, Lorg/libsdl/app/HIDDevice;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 651
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    goto :goto_0

    .line 649
    :catch_0
    move-exception v1

    .line 650
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Got exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 652
    .end local v1    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method public connectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)Z
    .locals 4
    .param p1, "bluetoothDevice"    # Landroid/bluetooth/BluetoothDevice;

    .line 470
    const-string v0, "hidapi"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "connectBluetoothDevice device="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 471
    monitor-enter p0

    .line 472
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 473
    const-string v0, "hidapi"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Steam controller with address "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " already exists, attempting reconnect"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 475
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 476
    .local v0, "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->reconnect()V

    .line 478
    const/4 v1, 0x0

    monitor-exit p0

    return v1

    .line 480
    .end local v0    # "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    :cond_0
    new-instance v0, Lorg/libsdl/app/HIDDeviceBLESteamController;

    invoke-direct {v0, p0, p1}, Lorg/libsdl/app/HIDDeviceBLESteamController;-><init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/bluetooth/BluetoothDevice;)V

    .line 481
    .restart local v0    # "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v1

    .line 482
    .local v1, "id":I
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v2, p1, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 483
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v3, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 486
    nop

    .end local v0    # "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    .end local v1    # "id":I
    monitor-exit p0

    .line 487
    const/4 v0, 0x1

    return v0

    .line 486
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public disconnectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)V
    .locals 4
    .param p1, "bluetoothDevice"    # Landroid/bluetooth/BluetoothDevice;

    .line 491
    monitor-enter p0

    .line 492
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 493
    .local v0, "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    if-nez v0, :cond_0

    .line 494
    monitor-exit p0

    return-void

    .line 496
    :cond_0
    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v1

    .line 497
    .local v1, "id":I
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mBluetoothDevices:Ljava/util/HashMap;

    invoke-virtual {v2, p1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 498
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 499
    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->shutdown()V

    .line 500
    invoke-virtual {p0, v1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 501
    .end local v0    # "device":Lorg/libsdl/app/HIDDeviceBLESteamController;
    .end local v1    # "id":I
    monitor-exit p0

    .line 502
    return-void

    .line 501
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public getContext()Landroid/content/Context;
    .locals 1

    .line 157
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    return-object v0
.end method

.method public getDeviceIDForIdentifier(Ljava/lang/String;)I
    .locals 4
    .param p1, "identifier"    # Ljava/lang/String;

    .line 161
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mSharedPreferences:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 163
    .local v0, "spedit":Landroid/content/SharedPreferences$Editor;
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceManager;->mSharedPreferences:Landroid/content/SharedPreferences;

    const/4 v2, 0x0

    invoke-interface {v1, p1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 164
    .local v1, "result":I
    if-nez v1, :cond_0

    .line 165
    iget v2, p0, Lorg/libsdl/app/HIDDeviceManager;->mNextDeviceId:I

    add-int/lit8 v3, v2, 0x1

    iput v3, p0, Lorg/libsdl/app/HIDDeviceManager;->mNextDeviceId:I

    move v1, v2

    .line 166
    const-string v2, "next_device_id"

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 169
    :cond_0
    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 170
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 171
    return v1
.end method

.method public getFeatureReport(I[B)Z
    .locals 4
    .param p1, "deviceID"    # I
    .param p2, "report"    # [B

    .line 625
    const/4 v0, 0x0

    :try_start_0
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->getDevice(I)Lorg/libsdl/app/HIDDevice;

    move-result-object v1

    .line 626
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    if-nez v1, :cond_0

    .line 627
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 628
    return v0

    .line 631
    :cond_0
    invoke-interface {v1, p2}, Lorg/libsdl/app/HIDDevice;->getFeatureReport([B)Z

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    .line 632
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    :catch_0
    move-exception v1

    .line 633
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Got exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "hidapi"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 635
    .end local v1    # "e":Ljava/lang/Exception;
    return v0
.end method

.method getUSBManager()Landroid/hardware/usb/UsbManager;
    .locals 1

    .line 233
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbManager:Landroid/hardware/usb/UsbManager;

    return-object v0
.end method

.method public isSteamController(Landroid/bluetooth/BluetoothDevice;)Z
    .locals 3
    .param p1, "bluetoothDevice"    # Landroid/bluetooth/BluetoothDevice;

    .line 506
    const/4 v0, 0x0

    if-nez p1, :cond_0

    .line 507
    return v0

    .line 511
    :cond_0
    invoke-virtual {p1}, Landroid/bluetooth/BluetoothDevice;->getName()Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_1

    .line 512
    return v0

    .line 515
    :cond_1
    invoke-virtual {p1}, Landroid/bluetooth/BluetoothDevice;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "SteamController"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-virtual {p1}, Landroid/bluetooth/BluetoothDevice;->getType()I

    move-result v1

    and-int/lit8 v1, v1, 0x2

    if-eqz v1, :cond_2

    const/4 v0, 0x1

    :cond_2
    return v0
.end method

.method public openDevice(I)Z
    .locals 8
    .param p1, "deviceID"    # I

    .line 559
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "openDevice deviceID="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "hidapi"

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 560
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->getDevice(I)Lorg/libsdl/app/HIDDevice;

    move-result-object v0

    .line 561
    .local v0, "device":Lorg/libsdl/app/HIDDevice;
    const/4 v2, 0x0

    if-nez v0, :cond_0

    .line 562
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 563
    return v2

    .line 567
    :cond_0
    invoke-interface {v0}, Lorg/libsdl/app/HIDDevice;->getDevice()Landroid/hardware/usb/UsbDevice;

    move-result-object v3

    .line 568
    .local v3, "usbDevice":Landroid/hardware/usb/UsbDevice;
    if-eqz v3, :cond_1

    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbManager:Landroid/hardware/usb/UsbManager;

    invoke-virtual {v4, v3}, Landroid/hardware/usb/UsbManager;->hasPermission(Landroid/hardware/usb/UsbDevice;)Z

    move-result v4

    if-nez v4, :cond_1

    .line 569
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceOpenPending(I)V

    .line 571
    :try_start_0
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager;->mUsbManager:Landroid/hardware/usb/UsbManager;

    iget-object v5, p0, Lorg/libsdl/app/HIDDeviceManager;->mContext:Landroid/content/Context;

    new-instance v6, Landroid/content/Intent;

    const-string v7, "org.libsdl.app.USB_PERMISSION"

    invoke-direct {v6, v7}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-static {v5, v2, v6, v2}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v5

    invoke-virtual {v4, v3, v5}, Landroid/hardware/usb/UsbManager;->requestPermission(Landroid/hardware/usb/UsbDevice;Landroid/app/PendingIntent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 575
    goto :goto_0

    .line 572
    :catch_0
    move-exception v4

    .line 573
    .local v4, "e":Ljava/lang/Exception;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Couldn\'t request permission for USB device "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 574
    invoke-virtual {p0, p1, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceOpenResult(IZ)V

    .line 576
    .end local v4    # "e":Ljava/lang/Exception;
    :goto_0
    return v2

    .line 580
    :cond_1
    :try_start_1
    invoke-interface {v0}, Lorg/libsdl/app/HIDDevice;->open()Z

    move-result v1
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v1

    .line 581
    :catch_1
    move-exception v4

    .line 582
    .restart local v4    # "e":Ljava/lang/Exception;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Got exception: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-static {v4}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 584
    .end local v4    # "e":Ljava/lang/Exception;
    return v2
.end method

.method public sendFeatureReport(I[B)I
    .locals 4
    .param p1, "deviceID"    # I
    .param p2, "report"    # [B

    .line 608
    const/4 v0, -0x1

    :try_start_0
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->getDevice(I)Lorg/libsdl/app/HIDDevice;

    move-result-object v1

    .line 609
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    if-nez v1, :cond_0

    .line 610
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 611
    return v0

    .line 614
    :cond_0
    invoke-interface {v1, p2}, Lorg/libsdl/app/HIDDevice;->sendFeatureReport([B)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    .line 615
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    :catch_0
    move-exception v1

    .line 616
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Got exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "hidapi"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 618
    .end local v1    # "e":Ljava/lang/Exception;
    return v0
.end method

.method public sendOutputReport(I[B)I
    .locals 4
    .param p1, "deviceID"    # I
    .param p2, "report"    # [B

    .line 591
    const/4 v0, -0x1

    :try_start_0
    invoke-direct {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->getDevice(I)Lorg/libsdl/app/HIDDevice;

    move-result-object v1

    .line 592
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    if-nez v1, :cond_0

    .line 593
    invoke-virtual {p0, p1}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceDisconnected(I)V

    .line 594
    return v0

    .line 597
    :cond_0
    invoke-interface {v1, p2}, Lorg/libsdl/app/HIDDevice;->sendOutputReport([B)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v0

    .line 598
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    :catch_0
    move-exception v1

    .line 599
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Got exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "hidapi"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 601
    .end local v1    # "e":Ljava/lang/Exception;
    return v0
.end method

.method public setFrozen(Z)V
    .locals 2
    .param p1, "frozen"    # Z

    .line 532
    monitor-enter p0

    .line 533
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager;->mDevicesById:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/HIDDevice;

    .line 534
    .local v1, "device":Lorg/libsdl/app/HIDDevice;
    invoke-interface {v1, p1}, Lorg/libsdl/app/HIDDevice;->setFrozen(Z)V

    .line 535
    .end local v1    # "device":Lorg/libsdl/app/HIDDevice;
    goto :goto_0

    .line 536
    :cond_0
    monitor-exit p0

    .line 537
    return-void

    .line 536
    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method
