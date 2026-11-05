.class Lorg/haxe/extension/Tools$4;
.super Ljava/lang/Object;
.source "Tools.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/haxe/extension/Tools;->showNotification(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$ID:I

.field final synthetic val$channelID:Ljava/lang/String;

.field final synthetic val$channelName:Ljava/lang/String;

.field final synthetic val$message:Ljava/lang/String;

.field final synthetic val$title:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 224
    iput-object p1, p0, Lorg/haxe/extension/Tools$4;->val$channelID:Ljava/lang/String;

    iput-object p2, p0, Lorg/haxe/extension/Tools$4;->val$channelName:Ljava/lang/String;

    iput-object p3, p0, Lorg/haxe/extension/Tools$4;->val$title:Ljava/lang/String;

    iput-object p4, p0, Lorg/haxe/extension/Tools$4;->val$message:Ljava/lang/String;

    iput p5, p0, Lorg/haxe/extension/Tools$4;->val$ID:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 230
    :try_start_0
    sget-object v0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    const-string v1, "notification"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 232
    .local v0, "notificationManager":Landroid/app/NotificationManager;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1a

    if-lt v1, v2, :cond_0

    .line 233
    new-instance v1, Landroid/app/NotificationChannel;

    iget-object v2, p0, Lorg/haxe/extension/Tools$4;->val$channelID:Ljava/lang/String;

    iget-object v3, p0, Lorg/haxe/extension/Tools$4;->val$channelName:Ljava/lang/String;

    const/4 v4, 0x3

    invoke-direct {v1, v2, v3, v4}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    .line 235
    :cond_0
    new-instance v1, Landroid/app/Notification$Builder;

    sget-object v2, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    iget-object v3, p0, Lorg/haxe/extension/Tools$4;->val$channelID:Ljava/lang/String;

    invoke-direct {v1, v2, v3}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 236
    .local v1, "builder":Landroid/app/Notification$Builder;
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    .line 237
    iget-object v2, p0, Lorg/haxe/extension/Tools$4;->val$title:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    .line 238
    iget-object v2, p0, Lorg/haxe/extension/Tools$4;->val$message:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    .line 239
    const/4 v2, -0x1

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setDefaults(I)Landroid/app/Notification$Builder;

    .line 240
    const v2, 0x108009b

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    .line 241
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Landroid/app/Notification$Builder;->setWhen(J)Landroid/app/Notification$Builder;

    .line 242
    iget v2, p0, Lorg/haxe/extension/Tools$4;->val$ID:I

    invoke-virtual {v1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v3

    invoke-virtual {v0, v2, v3}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 247
    .end local v0    # "notificationManager":Landroid/app/NotificationManager;
    .end local v1    # "builder":Landroid/app/Notification$Builder;
    goto :goto_0

    .line 244
    :catch_0
    move-exception v0

    .line 246
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 248
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method
