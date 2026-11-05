.class public Lorg/haxe/extension/Extension;
.super Ljava/lang/Object;
.source "Extension.java"


# static fields
.field public static assetManager:Landroid/content/res/AssetManager;

.field public static callbackHandler:Landroid/os/Handler;

.field public static mainActivity:Landroid/app/Activity;

.field public static mainContext:Landroid/content/Context;

.field public static mainView:Landroid/view/View;

.field public static packageName:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onActivityResult(IILandroid/content/Intent;)Z
    .locals 1
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 31
    const/4 v0, 0x1

    return v0
.end method

.method public onBackPressed()Z
    .locals 1

    .line 44
    const/4 v0, 0x1

    return v0
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 56
    return-void
.end method

.method public onDestroy()V
    .locals 0

    .line 66
    return-void
.end method

.method public onLowMemory()V
    .locals 0

    .line 79
    return-void
.end method

.method public onNewIntent(Landroid/content/Intent;)V
    .locals 0
    .param p1, "intent"    # Landroid/content/Intent;

    .line 89
    return-void
.end method

.method public onPause()V
    .locals 0

    .line 100
    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)Z
    .locals 1
    .param p1, "requestCode"    # I
    .param p2, "permissions"    # [Ljava/lang/String;
    .param p3, "grantResults"    # [I

    .line 37
    const/4 v0, 0x1

    return v0
.end method

.method public onRestart()V
    .locals 0

    .line 111
    return-void
.end method

.method public onRestoreInstanceState(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "savedState"    # Landroid/os/Bundle;

    .line 133
    return-void
.end method

.method public onResume()V
    .locals 0

    .line 122
    return-void
.end method

.method public onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "outState"    # Landroid/os/Bundle;

    .line 144
    return-void
.end method

.method public onStart()V
    .locals 0

    .line 156
    return-void
.end method

.method public onStop()V
    .locals 0

    .line 167
    return-void
.end method

.method public onTrimMemory(I)V
    .locals 0
    .param p1, "level"    # I

    .line 180
    return-void
.end method
