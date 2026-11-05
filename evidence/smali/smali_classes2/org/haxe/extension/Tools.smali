.class public Lorg/haxe/extension/Tools;
.super Lorg/haxe/extension/Extension;
.source "Tools.java"


# static fields
.field public static final LOG_TAG:Ljava/lang/String; = "Tools"

.field public static gson:Lcom/google/gson/Gson;

.field public static hobject:Lorg/haxe/lime/HaxeObject;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 59
    new-instance v0, Lcom/google/gson/GsonBuilder;

    invoke-direct {v0}, Lcom/google/gson/GsonBuilder;-><init>()V

    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->setPrettyPrinting()Lcom/google/gson/GsonBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->serializeNulls()Lcom/google/gson/GsonBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    move-result-object v0

    sput-object v0, Lorg/haxe/extension/Tools;->gson:Lcom/google/gson/Gson;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Lorg/haxe/extension/Extension;-><init>()V

    return-void
.end method

.method public static disableAppSecure()V
    .locals 2

    .line 119
    sget-object v0, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    new-instance v1, Lorg/haxe/extension/Tools$3;

    invoke-direct {v1}, Lorg/haxe/extension/Tools$3;-><init>()V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 134
    return-void
.end method

.method public static enableAppSecure()V
    .locals 2

    .line 100
    sget-object v0, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    new-instance v1, Lorg/haxe/extension/Tools$2;

    invoke-direct {v1}, Lorg/haxe/extension/Tools$2;-><init>()V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 115
    return-void
.end method

.method public static getBatteryManager()Landroid/os/BatteryManager;
    .locals 2

    .line 279
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    const-string v1, "batterymanager"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/BatteryManager;

    return-object v0
.end method

.method public static getCacheDir()Ljava/io/File;
    .locals 1

    .line 264
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v0

    return-object v0
.end method

.method public static getExternalCacheDir()Ljava/io/File;
    .locals 1

    .line 269
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getExternalCacheDir()Ljava/io/File;

    move-result-object v0

    return-object v0
.end method

.method public static getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;
    .locals 1
    .param p0, "type"    # Ljava/lang/String;

    .line 259
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v0, p0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    return-object v0
.end method

.method public static getFilesDir()Ljava/io/File;
    .locals 1

    .line 254
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    return-object v0
.end method

