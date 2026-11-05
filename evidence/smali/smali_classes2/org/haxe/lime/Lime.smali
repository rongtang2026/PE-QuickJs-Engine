.class public Lorg/haxe/lime/Lime;
.super Ljava/lang/Object;
.source "Lime.java"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 8
    const-string v0, "lime"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 10
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static native callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D
.end method

.method public static native callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
.end method

.method public static native onCallback(J)V
.end method

.method public static native releaseReference(J)V
.end method
