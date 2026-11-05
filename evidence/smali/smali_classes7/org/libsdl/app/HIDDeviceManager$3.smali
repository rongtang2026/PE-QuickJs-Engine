.class Lorg/libsdl/app/HIDDeviceManager$3;
.super Ljava/lang/Object;
.source "HIDDeviceManager.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/libsdl/app/HIDDeviceManager;-><init>(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/HIDDeviceManager;

.field final synthetic val$context:Landroid/content/Context;


# direct methods
.method constructor <init>(Lorg/libsdl/app/HIDDeviceManager;Landroid/content/Context;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/HIDDeviceManager;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 117
    iput-object p1, p0, Lorg/libsdl/app/HIDDeviceManager$3;->this$0:Lorg/libsdl/app/HIDDeviceManager;

    iput-object p2, p0, Lorg/libsdl/app/HIDDeviceManager$3;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 1
    .param p1, "dialog"    # Landroid/content/DialogInterface;
    .param p2, "which"    # I

    .line 123
    :try_start_0
    iget-object v0, p0, Lorg/libsdl/app/HIDDeviceManager$3;->val$context:Landroid/content/Context;

    check-cast v0, Landroid/app/Activity;

    .line 125
    .local v0, "activity":Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/app/Activity;->finish()V
    :try_end_0
    .catch Ljava/lang/ClassCastException; {:try_start_0 .. :try_end_0} :catch_0

    .line 129
    .end local v0    # "activity":Landroid/app/Activity;
    goto :goto_0

    .line 127
    :catch_0
    move-exception v0

    .line 130
    :goto_0
    return-void
.end method
