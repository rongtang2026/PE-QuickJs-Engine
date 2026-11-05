.class Lorg/libsdl/app/HIDDeviceBLESteamController;
.super Landroid/bluetooth/BluetoothGattCallback;
.source "HIDDeviceBLESteamController.java"

# interfaces
.implements Lorg/libsdl/app/HIDDevice;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;
    }
.end annotation


# static fields
.field private static final CHROMEBOOK_CONNECTION_CHECK_INTERVAL:I = 0x2710

.field private static final TAG:Ljava/lang/String; = "hidapi"

.field private static final TRANSPORT_AUTO:I = 0x0

.field private static final TRANSPORT_BREDR:I = 0x1

.field private static final TRANSPORT_LE:I = 0x2

.field private static final enterValveMode:[B

.field public static final inputCharacteristic:Ljava/util/UUID;

.field public static final reportCharacteristic:Ljava/util/UUID;

.field public static final steamControllerService:Ljava/util/UUID;


# instance fields
.field mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

.field private mDevice:Landroid/bluetooth/BluetoothDevice;

.field private mDeviceId:I

.field private mFrozen:Z

.field private mGatt:Landroid/bluetooth/BluetoothGatt;

.field private mHandler:Landroid/os/Handler;

.field private mIsChromebook:Z

.field private mIsConnected:Z

.field private mIsReconnecting:Z

.field private mIsRegistered:Z

.field private mManager:Lorg/libsdl/app/HIDDeviceManager;

.field private mOperations:Ljava/util/LinkedList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedList<",
            "Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 47
    const-string v0, "100F6C32-1735-4313-B402-38567131E5F3"

    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    sput-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->steamControllerService:Ljava/util/UUID;

    .line 48
    const-string v0, "100F6C33-1735-4313-B402-38567131E5F3"

    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    sput-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->inputCharacteristic:Ljava/util/UUID;

    .line 49
    const-string v0, "100F6C34-1735-4313-B402-38567131E5F3"

    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    sput-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    .line 50
    const/4 v0, 0x6

    new-array v0, v0, [B

    fill-array-data v0, :array_0

    sput-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->enterValveMode:[B

    return-void

    nop

    :array_0
    .array-data 1
        -0x40t
        -0x79t
        0x3t
        0x8t
        0x7t
        0x0t
    .end array-data
.end method

.method public constructor <init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/bluetooth/BluetoothDevice;)V
    .locals 2
    .param p1, "manager"    # Lorg/libsdl/app/HIDDeviceManager;
    .param p2, "device"    # Landroid/bluetooth/BluetoothDevice;

    .line 159
    invoke-direct {p0}, Landroid/bluetooth/BluetoothGattCallback;-><init>()V

    .line 32
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsRegistered:Z

    .line 33
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 34
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsChromebook:Z

    .line 35
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 36
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mFrozen:Z

    .line 38
    const/4 v1, 0x0

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    .line 160
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 161
    iput-object p2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    .line 162
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getIdentifier()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Lorg/libsdl/app/HIDDeviceManager;->getDeviceIDForIdentifier(Ljava/lang/String;)I

    move-result v1

    iput v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDeviceId:I

    .line 163
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsRegistered:Z

    .line 164
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceManager;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const-string v1, "org.chromium.arc.device_management"

    invoke-virtual {v0, v1}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsChromebook:Z

    .line 165
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    .line 166
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mHandler:Landroid/os/Handler;

    .line 168
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt()Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 176
    return-void
.end method

.method static synthetic access$000(Lorg/libsdl/app/HIDDeviceBLESteamController;)Ljava/util/LinkedList;
    .locals 1
    .param p0, "x0"    # Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 25
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    return-object v0
.end method

.method static synthetic access$100(Lorg/libsdl/app/HIDDeviceBLESteamController;)Landroid/bluetooth/BluetoothGatt;
    .locals 1
    .param p0, "x0"    # Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 25
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    return-object v0
.end method

.method private connectGatt()Landroid/bluetooth/BluetoothGatt;
    .locals 1

    .line 201
    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    return-object v0
.end method

.method private connectGatt(Z)Landroid/bluetooth/BluetoothGatt;
    .locals 3
    .param p1, "managed"    # Z

    .line 189
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_0

    .line 191
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v1}, Lorg/libsdl/app/HIDDeviceManager;->getContext()Landroid/content/Context;

    move-result-object v1

    const/4 v2, 0x2

    invoke-virtual {v0, v1, p1, p0, v2}, Landroid/bluetooth/BluetoothDevice;->connectGatt(Landroid/content/Context;ZLandroid/bluetooth/BluetoothGattCallback;I)Landroid/bluetooth/BluetoothGatt;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 192
    :catch_0
    move-exception v0

    .line 193
    .local v0, "e":Ljava/lang/Exception;
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v2}, Lorg/libsdl/app/HIDDeviceManager;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v1, v2, p1, p0}, Landroid/bluetooth/BluetoothDevice;->connectGatt(Landroid/content/Context;ZLandroid/bluetooth/BluetoothGattCallback;)Landroid/bluetooth/BluetoothGatt;

    move-result-object v1

    return-object v1

    .line 196
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v1}, Lorg/libsdl/app/HIDDeviceManager;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v0, v1, p1, p0}, Landroid/bluetooth/BluetoothDevice;->connectGatt(Landroid/content/Context;ZLandroid/bluetooth/BluetoothGattCallback;)Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    return-object v0
.end method

