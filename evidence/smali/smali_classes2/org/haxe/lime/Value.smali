.class public Lorg/haxe/lime/Value;
.super Ljava/lang/Object;
.source "Value.java"


# instance fields
.field mValue:D


# direct methods
.method public constructor <init>(C)V
    .locals 2
    .param p1, "inValue"    # C

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    int-to-double v0, p1

    iput-wide v0, p0, Lorg/haxe/lime/Value;->mValue:D

    return-void
.end method

.method public constructor <init>(D)V
    .locals 0
    .param p1, "inValue"    # D

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-wide p1, p0, Lorg/haxe/lime/Value;->mValue:D

    return-void
.end method

.method public constructor <init>(I)V
    .locals 2
    .param p1, "inValue"    # I

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    int-to-double v0, p1

    iput-wide v0, p0, Lorg/haxe/lime/Value;->mValue:D

    return-void
.end method

.method public constructor <init>(S)V
    .locals 2
    .param p1, "inValue"    # S

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    int-to-double v0, p1

    iput-wide v0, p0, Lorg/haxe/lime/Value;->mValue:D

    return-void
.end method

.method public constructor <init>(Z)V
    .locals 2
    .param p1, "inValue"    # Z

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-eqz p1, :cond_0

    const-wide/high16 v0, 0x3ff0000000000000L    # 1.0

    goto :goto_0

    :cond_0
    const-wide/16 v0, 0x0

    :goto_0
    iput-wide v0, p0, Lorg/haxe/lime/Value;->mValue:D

    return-void
.end method


# virtual methods
.method public getDouble()D
    .locals 2

    .line 15
    iget-wide v0, p0, Lorg/haxe/lime/Value;->mValue:D

    return-wide v0
.end method
