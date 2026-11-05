.class public Lorg/haxe/lime/GameActivity;
.super Lorg/libsdl/app/SDLActivity;
.source "GameActivity.java"


# static fields
.field private static assetManager:Landroid/content/res/AssetManager;

.field private static extensions:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lorg/haxe/extension/Extension;",
            ">;"
        }
    .end annotation
.end field

.field private static metrics:Landroid/util/DisplayMetrics;

.field private static vibrator:Landroid/os/Vibrator;


# instance fields
.field public handler:Landroid/os/Handler;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 27
    invoke-direct {p0}, Lorg/libsdl/app/SDLActivity;-><init>()V

    return-void
.end method

.method public static getDisplayXDPI()D
    .locals 2

    .line 39
    sget-object v0, Lorg/haxe/lime/GameActivity;->metrics:Landroid/util/DisplayMetrics;

    if-nez v0, :cond_0

    .line 41
    sget-object v0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    sput-object v0, Lorg/haxe/lime/GameActivity;->metrics:Landroid/util/DisplayMetrics;

    .line 45
    :cond_0
    sget-object v0, Lorg/haxe/lime/GameActivity;->metrics:Landroid/util/DisplayMetrics;

    iget v0, v0, Landroid/util/DisplayMetrics;->xdpi:F

    float-to-double v0, v0

    return-wide v0
.end method

