.class Lorg/libsdl/app/HIDDeviceBLESteamController$2;
.super Ljava/lang/Object;
.source "HIDDeviceBLESteamController.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/libsdl/app/HIDDeviceBLESteamController;->executeNextGattOperation()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;


# direct methods
.method constructor <init>(Lorg/libsdl/app/HIDDeviceBLESteamController;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/HIDDeviceBLESteamController;

    .line 376
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$2;->this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 379
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$2;->this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

    invoke-static {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->access$000(Lorg/libsdl/app/HIDDeviceBLESteamController;)Ljava/util/LinkedList;

    move-result-object v0

    monitor-enter v0

    .line 380
    :try_start_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$2;->this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

    iget-object v1, v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    if-nez v1, :cond_0

    .line 381
    const-string v1, "hidapi"

    const-string v2, "Current operation null in executor?"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 382
    monitor-exit v0

    return-void

    .line 385
    :cond_0
    iget-object v1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$2;->this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

    iget-object v1, v1, Lorg/libsdl/app/HIDDeviceBLESteamController;->mCurrentOperation:Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;

    invoke-virtual {v1}, Lorg/libsdl/app/HIDDeviceBLESteamController$GattOperation;->run()V

    .line 387
    monitor-exit v0

    .line 388
    return-void

    .line 387
    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method
