.class public Lorg/haxe/HXCPP;
.super Ljava/lang/Object;
.source "HXCPP.java"


# static fields
.field private static mInit:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 10
    const/4 v0, 0x0

    sput-boolean v0, Lorg/haxe/HXCPP;->mInit:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static native main()V
.end method

.method public static run(Ljava/lang/String;)V
    .locals 1
    .param p0, "inClassName"    # Ljava/lang/String;

    .line 18
    invoke-static {p0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 20
    sget-boolean v0, Lorg/haxe/HXCPP;->mInit:Z

    if-nez v0, :cond_0

    .line 22
    const/4 v0, 0x1

    sput-boolean v0, Lorg/haxe/HXCPP;->mInit:Z

    .line 23
    invoke-static {}, Lorg/haxe/HXCPP;->main()V

    .line 27
    :cond_0
    return-void
.end method