.method public static openFile(Ljava/lang/String;)V
    .locals 6
    .param p0, "path"    # Ljava/lang/String;

    .line 320
    move-object v0, p0

    .line 321
    .local v0, "extension":Ljava/lang/String;
    const/16 v1, 0x2e

    :try_start_0
    invoke-virtual {p0, v1}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v1

    .line 323
    .local v1, "index":I
    if-lez v1, :cond_0

    .line 325
    add-int/lit8 v2, v1, 0x1

    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    move-object v0, v2

    .line 329
    :cond_0
    invoke-static {}, Landroid/webkit/MimeTypeMap;->getSingleton()Landroid/webkit/MimeTypeMap;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/webkit/MimeTypeMap;->getMimeTypeFromExtension(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 330
    .local v2, "mimeType":Ljava/lang/String;
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 332
    .local v3, "file":Ljava/io/File;
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    .line 333
    .local v4, "intent":Landroid/content/Intent;
    const-string v5, "android.intent.action.VIEW"

    invoke-virtual {v4, v5}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 334
    invoke-static {v3}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object v5

    invoke-virtual {v4, v5, v2}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    .line 336
    sget-object v5, Lorg/haxe/extension/Extension;->mainActivity:Landroid/app/Activity;

    invoke-virtual {v5, v4}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 343
    .end local v0    # "extension":Ljava/lang/String;
    .end local v1    # "index":I
    .end local v2    # "mimeType":Ljava/lang/String;
    .end local v3    # "file":Ljava/io/File;
    .end local v4    # "intent":Landroid/content/Intent;
    nop

    .line 345
    return-void

    .line 338
    :catch_0
    move-exception v0

    .line 340
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "GameActivity"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 341
    return-void
.end method

.method public static openURL(Ljava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "url"    # Ljava/lang/String;
    .param p1, "target"    # Ljava/lang/String;

    .line 350
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.VIEW"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    move-result-object v0

    .line 354
    .local v0, "browserIntent":Landroid/content/Intent;
    :try_start_0
    sget-object v1, Lorg/haxe/extension/Extension;->mainActivity:Landroid/app/Activity;

    invoke-virtual {v1, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 361
    nop

    .line 363
    return-void

    .line 356
    :catch_0
    move-exception v1

    .line 358
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "GameActivity"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 359
    return-void
.end method

.method public static postUICallback(J)V
    .locals 2
    .param p0, "handle"    # J

    .line 368
    sget-object v0, Lorg/haxe/extension/Extension;->callbackHandler:Landroid/os/Handler;

    new-instance v1, Lorg/haxe/lime/GameActivity$1;

    invoke-direct {v1, p0, p1}, Lorg/haxe/lime/GameActivity$1;-><init>(J)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 378
    return-void
.end method

.method public static vibrate(II)V
    .locals 8
    .param p0, "period"    # I
    .param p1, "duration"    # I

    .line 383
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Landroid/os/Vibrator;->hasVibrator()Z

    move-result v0

    if-eqz v0, :cond_5

    if-ltz p0, :cond_5

    if-gtz p1, :cond_0

    goto :goto_2

    .line 389
    :cond_0
    const/16 v0, 0x1a

    const/4 v1, -0x1

    if-nez p0, :cond_2

    .line 391
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v2, v0, :cond_1

    .line 393
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    int-to-long v2, p1

    invoke-static {v2, v3, v1}, Landroid/os/VibrationEffect;->createOneShot(JI)Landroid/os/VibrationEffect;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V

    goto :goto_1

    .line 397
    :cond_1
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    int-to-long v1, p1

    invoke-virtual {v0, v1, v2}, Landroid/os/Vibrator;->vibrate(J)V

    goto :goto_1

    .line 404
    :cond_2
    int-to-double v2, p0

    const-wide/high16 v4, 0x4000000000000000L    # 2.0

    div-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v2

    double-to-int v2, v2

    .line 405
    .local v2, "periodMS":I
    int-to-double v3, p1

    int-to-double v5, v2

    div-double/2addr v3, v5

    invoke-static {v3, v4}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v3

    double-to-int v3, v3

    .line 406
    .local v3, "count":I
    new-array v4, v3, [J

    .line 409
    .local v4, "pattern":[J
    const/4 v5, 0x1

    .local v5, "i":I
    :goto_0
    if-ge v5, v3, :cond_3

    .line 411
    int-to-long v6, v2

    aput-wide v6, v4, v5

    .line 409
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 415
    .end local v5    # "i":I
    :cond_3
    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v5, v0, :cond_4

    .line 417
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    invoke-static {v4, v1}, Landroid/os/VibrationEffect;->createWaveform([JI)Landroid/os/VibrationEffect;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V

    goto :goto_1

    .line 421
    :cond_4
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    invoke-virtual {v0, v4, v1}, Landroid/os/Vibrator;->vibrate([JI)V

    .line 427
    .end local v2    # "periodMS":I
    .end local v3    # "count":I
    .end local v4    # "pattern":[J
    :goto_1
    return-void

    .line 385
    :cond_5
    :goto_2
    return-void
.end method


# virtual methods
.method protected getLibraries()[Ljava/lang/String;
    .locals 4

    .line 52
    const-string v0, "lime"

    const-string v1, "c++_shared"

    const-string v2, "vlc"

    const-string v3, "ApplicationMain"

    filled-new-array {v0, v1, v2, v3}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method protected getMainFunction()Ljava/lang/String;
    .locals 1

    .line 71
    const-string v0, "hxcpp_main"

    return-object v0
.end method

.method protected getMainSharedObject()Ljava/lang/String;
    .locals 1

    .line 64
    const-string v0, "libApplicationMain.so"

    return-object v0
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 3
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 78
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 80
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1, p2, p3}, Lorg/haxe/extension/Extension;->onActivityResult(IILandroid/content/Intent;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 82
    return-void

    .line 86
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    :cond_0
    goto :goto_0

    .line 88
    :cond_1
    invoke-super {p0, p1, p2, p3}, Lorg/libsdl/app/SDLActivity;->onActivityResult(IILandroid/content/Intent;)V

    .line 90
    return-void
.end method

.method public onBackPressed()V
    .locals 3

    .line 95
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 97
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onBackPressed()Z

    move-result v2

    if-nez v2, :cond_0

    .line 99
    return-void

    .line 103
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    :cond_0
    goto :goto_0

    .line 105
    :cond_1
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onBackPressed()V

    .line 107
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "state"    # Landroid/os/Bundle;

    .line 112
    invoke-super {p0, p1}, Lorg/libsdl/app/SDLActivity;->onCreate(Landroid/os/Bundle;)V

    .line 114
    invoke-virtual {p0}, Lorg/haxe/lime/GameActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    sput-object v0, Lorg/haxe/lime/GameActivity;->assetManager:Landroid/content/res/AssetManager;

    .line 115
    sget-object v0, Lorg/haxe/lime/GameActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    const-string v1, "vibrator"

    invoke-virtual {v0, v1}, Lorg/libsdl/app/SDLActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Vibrator;

    sput-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    .line 116
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lorg/haxe/lime/GameActivity;->handler:Landroid/os/Handler;

    .line 118
    sget-object v0, Lorg/haxe/lime/GameActivity;->assetManager:Landroid/content/res/AssetManager;

    sput-object v0, Lorg/haxe/extension/Extension;->assetManager:Landroid/content/res/AssetManager;

    .line 119
    iget-object v0, p0, Lorg/haxe/lime/GameActivity;->handler:Landroid/os/Handler;

    sput-object v0, Lorg/haxe/extension/Extension;->callbackHandler:Landroid/os/Handler;

    .line 120
    sput-object p0, Lorg/haxe/extension/Extension;->mainActivity:Landroid/app/Activity;

    .line 121
    sput-object p0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 122
    sget-object v0, Lorg/haxe/lime/GameActivity;->mLayout:Landroid/view/ViewGroup;

    sput-object v0, Lorg/haxe/extension/Extension;->mainView:Landroid/view/View;

    .line 123
    invoke-virtual {p0}, Lorg/haxe/lime/GameActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/haxe/extension/Extension;->packageName:Ljava/lang/String;

    .line 125
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    if-nez v0, :cond_0

    .line 127
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    .line 129
    new-instance v1, Lorg/haxe/extension/Tools;

    invoke-direct {v1}, Lorg/haxe/extension/Tools;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 133
    :cond_0
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 135
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1}, Lorg/haxe/extension/Extension;->onCreate(Landroid/os/Bundle;)V

    .line 137
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 139
    :cond_1
    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 144
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 146
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onDestroy()V

    .line 148
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 150
    :cond_0
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onDestroy()V

    .line 152
    return-void
.end method

.method public onLowMemory()V
    .locals 2

    .line 157
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onLowMemory()V

    .line 159
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 161
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onLowMemory()V

    .line 163
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 165
    :cond_0
    return-void
.end method

.method protected onNewIntent(Landroid/content/Intent;)V
    .locals 2
    .param p1, "intent"    # Landroid/content/Intent;

    .line 170
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 172
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1}, Lorg/haxe/extension/Extension;->onNewIntent(Landroid/content/Intent;)V

    .line 174
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 176
    :cond_0
    invoke-super {p0, p1}, Lorg/libsdl/app/SDLActivity;->onNewIntent(Landroid/content/Intent;)V

    .line 178
    return-void
.end method

.method protected onPause()V
    .locals 2

    .line 183
    sget-object v0, Lorg/haxe/lime/GameActivity;->vibrator:Landroid/os/Vibrator;

    if-eqz v0, :cond_0

    .line 185
    invoke-virtual {v0}, Landroid/os/Vibrator;->cancel()V

    .line 189
    :cond_0
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onPause()V

    .line 191
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 193
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onPause()V

    .line 195
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 197
    :cond_1
    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 3
    .param p1, "requestCode"    # I
    .param p2, "permissions"    # [Ljava/lang/String;
    .param p3, "grantResults"    # [I

    .line 203
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 205
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1, p2, p3}, Lorg/haxe/extension/Extension;->onRequestPermissionsResult(I[Ljava/lang/String;[I)Z

    move-result v2

    if-nez v2, :cond_0

    .line 207
    return-void

    .line 211
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    :cond_0
    goto :goto_0

    .line 213
    :cond_1
    invoke-super {p0, p1, p2, p3}, Lorg/libsdl/app/SDLActivity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    .line 215
    return-void
.end method

.method protected onRestart()V
    .locals 2

    .line 221
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onRestart()V

    .line 223
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 225
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onRestart()V

    .line 227
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 229
    :cond_0
    return-void
.end method

.method protected onRestoreInstanceState(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "savedState"    # Landroid/os/Bundle;

    .line 247
    invoke-super {p0, p1}, Lorg/libsdl/app/SDLActivity;->onRestoreInstanceState(Landroid/os/Bundle;)V

    .line 249
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 251
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1}, Lorg/haxe/extension/Extension;->onRestoreInstanceState(Landroid/os/Bundle;)V

    .line 253
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 255
    :cond_0
    return-void
.end method

.method protected onResume()V
    .locals 2

    .line 234
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onResume()V

    .line 236
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 238
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onResume()V

    .line 240
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 242
    :cond_0
    return-void
.end method

.method protected onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "outState"    # Landroid/os/Bundle;

    .line 260
    invoke-super {p0, p1}, Lorg/libsdl/app/SDLActivity;->onSaveInstanceState(Landroid/os/Bundle;)V

    .line 262
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 264
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1}, Lorg/haxe/extension/Extension;->onSaveInstanceState(Landroid/os/Bundle;)V

    .line 266
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 268
    :cond_0
    return-void
.end method

.method protected onStart()V
    .locals 2

    .line 273
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onStart()V

    .line 275
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 277
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onStart()V

    .line 279
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 281
    :cond_0
    return-void
.end method

.method protected onStop()V
    .locals 2

    .line 286
    invoke-super {p0}, Lorg/libsdl/app/SDLActivity;->onStop()V

    .line 288
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 290
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1}, Lorg/haxe/extension/Extension;->onStop()V

    .line 292
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 294
    :cond_0
    return-void
.end method

.method public onTrimMemory(I)V
    .locals 2
    .param p1, "level"    # I

    .line 300
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xe

    if-lt v0, v1, :cond_0

    .line 302
    invoke-super {p0, p1}, Lorg/libsdl/app/SDLActivity;->onTrimMemory(I)V

    .line 304
    sget-object v0, Lorg/haxe/lime/GameActivity;->extensions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/haxe/extension/Extension;

    .line 306
    .local v1, "extension":Lorg/haxe/extension/Extension;
    invoke-virtual {v1, p1}, Lorg/haxe/extension/Extension;->onTrimMemory(I)V

    .line 308
    .end local v1    # "extension":Lorg/haxe/extension/Extension;
    goto :goto_0

    .line 312
    :cond_0
    return-void
.end method
