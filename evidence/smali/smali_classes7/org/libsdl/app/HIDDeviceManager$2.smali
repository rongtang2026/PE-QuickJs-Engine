.class Lorg/libsdl/app/HIDDeviceManager$2;
.super Landroid/content/BroadcastReceiver;
.source "HIDDeviceManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/libsdl/app/HIDDeviceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/HIDDeviceManager;


# direct methods
.method constructor <init>(Lorg/libsdl/app/HIDDeviceManager;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/HIDDeviceManager;

    .line 80
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceManager$2;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 6
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 83
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    .line 85
    .local v0, "action":Ljava/lang/String;
    const-string v1, "android.bluetooth.device.action.ACL_CONNECTED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const-string v2, "hidapi"

    const-string v3, "android.bluetooth.device.extra.DEVICE"

    if-eqz v1, :cond_0

    .line 86
    invoke-virtual {p2, v3}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/bluetooth/BluetoothDevice;

    .line 87
    .local v1, "device":Landroid/bluetooth/BluetoothDevice;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Bluetooth device connected: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 89
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager$2;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v4, v1}, Lorg/libsdl/app/HIDDeviceManager;->isSteamController(Landroid/bluetooth/BluetoothDevice;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 90
    iget-object v4, p0, Lorg/libsdl/app/HIDDeviceManager$2;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v4, v1}, Lorg/libsdl/app/HIDDeviceManager;->connectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)Z

    .line 95
    .end local v1    # "device":Landroid/bluetooth/BluetoothDevice;
    :cond_0
    const-string v1, "android.bluetooth.device.action.ACL_DISCONNECTED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 96
    invoke-virtual {p2, v3}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/bluetooth/BluetoothDevice;

    .line 97
    .restart local v1    # "device":Landroid/bluetooth/BluetoothDevice;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Bluetooth device disconnected: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 99
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager$2;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-virtual {v2, v1}, Lorg/libsdl/app/HIDDeviceManager;->disconnectBluetoothDevice(Landroid/bluetooth/BluetoothDevice;)V

    .line 101
    .end local v1    # "device":Landroid/bluetooth/BluetoothDevice;
    :cond_1
    return-void
.end method