.method private enableNotification(Ljava/util/UUID;)V
    .locals 1
    .param p1, "chrUuid"    # Ljava/util/UUID;

    .line 400
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-static {v0, p1}, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;->enableNotification(Landroid/bluetooth/BluetoothGatt;Ljava/util/UUID;)Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    move-result-object v0

    .line 401
    .local v0, "op":Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;
    invoke-direct {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->queueGattOperation(Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;)V

    .line 402
    return-void
.end method

.method private executeNextGattOperation()V
    .locals 2

    .line 365
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    monitor-enter v0

    .line 366
    :try_start_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    if-eqz v1, :cond_0

    .line 367
    monitor-exit v0

    return-void

    .line 369
    :cond_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 370
    monitor-exit v0

    return-void

    .line 372
    :cond_1
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->removeFirst()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    .line 373
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 376
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mHandler:Landroid/os/Handler;

    new-instance v1, Lorg/libsdl/app/HIDDeviceBLESteamController$2;

    invoke-direct {v1, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController$2;-><init>(Lorg/libsdl/app/HIDDeviceBLESteamController;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 390
    return-void

    .line 373
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method private finishCurrentGattOperation()V
    .locals 3

    .line 346
    const/4 v0, 0x0

    .line 347
    .local v0, "op":Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    monitor-enter v1

    .line 348
    :try_start_0
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    if-eqz v2, :cond_0

    .line 349
    move-object v0, v2

    .line 350
    const/4 v2, 0x0

    iput-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    .line 352
    :cond_0
    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 353
    if-eqz v0, :cond_1

    .line 354
    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;->finish()Z

    move-result v1

    .line 357
    .local v1, "result":Z
    if-nez v1, :cond_1

    .line 358
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    invoke-virtual {v2, v0}, Ljava/util/LinkedList;->addFirst(Ljava/lang/Object;)V

    .line 361
    .end local v1    # "result":Z
    :cond_1
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->executeNextGattOperation()V

    .line 362
    return-void

    .line 352
    :catchall_0
    move-exception v2

    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v2
.end method

.method private isRegistered()Z
    .locals 1

    .line 293
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsRegistered:Z

    return v0
.end method

.method private probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z
    .locals 7
    .param p1, "controller"    # Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 302
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    .line 303
    return v1

    .line 306
    :cond_0
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    const/4 v2, 0x0

    if-nez v0, :cond_1

    .line 307
    return v2

    .line 310
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "probeService controller="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v3, "hidapi"

    invoke-static {v3, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 312
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->getServices()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/bluetooth/BluetoothGattService;

    .line 313
    .local v4, "service":Landroid/bluetooth/BluetoothGattService;
    invoke-virtual {v4}, Landroid/bluetooth/BluetoothGattService;->getUuid()Ljava/util/UUID;

    move-result-object v5

    sget-object v6, Lorg/libsdl/app/HIDDeviceBLESteamController;->steamControllerService:Ljava/util/UUID;

    invoke-virtual {v5, v6}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    .line 314
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Found Valve steam controller service "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v4}, Landroid/bluetooth/BluetoothGattService;->getUuid()Ljava/util/UUID;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 316
    invoke-virtual {v4}, Landroid/bluetooth/BluetoothGattService;->getCharacteristics()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/bluetooth/BluetoothGattCharacteristic;

    .line 317
    .local v2, "chr":Landroid/bluetooth/BluetoothGattCharacteristic;
    invoke-virtual {v2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v5

    sget-object v6, Lorg/libsdl/app/HIDDeviceBLESteamController;->inputCharacteristic:Ljava/util/UUID;

    invoke-virtual {v5, v6}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2

    .line 318
    const-string v5, "Found input characteristic"

    invoke-static {v3, v5}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 320
    const-string v5, "00002902-0000-1000-8000-00805f9b34fb"

    invoke-static {v5}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v5

    invoke-virtual {v2, v5}, Landroid/bluetooth/BluetoothGattCharacteristic;->getDescriptor(Ljava/util/UUID;)Landroid/bluetooth/BluetoothGattDescriptor;

    move-result-object v5

    .line 321
    .local v5, "cccd":Landroid/bluetooth/BluetoothGattDescriptor;
    if-eqz v5, :cond_2

    .line 322
    invoke-virtual {v2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v6

    invoke-direct {p0, v6}, Lorg/libsdl/app/HIDDeviceBLESteamController;->enableNotification(Ljava/util/UUID;)V

    .line 325
    .end local v2    # "chr":Landroid/bluetooth/BluetoothGattCharacteristic;
    .end local v5    # "cccd":Landroid/bluetooth/BluetoothGattDescriptor;
    :cond_2
    goto :goto_1

    .line 326
    :cond_3
    return v1

    .line 328
    .end local v4    # "service":Landroid/bluetooth/BluetoothGattService;
    :cond_4
    goto :goto_0

    .line 330
    :cond_5
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->getServices()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-nez v0, :cond_6

    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsChromebook:Z

    if-eqz v0, :cond_6

    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    if-nez v0, :cond_6

    .line 331
    const-string v0, "Chromebook: Discovered services were empty; this almost certainly means the BtGatt.ContextMap bug has bitten us."

    invoke-static {v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 332
    iput-boolean v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 333
    iput-boolean v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 334
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 335
    invoke-direct {p0, v2}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 338
    :cond_6
    return v2
.end method

.method private queueGattOperation(Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;)V
    .locals 2
    .param p1, "op"    # Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    .line 393
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    monitor-enter v0

    .line 394
    :try_start_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    invoke-virtual {v1, p1}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    .line 395
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 396
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->executeNextGattOperation()V

    .line 397
    return-void

    .line 395
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method private setRegistered()V
    .locals 1

    .line 297
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsRegistered:Z

    .line 298
    return-void
.end method


# virtual methods
.method protected checkConnectionForChromebookIssue()V
    .locals 6

    .line 232
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsChromebook:Z

    if-nez v0, :cond_0

    .line 235
    return-void

    .line 238
    :cond_0
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getConnectionState()I

    move-result v0

    .line 240
    .local v0, "connectionState":I
    const/4 v1, 0x0

    const/4 v2, 0x1

    const-string v3, "hidapi"

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 242
    :pswitch_0
    iget-boolean v4, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    if-nez v4, :cond_1

    .line 245
    const-string v4, "Chromebook: We are in a very bad state; the controller shows as connected in the underlying Bluetooth layer, but we never received a callback.  Forcing a reconnect."

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 246
    iput-boolean v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 247
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v2}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 248
    invoke-direct {p0, v1}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v1

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 249
    goto :goto_0

    .line 251
    :cond_1
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v4

    if-nez v4, :cond_3

    .line 252
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v4}, Landroid/bluetooth/BluetoothGatt;->getServices()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v4

    if-lez v4, :cond_2

    .line 253
    const-string v1, "Chromebook: We are connected to a controller, but never got our registration.  Trying to recover."

    invoke-static {v3, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 254
    invoke-direct {p0, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z

    goto :goto_0

    .line 257
    :cond_2
    const-string v4, "Chromebook: We are connected to a controller, but never discovered services.  Trying to recover."

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 258
    iput-boolean v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 259
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v2}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 260
    invoke-direct {p0, v1}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v1

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 261
    goto :goto_0

    .line 265
    :cond_3
    const-string v1, "Chromebook: We are connected, and registered.  Everything\'s good!"

    invoke-static {v3, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 266
    return-void

    .line 279
    :pswitch_1
    const-string v1, "Chromebook: We\'re still trying to connect.  Waiting a bit longer."

    invoke-static {v3, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 271
    :pswitch_2
    const-string v4, "Chromebook: We have either been disconnected, or the Chromebook BtGatt.ContextMap bug has bitten us.  Attempting a disconnect/reconnect, but we may not be able to recover."

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 273
    iput-boolean v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 274
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v2}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 275
    invoke-direct {p0, v1}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v1

    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 276
    nop

    .line 283
    :goto_0
    move-object v1, p0

    .line 284
    .local v1, "finalThis":Lorg/libsdl/app/HIDDeviceBLESteamController;
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mHandler:Landroid/os/Handler;

    new-instance v3, Lorg/libsdl/app/HIDDeviceBLESteamController$1;

    invoke-direct {v3, p0, v1}, Lorg/libsdl/app/HIDDeviceBLESteamController$1;-><init>(Lorg/libsdl/app/HIDDeviceBLESteamController;Lorg/libsdl/app/HIDDeviceBLESteamController;)V

    const-wide/16 v4, 0x2710

    invoke-virtual {v2, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 290
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public close()V
    .locals 0

    .line 626
    return-void
.end method

.method protected getConnectionState()I
    .locals 4

    .line 206
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceManager;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 207
    .local v0, "context":Landroid/content/Context;
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 209
    return v1

    .line 212
    :cond_0
    const-string v2, "bluetooth"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/bluetooth/BluetoothManager;

    .line 213
    .local v2, "btManager":Landroid/bluetooth/BluetoothManager;
    if-nez v2, :cond_1

    .line 216
    return v1

    .line 219
    :cond_1
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    const/4 v3, 0x7

    invoke-virtual {v2, v1, v3}, Landroid/bluetooth/BluetoothManager;->getConnectionState(Landroid/bluetooth/BluetoothDevice;I)I

    move-result v1

    return v1
.end method

.method public getDevice()Landroid/hardware/usb/UsbDevice;
    .locals 1

    .line 569
    const/4 v0, 0x0

    return-object v0
.end method

.method public getFeatureReport([B)Z
    .locals 2
    .param p1, "report"    # [B

    .line 611
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    if-nez v0, :cond_1

    .line 612
    const-string v0, "hidapi"

    const-string v1, "Attempted getFeatureReport before Steam Controller is registered!"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 613
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    if-eqz v0, :cond_0

    .line 614
    invoke-direct {p0, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z

    .line 616
    :cond_0
    const/4 v0, 0x0

    return v0

    .line 620
    :cond_1
    sget-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->readCharacteristic(Ljava/util/UUID;)V

    .line 621
    const/4 v0, 0x1

    return v0
.end method

.method public getGatt()Landroid/bluetooth/BluetoothGatt;
    .locals 1

    .line 183
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    return-object v0
.end method

.method public getId()I
    .locals 1

    .line 529
    iget v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDeviceId:I

    return v0
.end method

.method public getIdentifier()Ljava/lang/String;
    .locals 3

    .line 179
    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mDevice:Landroid/bluetooth/BluetoothDevice;

    invoke-virtual {v1}, Landroid/bluetooth/BluetoothDevice;->getAddress()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "SteamController.%s"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public getManufacturerName()Ljava/lang/String;
    .locals 1

    .line 559
    const-string v0, "Valve Corporation"

    return-object v0
.end method

.method public getProductId()I
    .locals 2

    .line 542
    const/16 v0, 0x1106

    .line 543
    .local v0, "D0G_BLE2_PID":I
    const/16 v1, 0x1106

    return v1
.end method

.method public getProductName()Ljava/lang/String;
    .locals 1

    .line 564
    const-string v0, "Steam Controller"

    return-object v0
.end method

.method public getSerialNumber()Ljava/lang/String;
    .locals 1

    .line 549
    const-string v0, "12345"

    return-object v0
.end method

.method public getVendorId()I
    .locals 2

    .line 535
    const/16 v0, 0x28de

    .line 536
    .local v0, "VALVE_USB_VID":I
    const/16 v1, 0x28de

    return v1
.end method

.method public getVersion()I
    .locals 1

    .line 554
    const/4 v0, 0x0

    return v0
.end method

.method public onCharacteristicChanged(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattCharacteristic;)V
    .locals 3
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "characteristic"    # Landroid/bluetooth/BluetoothGattCharacteristic;

    .line 485
    invoke-virtual {p2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v0

    sget-object v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->inputCharacteristic:Ljava/util/UUID;

    invoke-virtual {v0, v1}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mFrozen:Z

    if-nez v0, :cond_0

    .line 486
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v1

    invoke-virtual {p2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getValue()[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceInputReport(I[B)V

    .line 488
    :cond_0
    return-void
.end method

.method public onCharacteristicRead(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattCharacteristic;I)V
    .locals 3
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "characteristic"    # Landroid/bluetooth/BluetoothGattCharacteristic;
    .param p3, "status"    # I

    .line 459
    invoke-virtual {p2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v0

    sget-object v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {v0, v1}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mFrozen:Z

    if-nez v0, :cond_0

    .line 460
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v1

    invoke-virtual {p2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getValue()[B

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceFeatureReport(I[B)V

    .line 463
    :cond_0
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->finishCurrentGattOperation()V

    .line 464
    return-void
.end method

.method public onCharacteristicWrite(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattCharacteristic;I)V
    .locals 14
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "characteristic"    # Landroid/bluetooth/BluetoothGattCharacteristic;
    .param p3, "status"    # I

    .line 469
    invoke-virtual/range {p2 .. p2}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v0

    sget-object v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {v0, v1}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 471
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    if-nez v0, :cond_0

    .line 472
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Registering Steam Controller with ID: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "hidapi"

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 473
    move-object v0, p0

    iget-object v1, v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getId()I

    move-result v2

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getIdentifier()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getVendorId()I

    move-result v4

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getProductId()I

    move-result v5

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getSerialNumber()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getVersion()I

    move-result v7

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getManufacturerName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getProductName()Ljava/lang/String;

    move-result-object v9

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    invoke-virtual/range {v1 .. v13}, Lorg/libsdl/app/HIDDeviceManager;->HIDDeviceConnected(ILjava/lang/String;IILjava/lang/String;ILjava/lang/String;Ljava/lang/String;IIII)V

    .line 474
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->setRegistered()V

    goto :goto_0

    .line 471
    :cond_0
    move-object v0, p0

    goto :goto_0

    .line 469
    :cond_1
    move-object v0, p0

    .line 478
    :goto_0
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->finishCurrentGattOperation()V

    .line 479
    return-void
.end method

.method public onConnectionStateChange(Landroid/bluetooth/BluetoothGatt;II)V
    .locals 2
    .param p1, "g"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "status"    # I
    .param p3, "newState"    # I

    .line 420
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 421
    const/4 v1, 0x2

    if-ne p3, v1, :cond_0

    .line 422
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 424
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    if-nez v0, :cond_1

    .line 425
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mHandler:Landroid/os/Handler;

    new-instance v1, Lorg/libsdl/app/HIDDeviceBLESteamController$3;

    invoke-direct {v1, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController$3;-><init>(Lorg/libsdl/app/HIDDeviceBLESteamController;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_0

    .line 433
    :cond_0
    if-nez p3, :cond_1

    .line 434
    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 438
    :cond_1
    :goto_0
    return-void
.end method

.method public onDescriptorRead(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattDescriptor;I)V
    .locals 0
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "descriptor"    # Landroid/bluetooth/BluetoothGattDescriptor;
    .param p3, "status"    # I

    .line 492
    return-void
.end method

.method public onDescriptorWrite(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattDescriptor;I)V
    .locals 5
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "descriptor"    # Landroid/bluetooth/BluetoothGattDescriptor;
    .param p3, "status"    # I

    .line 495
    invoke-virtual {p2}, Landroid/bluetooth/BluetoothGattDescriptor;->getCharacteristic()Landroid/bluetooth/BluetoothGattCharacteristic;

    move-result-object v0

    .line 498
    .local v0, "chr":Landroid/bluetooth/BluetoothGattCharacteristic;
    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGattCharacteristic;->getUuid()Ljava/util/UUID;

    move-result-object v1

    sget-object v2, Lorg/libsdl/app/HIDDeviceBLESteamController;->inputCharacteristic:Ljava/util/UUID;

    invoke-virtual {v1, v2}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 499
    const/4 v1, 0x1

    .line 500
    .local v1, "hasWrittenInputDescriptor":Z
    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGattCharacteristic;->getService()Landroid/bluetooth/BluetoothGattService;

    move-result-object v2

    sget-object v3, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {v2, v3}, Landroid/bluetooth/BluetoothGattService;->getCharacteristic(Ljava/util/UUID;)Landroid/bluetooth/BluetoothGattCharacteristic;

    move-result-object v2

    .line 501
    .local v2, "reportChr":Landroid/bluetooth/BluetoothGattCharacteristic;
    if-eqz v2, :cond_0

    .line 502
    const-string v3, "hidapi"

    const-string v4, "Writing report characteristic to enter valve mode"

    invoke-static {v3, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 503
    sget-object v3, Lorg/libsdl/app/HIDDeviceBLESteamController;->enterValveMode:[B

    invoke-virtual {v2, v3}, Landroid/bluetooth/BluetoothGattCharacteristic;->setValue([B)Z

    .line 504
    invoke-virtual {p1, v2}, Landroid/bluetooth/BluetoothGatt;->writeCharacteristic(Landroid/bluetooth/BluetoothGattCharacteristic;)Z

    .line 508
    .end local v1    # "hasWrittenInputDescriptor":Z
    .end local v2    # "reportChr":Landroid/bluetooth/BluetoothGattCharacteristic;
    :cond_0
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->finishCurrentGattOperation()V

    .line 509
    return-void
.end method

.method public onMtuChanged(Landroid/bluetooth/BluetoothGatt;II)V
    .locals 0
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "mtu"    # I
    .param p3, "status"    # I

    .line 521
    return-void
.end method

.method public onReadRemoteRssi(Landroid/bluetooth/BluetoothGatt;II)V
    .locals 0
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "rssi"    # I
    .param p3, "status"    # I

    .line 517
    return-void
.end method

.method public onReliableWriteCompleted(Landroid/bluetooth/BluetoothGatt;I)V
    .locals 0
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "status"    # I

    .line 513
    return-void
.end method

.method public onServicesDiscovered(Landroid/bluetooth/BluetoothGatt;I)V
    .locals 2
    .param p1, "gatt"    # Landroid/bluetooth/BluetoothGatt;
    .param p2, "status"    # I

    .line 442
    if-nez p2, :cond_1

    .line 443
    invoke-virtual {p1}, Landroid/bluetooth/BluetoothGatt;->getServices()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-nez v0, :cond_0

    .line 444
    const-string v0, "hidapi"

    const-string v1, "onServicesDiscovered returned zero services; something has gone horribly wrong down in Android\'s Bluetooth stack."

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 445
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsReconnecting:Z

    .line 446
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 447
    invoke-virtual {p1}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 448
    invoke-direct {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt(Z)Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    goto :goto_0

    .line 451
    :cond_0
    invoke-direct {p0, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z

    .line 454
    :cond_1
    :goto_0
    return-void
.end method

.method public open()Z
    .locals 1

    .line 574
    const/4 v0, 0x1

    return v0
.end method

.method public readCharacteristic(Ljava/util/UUID;)V
    .locals 1
    .param p1, "uuid"    # Ljava/util/UUID;

    .line 410
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-static {v0, p1}, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;->readCharacteristic(Landroid/bluetooth/BluetoothGatt;Ljava/util/UUID;)Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    move-result-object v0

    .line 411
    .local v0, "op":Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;
    invoke-direct {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->queueGattOperation(Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;)V

    .line 412
    return-void
.end method

.method public reconnect()V
    .locals 2

    .line 224
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->getConnectionState()I

    move-result v0

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    .line 225
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 226
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->connectGatt()Landroid/bluetooth/BluetoothGatt;

    move-result-object v0

    iput-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 229
    :cond_0
    return-void
.end method

.method public sendFeatureReport([B)I
    .locals 2
    .param p1, "report"    # [B

    .line 579
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    if-nez v0, :cond_1

    .line 580
    const-string v0, "hidapi"

    const-string v1, "Attempted sendFeatureReport before Steam Controller is registered!"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 581
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    if-eqz v0, :cond_0

    .line 582
    invoke-direct {p0, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z

    .line 584
    :cond_0
    const/4 v0, -0x1

    return v0

    .line 588
    :cond_1
    array-length v0, p1

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    invoke-static {p1, v1, v0}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v0

    .line 590
    .local v0, "actual_report":[B
    sget-object v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {p0, v1, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->writeCharacteristic(Ljava/util/UUID;[B)V

    .line 591
    array-length v1, p1

    return v1
.end method

.method public sendOutputReport([B)I
    .locals 2
    .param p1, "report"    # [B

    .line 596
    invoke-direct {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->isRegistered()Z

    move-result v0

    if-nez v0, :cond_1

    .line 597
    const-string v0, "hidapi"

    const-string v1, "Attempted sendOutputReport before Steam Controller is registered!"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 598
    iget-boolean v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    if-eqz v0, :cond_0

    .line 599
    invoke-direct {p0, p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->probeService(Lorg/libsdl/app/HIDDeviceBLESteamController;)Z

    .line 601
    :cond_0
    const/4 v0, -0x1

    return v0

    .line 605
    :cond_1
    sget-object v0, Lorg/libsdl/app/HIDDeviceBLESteamController;->reportCharacteristic:Ljava/util/UUID;

    invoke-virtual {p0, v0, p1}, Lorg/libsdl/app/HIDDeviceBLESteamController;->writeCharacteristic(Ljava/util/UUID;[B)V

    .line 606
    array-length v0, p1

    return v0
.end method

.method public setFrozen(Z)V
    .locals 0
    .param p1, "frozen"    # Z

    .line 630
    iput-boolean p1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mFrozen:Z

    .line 631
    return-void
.end method

.method public shutdown()V
    .locals 2

    .line 635
    invoke-virtual {p0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->close()V

    .line 637
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 638
    .local v0, "g":Landroid/bluetooth/BluetoothGatt;
    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 639
    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->disconnect()V

    .line 640
    invoke-virtual {v0}, Landroid/bluetooth/BluetoothGatt;->close()V

    .line 641
    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    .line 643
    :cond_0
    iput-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 644
    const/4 v1, 0x0

    iput-boolean v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsRegistered:Z

    .line 645
    iput-boolean v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mIsConnected:Z

    .line 646
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mOperations:Ljava/util/LinkedList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->clear()V

    .line 647
    return-void
.end method

.method public writeCharacteristic(Ljava/util/UUID;[B)V
    .locals 1
    .param p1, "uuid"    # Ljava/util/UUID;
    .param p2, "value"    # [B

    .line 405
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController;->mGatt:Landroid/bluetooth/BluetoothGatt;

    invoke-static {v0, p1, p2}, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;->writeCharacteristic(Landroid/bluetooth/BluetoothGatt;Ljava/util/UUID;[B)Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    move-result-object v0

    .line 406
    .local v0, "op":Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;
    invoke-direct {p0, v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->queueGattOperation(Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;)V

    .line 407
    return-void
.end method
