.class public Lcom/shadowmario/psychengine/MemoryInfoHelper;
.super Ljava/lang/Object;
.source "MemoryInfoHelper.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static activityManager()Landroid/app/ActivityManager;
    .locals 3

    .line 68
    sget-object v0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 70
    .local v0, "context":Landroid/content/Context;
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 71
    return-object v1

    .line 75
    :cond_0
    :try_start_0
    const-string v2, "activity"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/app/ActivityManager;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v2

    .line 77
    :catchall_0
    move-exception v2

    .line 79
    .local v2, "e":Ljava/lang/Throwable;
    return-object v1
.end method

.method public static getAvailableRamMB()D
    .locals 6

    .line 168
    invoke-static {}, Lcom/shadowmario/psychengine/MemoryInfoHelper;->activityManager()Landroid/app/ActivityManager;

    move-result-object v0

    .line 170
    .local v0, "manager":Landroid/app/ActivityManager;
    const-wide/high16 v1, -0x4010000000000000L    # -1.0

    if-nez v0, :cond_0

    .line 171
    return-wide v1

    .line 175
    :cond_0
    :try_start_0
    new-instance v3, Landroid/app/ActivityManager$MemoryInfo;

    invoke-direct {v3}, Landroid/app/ActivityManager$MemoryInfo;-><init>()V

    .line 176
    .local v3, "info":Landroid/app/ActivityManager$MemoryInfo;
    invoke-virtual {v0, v3}, Landroid/app/ActivityManager;->getMemoryInfo(Landroid/app/ActivityManager$MemoryInfo;)V

    .line 177
    iget-wide v1, v3, Landroid/app/ActivityManager$MemoryInfo;->availMem:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    long-to-double v1, v1

    const-wide/high16 v4, 0x4130000000000000L    # 1048576.0

    div-double/2addr v1, v4

    return-wide v1

    .line 179
    .end local v3    # "info":Landroid/app/ActivityManager$MemoryInfo;
    :catchall_0
    move-exception v3

    .line 181
    .local v3, "e":Ljava/lang/Throwable;
    return-wide v1
.end method

.method public static getPrivateDirtyMB()D
    .locals 8

    .line 112
    invoke-static {}, Lcom/shadowmario/psychengine/MemoryInfoHelper;->processMemoryInfo()Landroid/os/Debug$MemoryInfo;

    move-result-object v0

    .line 114
    .local v0, "info":Landroid/os/Debug$MemoryInfo;
    const-wide/high16 v1, 0x4090000000000000L    # 1024.0

    if-eqz v0, :cond_1

    .line 118
    :try_start_0
    invoke-virtual {v0}, Landroid/os/Debug$MemoryInfo;->getTotalPrivateDirty()I

    move-result v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 120
    .local v3, "kb":I
    if-lez v3, :cond_0

    .line 121
    int-to-double v4, v3

    div-double/2addr v4, v1

    return-wide v4

    .line 125
    .end local v3    # "kb":I
    :cond_0
    goto :goto_0

    .line 123
    :catchall_0
    move-exception v3

    .line 133
    :cond_1
    :goto_0
    :try_start_1
    invoke-static {}, Landroid/os/Debug;->getPss()J

    move-result-wide v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 135
    .local v3, "kb":J
    const-wide/16 v5, 0x0

    cmp-long v7, v3, v5

    if-lez v7, :cond_2

    .line 136
    long-to-double v5, v3

    div-double/2addr v5, v1

    return-wide v5

    .line 140
    .end local v3    # "kb":J
    :cond_2
    goto :goto_1

    .line 138
    :catchall_1
    move-exception v1

    .line 142
    :goto_1
    const-wide/high16 v1, -0x4010000000000000L    # -1.0

    return-wide v1
.end method

