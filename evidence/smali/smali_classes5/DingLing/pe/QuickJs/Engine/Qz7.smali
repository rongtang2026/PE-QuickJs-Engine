.class public LDingLing/pe/QuickJs/Engine/Qz7;
.super Ljava/lang/Object;
.source "Qz7.java"


# static fields
.field private static c:[B


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(I)I
    .locals 4
    .param p0, "k"    # I

    .line 66
    invoke-static {}, LDingLing/pe/QuickJs/Engine/Qz7;->v()[B

    move-result-object v0

    .line 68
    .local v0, "d":[B
    if-eqz v0, :cond_1

    array-length v1, v0

    const/16 v2, 0x20

    if-lt v1, v2, :cond_1

    if-ltz p0, :cond_1

    const/4 v1, 0x7

    if-le p0, v1, :cond_0

    goto :goto_0

    .line 70
    :cond_0
    mul-int/lit8 v1, p0, 0x4

    .line 71
    .local v1, "o":I
    aget-byte v2, v0, v1

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x18

    add-int/lit8 v3, v1, 0x1

    aget-byte v3, v0, v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x10

    or-int/2addr v2, v3

    add-int/lit8 v3, v1, 0x2

    aget-byte v3, v0, v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v2, v3

    add-int/lit8 v3, v1, 0x3

    aget-byte v3, v0, v3

    and-int/lit16 v3, v3, 0xff

    or-int/2addr v2, v3

    return v2

    .line 68
    .end local v1    # "o":I
    :cond_1
    :goto_0
    const/4 v1, 0x0

    return v1
.end method

.method public static b()I
    .locals 7

    .line 79
    const/4 v0, 0x0

    :try_start_0
    sget-object v1, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 80
    .local v1, "x":Landroid/content/Context;
    if-nez v1, :cond_0

    return v0

    .line 82
    :cond_0
    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v2

    .line 83
    .local v2, "m":Landroid/content/pm/PackageManager;
    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    .line 85
    .local v3, "p":Ljava/lang/String;
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x1c

    if-lt v4, v5, :cond_5

    .line 87
    const/high16 v4, 0x8000000

    invoke-virtual {v2, v3, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v4

    .line 88
    .local v4, "i":Landroid/content/pm/PackageInfo;
    if-nez v4, :cond_1

    const/4 v5, 0x0

    goto :goto_0

    :cond_1
    iget-object v5, v4, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    .line 89
    .local v5, "g":Landroid/content/pm/SigningInfo;
    :goto_0
    if-nez v5, :cond_2

    return v0

    .line 91
    :cond_2
    invoke-virtual {v5}, Landroid/content/pm/SigningInfo;->hasMultipleSigners()Z

    move-result v6

    if-eqz v6, :cond_3

    invoke-virtual {v5}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object v6

    goto :goto_1

    :cond_3
    invoke-virtual {v5}, Landroid/content/pm/SigningInfo;->getSigningCertificateHistory()[Landroid/content/pm/Signature;

    move-result-object v6

    .line 92
    .local v6, "a":[Landroid/content/pm/Signature;
    :goto_1
    if-nez v6, :cond_4

    goto :goto_2

    :cond_4
    array-length v0, v6

    :goto_2
    return v0

    .line 95
    .end local v4    # "i":Landroid/content/pm/PackageInfo;
    .end local v5    # "g":Landroid/content/pm/SigningInfo;
    .end local v6    # "a":[Landroid/content/pm/Signature;
    :cond_5
    const/16 v4, 0x40

    invoke-virtual {v2, v3, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v4

    .line 96
    .restart local v4    # "i":Landroid/content/pm/PackageInfo;
    if-eqz v4, :cond_7

    iget-object v5, v4, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    if-nez v5, :cond_6

    goto :goto_3

    :cond_6
    iget-object v5, v4, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    array-length v0, v5
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_7
    :goto_3
    return v0

    .line 98
    .end local v1    # "x":Landroid/content/Context;
    .end local v2    # "m":Landroid/content/pm/PackageManager;
    .end local v3    # "p":Ljava/lang/String;
    .end local v4    # "i":Landroid/content/pm/PackageInfo;
    :catchall_0
    move-exception v1

    .line 100
    .local v1, "t":Ljava/lang/Throwable;
    return v0
.end method

.method public static c()I
    .locals 3

    .line 109
    const/4 v0, -0x1

    :try_start_0
    sget-object v1, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 110
    .local v1, "x":Landroid/content/Context;
    if-nez v1, :cond_0

    return v0

    .line 112
    :cond_0
    invoke-virtual {v1}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v2

    iget v0, v2, Landroid/content/pm/ApplicationInfo;->flags:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    and-int/lit8 v0, v0, 0x2

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    return v0

    .line 114
    .end local v1    # "x":Landroid/content/Context;
    :catchall_0
    move-exception v1

    .line 116
    .local v1, "t":Ljava/lang/Throwable;
    return v0
.end method

.method public static d()I
    .locals 16

    .line 152
    const-string v0, ".dex"

    const-string v1, "classes"

    const/4 v2, 0x0

    .line 156
    .local v2, "r":I
    const/4 v3, 0x0

    :try_start_0
    sget-object v4, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 157
    .local v4, "x":Landroid/content/Context;
    if-nez v4, :cond_0

    return v3

    .line 159
    :cond_0
    new-instance v5, Ljava/util/zip/ZipFile;

    invoke-virtual {v4}, Landroid/content/Context;->getPackageCodePath()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/util/zip/ZipFile;-><init>(Ljava/lang/String;)V

    .line 160
    .local v5, "z":Ljava/util/zip/ZipFile;
    const/4 v6, 0x0

    .line 161
    .local v6, "hasMainDex":Z
    const/4 v7, 0x0

    .line 162
    .local v7, "dexCount":I
    const/4 v8, 0x0

    .line 164
    .local v8, "dexMax":I
    invoke-virtual {v5}, Ljava/util/zip/ZipFile;->entries()Ljava/util/Enumeration;

    move-result-object v9

    .line 166
    .local v9, "en":Ljava/util/Enumeration;, "Ljava/util/Enumeration<+Ljava/util/zip/ZipEntry;>;"
    :cond_1
    :goto_0
    invoke-interface {v9}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v10

    const/4 v11, 0x1

    if-eqz v10, :cond_a

    .line 168
    invoke-interface {v9}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/util/zip/ZipEntry;

    .line 169
    .local v10, "e":Ljava/util/zip/ZipEntry;
    invoke-virtual {v10}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;

    move-result-object v12

    .line 171
    .local v12, "n":Ljava/lang/String;
    const-string v13, "assets/"

    invoke-virtual {v12, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_2

    goto :goto_0

    .line 173
    :cond_2
    invoke-virtual {v12, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_6

    invoke-virtual {v12, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_6

    .line 175
    add-int/lit8 v7, v7, 0x1

    .line 176
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v13

    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v14

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v15

    sub-int/2addr v14, v15

    invoke-virtual {v12, v13, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v13

    .line 178
    .local v13, "mid":Ljava/lang/String;
    invoke-virtual {v13}, Ljava/lang/String;->length()I

    move-result v14
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ge v14, v11, :cond_3

    .line 180
    const/4 v6, 0x1

    goto :goto_0

    .line 186
    :cond_3
    :try_start_1
    invoke-static {v13}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 187
    .local v11, "idx":I
    const/4 v14, 0x2

    if-ge v11, v14, :cond_4

    or-int/lit8 v2, v2, 0x1

    .line 188
    :cond_4
    if-le v11, v8, :cond_5

    move v8, v11

    .line 193
    .end local v11    # "idx":I
    :cond_5
    goto :goto_0

    .line 190
    :catch_0
    move-exception v11

    .line 192
    .local v11, "bad":Ljava/lang/NumberFormatException;
    or-int/lit8 v2, v2, 0x1

    .line 195
    .end local v11    # "bad":Ljava/lang/NumberFormatException;
    goto :goto_0

    .line 198
    .end local v13    # "mid":Ljava/lang/String;
    :cond_6
    :try_start_2
    const-string v11, "lib/"

    invoke-virtual {v12, v11}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_7

    invoke-static {v12}, LDingLing/pe/QuickJs/Engine/Qz7;->okSo(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_1

    or-int/lit8 v2, v2, 0x2

    goto :goto_0

    .line 199
    :cond_7
    const-string v11, "res/"

    invoke-virtual {v12, v11}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_1

    const-string v11, "META-INF/"

    invoke-virtual {v12, v11}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_1

    const-string v11, "kotlin/"

    invoke-virtual {v12, v11}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_8

    goto :goto_0

    .line 200
    :cond_8
    const/16 v11, 0x2f

    invoke-virtual {v12, v11}, Ljava/lang/String;->indexOf(I)I

    move-result v11

    if-gez v11, :cond_9

    invoke-static {v12}, LDingLing/pe/QuickJs/Engine/Qz7;->okRoot(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_9

    goto/16 :goto_0

    .line 202
    :cond_9
    or-int/lit8 v2, v2, 0x4

    .line 203
    .end local v10    # "e":Ljava/util/zip/ZipEntry;
    .end local v12    # "n":Ljava/lang/String;
    goto/16 :goto_0

    .line 205
    :cond_a
    invoke-virtual {v5}, Ljava/util/zip/ZipFile;->close()V

    .line 208
    if-nez v6, :cond_b

    or-int/lit8 v0, v2, 0x1

    move v2, v0

    .line 209
    :cond_b
    invoke-static {v11, v8}, Ljava/lang/Math;->max(II)I

    move-result v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eq v7, v0, :cond_c

    or-int/lit8 v2, v2, 0x1

    .line 214
    .end local v4    # "x":Landroid/content/Context;
    .end local v5    # "z":Ljava/util/zip/ZipFile;
    .end local v6    # "hasMainDex":Z
    .end local v7    # "dexCount":I
    .end local v8    # "dexMax":I
    .end local v9    # "en":Ljava/util/Enumeration;, "Ljava/util/Enumeration<+Ljava/util/zip/ZipEntry;>;"
    :cond_c
    nop

    .line 216
    return v2

    .line 211
    :catchall_0
    move-exception v0

    .line 213
    .local v0, "t":Ljava/lang/Throwable;
    return v3
.end method

.method private static okRoot(Ljava/lang/String;)Z
    .locals 1
    .param p0, "n"    # Ljava/lang/String;

    .line 132
    const-string v0, "AndroidManifest.xml"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "resources.arsc"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "DebugProbesKt.bin"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method private static okSo(Ljava/lang/String;)Z
    .locals 4
    .param p0, "n"    # Ljava/lang/String;

    .line 122
    const/16 v0, 0x2f

    invoke-virtual {p0, v0}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v0

    .line 123
    .local v0, "i":I
    const/4 v1, 0x0

    if-gez v0, :cond_0

    return v1

    .line 125
    :cond_0
    add-int/lit8 v2, v0, 0x1

    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 126
    .local v2, "b":Ljava/lang/String;
    const-string v3, "libApplicationMain.so"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    const-string v3, "libc++_shared.so"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    .line 127
    const-string v3, "liblime.so"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    const-string v3, "libvlc.so"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    :cond_1
    const/4 v1, 0x1

    .line 126
    :cond_2
    return v1
.end method

.method private static v()[B
    .locals 8

    .line 27
    sget-object v0, LDingLing/pe/QuickJs/Engine/Qz7;->c:[B

    if-eqz v0, :cond_0

    return-object v0

    .line 31
    :cond_0
    const/4 v0, 0x0

    :try_start_0
    sget-object v1, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    .line 32
    .local v1, "x":Landroid/content/Context;
    if-nez v1, :cond_1

    return-object v0

    .line 34
    :cond_1
    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v2

    .line 35
    .local v2, "m":Landroid/content/pm/PackageManager;
    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    .line 36
    .local v3, "p":Ljava/lang/String;
    const/4 v4, 0x0

    .line 38
    .local v4, "a":[Landroid/content/pm/Signature;
    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v6, 0x1c

    if-lt v5, v6, :cond_5

    .line 40
    const/high16 v5, 0x8000000

    invoke-virtual {v2, v3, v5}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v5

    .line 41
    .local v5, "i":Landroid/content/pm/PackageInfo;
    if-nez v5, :cond_2

    move-object v6, v0

    goto :goto_0

    :cond_2
    iget-object v6, v5, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    .line 43
    .local v6, "g":Landroid/content/pm/SigningInfo;
    :goto_0
    if-eqz v6, :cond_4

    .line 44
    invoke-virtual {v6}, Landroid/content/pm/SigningInfo;->hasMultipleSigners()Z

    move-result v7

    if-eqz v7, :cond_3

    invoke-virtual {v6}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object v7

    goto :goto_1

    :cond_3
    invoke-virtual {v6}, Landroid/content/pm/SigningInfo;->getSigningCertificateHistory()[Landroid/content/pm/Signature;

    move-result-object v7

    :goto_1
    move-object v4, v7

    .line 45
    .end local v5    # "i":Landroid/content/pm/PackageInfo;
    .end local v6    # "g":Landroid/content/pm/SigningInfo;
    :cond_4
    goto :goto_3

    .line 48
    :cond_5
    const/16 v5, 0x40

    invoke-virtual {v2, v3, v5}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v5

    .line 49
    .restart local v5    # "i":Landroid/content/pm/PackageInfo;
    if-nez v5, :cond_6

    move-object v6, v0

    goto :goto_2

    :cond_6
    iget-object v6, v5, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    :goto_2
    move-object v4, v6

    .line 52
    .end local v5    # "i":Landroid/content/pm/PackageInfo;
    :goto_3
    if-eqz v4, :cond_8

    array-length v5, v4

    const/4 v6, 0x1

    if-ge v5, v6, :cond_7

    goto :goto_4

    .line 54
    :cond_7
    const-string v5, "SHA-256"

    invoke-static {v5}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v5

    const/4 v6, 0x0

    aget-object v6, v4, v6

    invoke-virtual {v6}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v5

    sput-object v5, LDingLing/pe/QuickJs/Engine/Qz7;->c:[B
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 55
    return-object v5

    .line 52
    :cond_8
    :goto_4
    return-object v0

    .line 57
    .end local v1    # "x":Landroid/content/Context;
    .end local v2    # "m":Landroid/content/pm/PackageManager;
    .end local v3    # "p":Ljava/lang/String;
    .end local v4    # "a":[Landroid/content/pm/Signature;
    :catchall_0
    move-exception v1

    .line 59
    .local v1, "t":Ljava/lang/Throwable;
    return-object v0
.end method