.method public static getGrantedPermissions()[Ljava/lang/String;
    .locals 4

    .line 63
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 67
    .local v0, "granted":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :try_start_0
    sget-object v1, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    sget-object v2, Lorg/haxe/extension/Tools;->packageName:Ljava/lang/String;

    const/16 v3, 0x1000

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v1

    .line 69
    .local v1, "info":Landroid/content/pm/PackageInfo;
    const/4 v2, 0x0

    .local v2, "i":I
    :goto_0
    iget-object v3, v1, Landroid/content/pm/PackageInfo;->requestedPermissions:[Ljava/lang/String;

    array-length v3, v3

    if-ge v2, v3, :cond_1

    .line 70
    iget-object v3, v1, Landroid/content/pm/PackageInfo;->requestedPermissionsFlags:[I

    aget v3, v3, v2

    and-int/lit8 v3, v3, 0x2

    if-eqz v3, :cond_0

    .line 71
    iget-object v3, v1, Landroid/content/pm/PackageInfo;->requestedPermissions:[Ljava/lang/String;

    aget-object v3, v3, v2

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 69
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 76
    .end local v1    # "info":Landroid/content/pm/PackageInfo;
    .end local v2    # "i":I
    :cond_1
    goto :goto_1

    .line 73
    :catch_0
    move-exception v1

    .line 75
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "Tools"

    invoke-static {v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 78
    .end local v1    # "e":Ljava/lang/Exception;
    :goto_1
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    new-array v1, v1, [Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Ljava/lang/String;

    return-object v1
.end method

.method public static getObbDir()Ljava/io/File;
    .locals 1

    .line 274
    sget-object v0, Lorg/haxe/extension/Tools;->mainContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getObbDir()Ljava/io/File;

    move-result-object v0

    return-object v0
.end method

.method public static initCallBack(Lorg/haxe/lime/HaxeObject;)V
    .locals 0
    .param p0, "hobject"    # Lorg/haxe/lime/HaxeObject;

    .line 284
    sput-object p0, Lorg/haxe/extension/Tools;->hobject:Lorg/haxe/lime/HaxeObject;

    .line 285
    return-void
.end method

.method public static isDolbyAtmos()Z
    .locals 4

    .line 204
    :try_start_0
    new-instance v0, Landroid/media/MediaFormat;

    invoke-direct {v0}, Landroid/media/MediaFormat;-><init>()V

    .line 206
    .local v0, "format":Landroid/media/MediaFormat;
    const-string v1, "mime"

    const-string v2, "audio/eac3-joc"

    invoke-virtual {v0, v1, v2}, Landroid/media/MediaFormat;->setString(Ljava/lang/String;Ljava/lang/String;)V

    .line 208
    new-instance v1, Landroid/media/MediaCodecList;

    const/4 v2, 0x1

    invoke-direct {v1, v2}, Landroid/media/MediaCodecList;-><init>(I)V

    .line 210
    .local v1, "codecList":Landroid/media/MediaCodecList;
    invoke-virtual {v1, v0}, Landroid/media/MediaCodecList;->findDecoderForFormat(Landroid/media/MediaFormat;)Ljava/lang/String;

    move-result-object v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v3, :cond_0

    .line 211
    return v2

    .line 216
    .end local v0    # "format":Landroid/media/MediaFormat;
    .end local v1    # "codecList":Landroid/media/MediaCodecList;
    :cond_0
    goto :goto_0

    .line 213
    :catch_0
    move-exception v0

    .line 215
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 218
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    const/4 v0, 0x0

    return v0
.end method

.method public static isRooted()Z
    .locals 3

    .line 185
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v0

    const-string v1, "su"

    invoke-virtual {v0, v1}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v0

    .line 187
    .local v0, "execute":Ljava/lang/Process;
    invoke-virtual {v0}, Ljava/lang/Process;->waitFor()I

    .line 189
    invoke-virtual {v0}, Ljava/lang/Process;->exitValue()I

    move-result v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/16 v2, 0xff

    if-eq v1, v2, :cond_0

    .line 190
    const/4 v1, 0x1

    return v1

    .line 195
    .end local v0    # "execute":Ljava/lang/Process;
    :cond_0
    goto :goto_0

    .line 192
    :catch_0
    move-exception v0

    .line 194
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 197
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    const/4 v0, 0x0

    return v0
.end method

.method public static launchPackage(Ljava/lang/String;I)V
    .locals 3
    .param p0, "packageName"    # Ljava/lang/String;
    .param p1, "requestCode"    # I

    .line 140
    :try_start_0
    sget-object v0, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    sget-object v1, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {v1, p0}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 145
    goto :goto_0

    .line 142
    :catch_0
    move-exception v0

    .line 144
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method public static makeToastText(Ljava/lang/String;IIII)V
    .locals 8
    .param p0, "message"    # Ljava/lang/String;
    .param p1, "duration"    # I
    .param p2, "gravity"    # I
    .param p3, "xOffset"    # I
    .param p4, "yOffset"    # I

    .line 83
    sget-object v0, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    new-instance v7, Lorg/haxe/extension/Tools$1;

    move-object v1, v7

    move-object v2, p0

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    invoke-direct/range {v1 .. v6}, Lorg/haxe/extension/Tools$1;-><init>(Ljava/lang/String;IIII)V

    invoke-virtual {v0, v7}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 96
    return-void
.end method

.method public static openFileBrowser(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 3
    .param p0, "action"    # Ljava/lang/String;
    .param p1, "type"    # Ljava/lang/String;
    .param p2, "requestCode"    # I

    .line 152
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, p0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 153
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "android.intent.category.OPENABLE"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 154
    if-eqz p1, :cond_0

    move-object v1, p1

    goto :goto_0

    :cond_0
    const-string v1, "*/*"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 156
    sget-object v1, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    const/4 v2, 0x0

    invoke-static {v0, v2}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object v2

    invoke-virtual {v1, v2, p2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 161
    .end local v0    # "intent":Landroid/content/Intent;
    goto :goto_1

    .line 158
    :catch_0
    move-exception v0

    .line 160
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 162
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_1
    return-void
.end method

.method public static requestSetting(Ljava/lang/String;I)V
    .locals 4
    .param p0, "setting"    # Ljava/lang/String;
    .param p1, "requestCode"    # I

    .line 168
    :try_start_0
    const-string v0, "android.settings."

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 170
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, p0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 171
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "package"

    sget-object v2, Lorg/haxe/extension/Tools;->packageName:Ljava/lang/String;

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Landroid/net/Uri;->fromParts(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 172
    sget-object v1, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    invoke-virtual {v1, v0, p1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 178
    .end local v0    # "intent":Landroid/content/Intent;
    :cond_0
    goto :goto_0

    .line 175
    :catch_0
    move-exception v0

    .line 177
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Tools"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 179
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method public static showNotification(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 8
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "message"    # Ljava/lang/String;
    .param p2, "channelID"    # Ljava/lang/String;
    .param p3, "channelName"    # Ljava/lang/String;
    .param p4, "ID"    # I

    .line 223
    sget-object v0, Lorg/haxe/extension/Tools;->mainActivity:Landroid/app/Activity;

    new-instance v7, Lorg/haxe/extension/Tools$4;

    move-object v1, v7

    move-object v2, p2

    move-object v3, p3

    move-object v4, p0

    move-object v5, p1

    move v6, p4

    invoke-direct/range {v1 .. v6}, Lorg/haxe/extension/Tools$4;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    invoke-virtual {v0, v7}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 250
    return-void
.end method


# virtual methods
.method public onActivityResult(IILandroid/content/Intent;)Z
    .locals 6
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 295
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    .line 297
    .local v0, "content":Landroid/util/ArrayMap;, "Landroid/util/ArrayMap<Ljava/lang/String;Ljava/lang/Object;>;"
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "requestCode"

    invoke-virtual {v0, v2, v1}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 298
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "resultCode"

    invoke-virtual {v0, v2, v1}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 300
    if-eqz p3, :cond_0

    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 302
    new-instance v1, Landroid/util/ArrayMap;

    invoke-direct {v1}, Landroid/util/ArrayMap;-><init>()V

    .line 304
    .local v1, "d":Landroid/util/ArrayMap;, "Landroid/util/ArrayMap<Ljava/lang/String;Ljava/lang/Object;>;"
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {v2}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "uri"

    invoke-virtual {v1, v3, v2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 305
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {v2}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    move-result-object v2

    const-string v3, "path"

    invoke-virtual {v1, v3, v2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 307
    const-string v2, "data"

    invoke-virtual {v0, v2, v1}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 310
    .end local v1    # "d":Landroid/util/ArrayMap;, "Landroid/util/ArrayMap<Ljava/lang/String;Ljava/lang/Object;>;"
    :cond_0
    sget-object v1, Lorg/haxe/extension/Tools;->hobject:Lorg/haxe/lime/HaxeObject;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    .line 312
    new-array v3, v2, [Ljava/lang/Object;

    const/4 v4, 0x0

    sget-object v5, Lorg/haxe/extension/Tools;->gson:Lcom/google/gson/Gson;

    .line 313
    invoke-virtual {v5, v0}, Lcom/google/gson/Gson;->toJson(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v3, v4

    .line 312
    const-string v4, "onActivityResult"

    invoke-virtual {v1, v4, v3}, Lorg/haxe/lime/HaxeObject;->call(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 317
    :cond_1
    return v2
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)Z
    .locals 6
    .param p1, "requestCode"    # I
    .param p2, "permissions"    # [Ljava/lang/String;
    .param p3, "grantResults"    # [I

    .line 326
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    .line 328
    .local v0, "content":Landroid/util/ArrayMap;, "Landroid/util/ArrayMap<Ljava/lang/String;Ljava/lang/Object;>;"
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "requestCode"

    invoke-virtual {v0, v2, v1}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 329
    const-string v1, "permissions"

    invoke-virtual {v0, v1, p2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 330
    const-string v1, "grantResults"

    invoke-virtual {v0, v1, p3}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 332
    sget-object v1, Lorg/haxe/extension/Tools;->hobject:Lorg/haxe/lime/HaxeObject;

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    .line 334
    new-array v3, v2, [Ljava/lang/Object;

    const/4 v4, 0x0

    sget-object v5, Lorg/haxe/extension/Tools;->gson:Lcom/google/gson/Gson;

    .line 335
    invoke-virtual {v5, v0}, Lcom/google/gson/Gson;->toJson(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v3, v4

    .line 334
    const-string v4, "onRequestPermissionsResult"

    invoke-virtual {v1, v4, v3}, Lorg/haxe/lime/HaxeObject;->call(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 339
    :cond_0
    return v2
.end method