.method public static getPssMB()D
    .locals 5

    .line 90
    invoke-static {}, Lcom/shadowmario/psychengine/MemoryInfoHelper;->processMemoryInfo()Landroid/os/Debug$MemoryInfo;

    move-result-object v0

    .line 92
    .local v0, "info":Landroid/os/Debug$MemoryInfo;
    const-wide/high16 v1, -0x4010000000000000L    # -1.0

    if-nez v0, :cond_0

    .line 93
    return-wide v1

    .line 97
    :cond_0
    :try_start_0
    invoke-virtual {v0}, Landroid/os/Debug$MemoryInfo;->getTotalPss()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    int-to-double v1, v1

    const-wide/high16 v3, 0x4090000000000000L    # 1024.0

    div-double/2addr v1, v3

    return-wide v1

    .line 99
    :catchall_0
    move-exception v3

    .line 101
    .local v3, "e":Ljava/lang/Throwable;
    return-wide v1
.end method

.method public static getTotalRamMB()D
    .locals 6

    .line 148
    invoke-static {}, Lcom/shadowmario/psychengine/MemoryInfoHelper;->activityManager()Landroid/app/ActivityManager;

    move-result-object v0

    .line 150
    .local v0, "manager":Landroid/app/ActivityManager;
    const-wide/high16 v1, -0x4010000000000000L    # -1.0

    if-nez v0, :cond_0

    .line 151
    return-wide v1

    .line 155
    :cond_0
    :try_start_0
    new-instance v3, Landroid/app/ActivityManager$MemoryInfo;

    invoke-direct {v3}, Landroid/app/ActivityManager$MemoryInfo;-><init>()V

    .line 156
    .local v3, "info":Landroid/app/ActivityManager$MemoryInfo;
    invoke-virtual {v0, v3}, Landroid/app/ActivityManager;->getMemoryInfo(Landroid/app/ActivityManager$MemoryInfo;)V

    .line 157
    iget-wide v1, v3, Landroid/app/ActivityManager$MemoryInfo;->totalMem:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    long-to-double v1, v1

    const-wide/high16 v4, 0x4130000000000000L    # 1048576.0

    div-double/2addr v1, v4

    return-wide v1

    .line 159
    .end local v3    # "info":Landroid/app/ActivityManager$MemoryInfo;
    :catchall_0
    move-exception v3

    .line 161
    .local v3, "e":Ljava/lang/Throwable;
    return-wide v1
.end method

.method private static processMemoryInfo()Landroid/os/Debug$MemoryInfo;
    .locals 5

    .line 31
    sget-object v0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 33
    .local v0, "context":Landroid/content/Context;
    if-eqz v0, :cond_1

    .line 37
    :try_start_0
    const-string v1, "activity"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/ActivityManager;

    .line 39
    .local v1, "manager":Landroid/app/ActivityManager;
    if-eqz v1, :cond_0

    .line 41
    const/4 v2, 0x1

    new-array v2, v2, [I

    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v3

    const/4 v4, 0x0

    aput v3, v2, v4

    invoke-virtual {v1, v2}, Landroid/app/ActivityManager;->getProcessMemoryInfo([I)[Landroid/os/Debug$MemoryInfo;

    move-result-object v2

    .line 43
    .local v2, "info":[Landroid/os/Debug$MemoryInfo;
    if-eqz v2, :cond_0

    array-length v3, v2

    if-lez v3, :cond_0

    .line 44
    aget-object v3, v2, v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v3

    .line 49
    .end local v1    # "manager":Landroid/app/ActivityManager;
    .end local v2    # "info":[Landroid/os/Debug$MemoryInfo;
    :cond_0
    goto :goto_0

    .line 47
    :catchall_0
    move-exception v1

    .line 56
    :cond_1
    :goto_0
    :try_start_1
    new-instance v1, Landroid/os/Debug$MemoryInfo;

    invoke-direct {v1}, Landroid/os/Debug$MemoryInfo;-><init>()V

    .line 57
    .local v1, "info":Landroid/os/Debug$MemoryInfo;
    invoke-static {v1}, Landroid/os/Debug;->getMemoryInfo(Landroid/os/Debug$MemoryInfo;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 58
    return-object v1

    .line 60
    .end local v1    # "info":Landroid/os/Debug$MemoryInfo;
    :catchall_1
    move-exception v1

    .line 62
    .local v1, "e":Ljava/lang/Throwable;
    const/4 v2, 0x0

    return-object v2
.end method
