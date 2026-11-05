.class Lorg/libsdl/app/HIDDeviceManager$1;
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

    .line 63
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceManager$1;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 5
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 66
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    .line 67
    .local v0, "action":Ljava/lang/String;
    const-string v1, "android.hardware.usb.action.USB_DEVICE_ATTACHED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const-string v2, "device"

    if-eqz v1, :cond_0

    .line 68
    invoke-virtual {p2, v2}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/hardware/usb/UsbDevice;

    .line 69
    .local v1, "usbDevice":Landroid/hardware/usb/UsbDevice;
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager$1;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-static {v2, v1}, Lorg/libsdl/app/HIDDeviceManager;->access$000(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;)V

    .line 70
    .end local v1    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    goto :goto_1

    :cond_0
    const-string v1, "android.hardware.usb.action.USB_DEVICE_DETACHED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 71
    invoke-virtual {p2, v2}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/hardware/usb/UsbDevice;

    .line 72
    .restart local v1    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager$1;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    invoke-static {v2, v1}, Lorg/libsdl/app/HIDDeviceManager;->access$100(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;)V

    .end local v1    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    goto :goto_0

    .line 73
    :cond_1
    const-string v1, "org.libsdl.app.USB_PERMISSION"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 74
    invoke-virtual {p2, v2}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    check-cast v1, Landroid/hardware/usb/UsbDevice;

    .line 75
    .restart local v1    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    iget-object v2, p0, Lorg/libsdl/app/HIDDeviceManager$1;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    const/4 v3, 0x0

    const-string v4, "permission"

    invoke-virtual {p2, v4, v3}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v3

    invoke-static {v2, v1, v3}, Lorg/libsdl/app/HIDDeviceManager;->access$200(Lorg/libsdl/app/HIDDeviceManager;Landroid/hardware/usb/UsbDevice;Z)V

    goto :goto_1

    .line 73
    .end local v1    # "usbDevice":Landroid/hardware/usb/UsbDevice;
    :cond_2
    :goto_0
    nop

    .line 77
    :goto_1
    return-void
.end method
