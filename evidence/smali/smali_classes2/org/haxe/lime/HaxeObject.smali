.class public Lorg/haxe/lime/HaxeObject;
.super Ljava/lang/Object;
.source "HaxeObject.java"


# instance fields
.field public __haxeHandle:J


# direct methods
.method public constructor <init>(J)V
    .locals 0
    .param p1, "value"    # J

    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 69
    iput-wide p1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    .line 70
    return-void
.end method

.method public static create(J)Lorg/haxe/lime/HaxeObject;
    .locals 3
    .param p0, "inHandle"    # J

    .line 74
    const-wide/16 v0, 0x0

    cmp-long v2, p0, v0

    if-nez v2, :cond_0

    .line 75
    const/4 v0, 0x0

    return-object v0

    .line 76
    :cond_0
    new-instance v0, Lorg/haxe/lime/HaxeObject;

    invoke-direct {v0, p0, p1}, Lorg/haxe/lime/HaxeObject;-><init>(J)V

    return-object v0
.end method


# virtual methods
.method public call(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "args"    # [Ljava/lang/Object;

    .line 163
    iget-wide v0, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v0, v1, p1, p2}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method public call0(Ljava/lang/String;)Ljava/lang/Object;
    .locals 3
    .param p1, "function"    # Ljava/lang/String;

    .line 90
    iget-wide v0, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v0, v1, p1, v2}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method public call1(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;

    .line 94
    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    .line 95
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 97
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    return-object v1
.end method

.method public call2(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;
    .param p3, "arg1"    # Ljava/lang/Object;

    .line 101
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 102
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 103
    const/4 v1, 0x1

    aput-object p3, v0, v1

    .line 105
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    return-object v1
.end method

.method public call3(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;
    .param p3, "arg1"    # Ljava/lang/Object;
    .param p4, "arg2"    # Ljava/lang/Object;

    .line 109
    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 110
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 111
    const/4 v1, 0x1

    aput-object p3, v0, v1

    .line 112
    const/4 v1, 0x2

    aput-object p4, v0, v1

    .line 114
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    return-object v1
.end method

.method public call4(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;
    .param p3, "arg1"    # Ljava/lang/Object;
    .param p4, "arg2"    # Ljava/lang/Object;
    .param p5, "arg3"    # Ljava/lang/Object;

    .line 118
    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/Object;

    .line 119
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 120
    const/4 v1, 0x1

    aput-object p3, v0, v1

    .line 121
    const/4 v1, 0x2

    aput-object p4, v0, v1

    .line 122
    const/4 v1, 0x3

    aput-object p5, v0, v1

    .line 124
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callObjectFunction(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    return-object v1
.end method

.method public callD(Ljava/lang/String;[Ljava/lang/Object;)D
    .locals 2
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "args"    # [Ljava/lang/Object;

    .line 167
    iget-wide v0, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v0, v1, p1, p2}, Lorg/haxe/lime/Lime;->callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D

    move-result-wide v0

    return-wide v0
.end method

.method public callD0(Ljava/lang/String;)D
    .locals 3
    .param p1, "function"    # Ljava/lang/String;

    .line 130
    iget-wide v0, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v0, v1, p1, v2}, Lorg/haxe/lime/Lime;->callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D

    move-result-wide v0

    return-wide v0
.end method

.method public callD1(Ljava/lang/String;Ljava/lang/Object;)D
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;

    .line 134
    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    .line 135
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 137
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D

    move-result-wide v1

    return-wide v1
.end method

.method public callD2(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)D
    .locals 3
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;
    .param p3, "arg1"    # Ljava/lang/Object;

    .line 141
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 142
    .local v0, "args":[Ljava/lang/Object;
    const/4 v1, 0x0

    aput-object p2, v0, v1

    .line 143
    const/4 v1, 0x1

    aput-object p3, v0, v1

    .line 145
    iget-wide v1, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v1, v2, p1, v0}, Lorg/haxe/lime/Lime;->callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D

    move-result-wide v1

    return-wide v1
.end method

.method public callD3(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)D
    .locals 4
    .param p1, "function"    # Ljava/lang/String;
    .param p2, "arg0"    # Ljava/lang/Object;
    .param p3, "arg1"    # Ljava/lang/Object;
    .param p4, "arg2"    # Ljava/lang/Object;

    .line 149
    const/4 v0, 0x2

    new-array v1, v0, [Ljava/lang/Object;

    .line 150
    .local v1, "args":[Ljava/lang/Object;
    const/4 v2, 0x0

    aput-object p2, v1, v2

    .line 151
    const/4 v2, 0x1

    aput-object p3, v1, v2

    .line 152
    aput-object p4, v1, v0

    .line 154
    iget-wide v2, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v2, v3, p1, v1}, Lorg/haxe/lime/Lime;->callNumericFunction(JLjava/lang/String;[Ljava/lang/Object;)D

    move-result-wide v2

    return-wide v2
.end method

.method protected finalize()V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    .line 82
    :try_start_0
    iget-wide v0, p0, Lorg/haxe/lime/HaxeObject;->__haxeHandle:J

    invoke-static {v0, v1}, Lorg/haxe/lime/Lime;->releaseReference(J)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 84
    invoke-super {p0}, Ljava/lang/Object;->finalize()V

    .line 85
    nop

    .line 86
    return-void

    .line 84
    :catchall_0
    move-exception v0

    invoke-super {p0}, Ljava/lang/Object;->finalize()V

    .line 85
    throw v0
.end method
