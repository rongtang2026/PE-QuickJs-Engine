.class public Lorg/libsdl/app/SDL;
.super Ljava/lang/Object;
.source "SDL.java"


# static fields
.field protected static mContext:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .line 35
    sget-object v0, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    return-object v0
.end method

.method public static initialize()V
    .locals 1

    .line 22
    const/4 v0, 0x0

    invoke-static {v0}, Lorg/libsdl/app/SDL;->setContext(Landroid/content/Context;)V

    .line 24
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->initialize()V

    .line 25
    invoke-static {}, Lorg/libsdl/app/SDLAudioManager;->initialize()V

    .line 26
    invoke-static {}, Lorg/libsdl/app/SDLControllerManager;->initialize()V

    .line 27
    return-void
.end method

.method public static loadLibrary(Ljava/lang/String;)V
    .locals 15
    .param p0, "libraryName"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/UnsatisfiedLinkError;,
            Ljava/lang/SecurityException;,
            Ljava/lang/NullPointerException;
        }
    .end annotation

    .line 40
    if-eqz p0, :cond_0

    .line 54
    :try_start_0
    sget-object v0, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const-string v1, "com.getkeepsafe.relinker.ReLinker"

    invoke-virtual {v0, v1}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 55
    .local v0, "relinkClass":Ljava/lang/Class;
    sget-object v1, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "com.getkeepsafe.relinker.ReLinker$LoadListener"

    invoke-virtual {v1, v2}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 56
    .local v1, "relinkListenerClass":Ljava/lang/Class;
    sget-object v2, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "android.content.Context"

    invoke-virtual {v2, v3}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    .line 57
    .local v2, "contextClass":Ljava/lang/Class;
    sget-object v3, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v3

    const-string v4, "java.lang.String"

    invoke-virtual {v3, v4}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    .line 61
    .local v3, "stringClass":Ljava/lang/Class;
    const-string v4, "force"

    const/4 v5, 0x0

    new-array v6, v5, [Ljava/lang/Class;

    invoke-virtual {v0, v4, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    .line 62
    .local v4, "forceMethod":Ljava/lang/reflect/Method;
    new-array v6, v5, [Ljava/lang/Object;

    const/4 v7, 0x0

    invoke-virtual {v4, v7, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    .line 63
    .local v6, "relinkInstance":Ljava/lang/Object;
    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v8

    .line 66
    .local v8, "relinkInstanceClass":Ljava/lang/Class;
    const-string v9, "loadLibrary"

    const/4 v10, 0x4

    new-array v11, v10, [Ljava/lang/Class;

    aput-object v2, v11, v5

    const/4 v12, 0x1

    aput-object v3, v11, v12

    const/4 v13, 0x2

    aput-object v3, v11, v13

    const/4 v14, 0x3

    aput-object v1, v11, v14

    invoke-virtual {v8, v9, v11}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v9

    .line 67
    .local v9, "loadMethod":Ljava/lang/reflect/Method;
    new-array v10, v10, [Ljava/lang/Object;

    sget-object v11, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    aput-object v11, v10, v5

    aput-object p0, v10, v12

    aput-object v7, v10, v13

    aput-object v7, v10, v14

    invoke-virtual {v9, v6, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 80
    nop

    .end local v0    # "relinkClass":Ljava/lang/Class;
    .end local v1    # "relinkListenerClass":Ljava/lang/Class;
    .end local v2    # "contextClass":Ljava/lang/Class;
    .end local v3    # "stringClass":Ljava/lang/Class;
    .end local v4    # "forceMethod":Ljava/lang/reflect/Method;
    .end local v6    # "relinkInstance":Ljava/lang/Object;
    .end local v8    # "relinkInstanceClass":Ljava/lang/Class;
    .end local v9    # "loadMethod":Ljava/lang/reflect/Method;
    goto :goto_0

    .line 69
    :catchall_0
    move-exception v0

    .line 72
    .local v0, "e":Ljava/lang/Throwable;
    :try_start_1
    invoke-static {p0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/UnsatisfiedLinkError; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/SecurityException; {:try_start_1 .. :try_end_1} :catch_0

    .line 79
    nop

    .line 81
    .end local v0    # "e":Ljava/lang/Throwable;
    :goto_0
    return-void

    .line 77
    .restart local v0    # "e":Ljava/lang/Throwable;
    :catch_0
    move-exception v1

    .line 78
    .local v1, "se":Ljava/lang/SecurityException;
    throw v1

    .line 74
    .end local v1    # "se":Ljava/lang/SecurityException;
    :catch_1
    move-exception v1

    .line 75
    .local v1, "ule":Ljava/lang/UnsatisfiedLinkError;
    throw v1

    .line 41
    .end local v0    # "e":Ljava/lang/Throwable;
    .end local v1    # "ule":Ljava/lang/UnsatisfiedLinkError;
    :cond_0
    new-instance v0, Ljava/lang/NullPointerException;

    const-string v1, "No library name provided."

    invoke-direct {v0, v1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public static setContext(Landroid/content/Context;)V
    .locals 0
    .param p0, "context"    # Landroid/content/Context;

    .line 31
    sput-object p0, Lorg/libsdl/app/SDL;->mContext:Landroid/content/Context;

    .line 32
    return-void
.end method

.method public static setupJNI()V
    .locals 0

    .line 15
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativeSetupJNI()I

    .line 16
    invoke-static {}, Lorg/libsdl/app/SDLAudioManager;->nativeSetupJNI()I

    .line 17
    invoke-static {}, Lorg/libsdl/app/SDLControllerManager;->nativeSetupJNI()I

    .line 18
    return-void
.end method
