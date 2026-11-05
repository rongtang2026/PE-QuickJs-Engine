.class Lorg/libsdl/app/HIDDeviceBLESteamController$1;
.super Ljava/lang/Object;
.source "HIDDeviceBLESteamController.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/libsdl/app/HIDDeviceBLESteamController;->checkConnectionForChromebookIssue()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

.field final synthetic val$finalThis:Lorg/libsdl/app/HIDDeviceBLESteamController;


# direct methods
.method constructor <init>(Lorg/libsdl/app/HIDDeviceBLESteamController;Lorg/libsdl/app/HIDDeviceBLESteamController;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/HIDDeviceBLESteamController;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 284
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$1;->this$0:Lorg/libsdl/app/HIDDeviceBLESteamController;

    iput-object p2, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$1;->val$finalThis:Lorg/libsdl/app/HIDDeviceBLESteamController;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 287
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceBLESteamController$1;->val$finalThis:Lorg/libsdl/app/HIDDeviceBLESteamController;

    invoke-virtual {v0}, Lorg/libsdl/app/HIDDeviceBLESteamController;->checkConnectionForChromebookIssue()V

    .line 288
    return-void
.end method
