.class public final Lcom/shadowmario/psychengine/VulkanSurfaceHelper;
.super Ljava/lang/Object;
.source "VulkanSurfaceHelper.java"


# static fields
.field private static final HUD_LINES:I = 0x3

.field private static final HUD_SLOT_BASE:I = 0x30

.field private static final OFFSCREEN:F = 20000.0f

.field private static final TAG:Ljava/lang/String; = "PsyVK"

.field private static final TEXT_REQ_PATH:Ljava/lang/String; = "/storage/emulated/0/Android/data/com.shadowmario.psychengine/files/vk_text.txt"

.field private static final TEXT_SLOT_BASE:I = 0x34

.field private static final TEX_REQ_PATH:Ljava/lang/String; = "/storage/emulated/0/Android/data/com.shadowmario.psychengine/files/vk_tex.txt"

.field private static attempt:I

.field private static created:Z

.field private static final hudCache:[Ljava/lang/String;

.field private static hudLoopStarted:Z

.field private static lastError:Ljava/lang/String;

.field private static lastHeight:I

.field private static lastWidth:I

.field private static stage:Ljava/lang/String;

.field private static final textCache:[Ljava/lang/String;

.field private static final textH:[I

.field private static final textW:[I

.field private static textureSent:Z

.field private static view:Landroid/view/SurfaceView;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 42
    const/4 v0, 0x0

    sput-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 43
    const/4 v0, 0x0

    sput-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    .line 44
    sput v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    .line 45
    sput v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    .line 46
    const-string v1, ""

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    .line 47
    const-string v1, "idle"

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 48
    sput v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    .line 52
    :try_start_0
    const-string v1, "ApplicationMain"

    invoke-static {v1}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 55
    goto :goto_0

    .line 53
    :catchall_0
    move-exception v1

    .line 54
    .local v1, "t":Ljava/lang/Throwable;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "loadLibrary(ApplicationMain) failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "PsyVK"

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 401
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    sput-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textureSent:Z

    .line 745
    sput-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudLoopStarted:Z

    .line 746
    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    sput-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudCache:[Ljava/lang/String;

    .line 839
    const/16 v0, 0xa

    new-array v1, v0, [Ljava/lang/String;

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textCache:[Ljava/lang/String;

    .line 840
    new-array v1, v0, [I

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textW:[I

    .line 841
    new-array v0, v0, [I

    sput-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textH:[I

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 58
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 59
    return-void
.end method

.method static synthetic access$000(Landroid/app/Activity;III)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Landroid/app/Activity;
    .param p1, "x1"    # I
    .param p2, "x2"    # I
    .param p3, "x3"    # I

    .line 38
    invoke-static {p0, p1, p2, p3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->addOverlay(Landroid/app/Activity;III)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$100()Z
    .locals 1

    .line 38
    sget-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    return v0
.end method

.method static synthetic access$200(Landroid/app/Activity;II)V
    .locals 0
    .param p0, "x0"    # Landroid/app/Activity;
    .param p1, "x1"    # I
    .param p2, "x2"    # I

    .line 38
    invoke-static {p0, p1, p2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->retry(Landroid/app/Activity;II)V

    return-void
.end method

.method static synthetic access$300()I
    .locals 1

    .line 38
    sget v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    return v0
.end method

.method static synthetic access$302(I)I
    .locals 0
    .param p0, "x0"    # I

    .line 38
    sput p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    return p0
.end method

.method static synthetic access$400()I
    .locals 1

    .line 38
    sget v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    return v0
.end method

.method static synthetic access$402(I)I
    .locals 0
    .param p0, "x0"    # I

    .line 38
    sput p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    return p0
.end method

.method static synthetic access$500()Ljava/lang/String;
    .locals 1

    .line 38
    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$502(Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .param p0, "x0"    # Ljava/lang/String;

    .line 38
    sput-object p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$600(Landroid/view/Surface;)V
    .locals 0
    .param p0, "x0"    # Landroid/view/Surface;

    .line 38
    invoke-static {p0}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attach(Landroid/view/Surface;)V

    return-void
.end method

.method static synthetic access$700()V
    .locals 0

    .line 38
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->detach()V

    return-void
.end method

.method static synthetic access$800()V
    .locals 0

    .line 38
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudTick()V

    return-void
.end method

.method private static addOverlay(Landroid/app/Activity;III)Ljava/lang/String;
    .locals 8
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "width"    # I
    .param p2, "height"    # I
    .param p3, "mode"    # I

    .line 240
    :try_start_0
    new-instance v0, Landroid/view/SurfaceView;

    invoke-direct {v0, p0}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 243
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/SurfaceView;->setFocusable(Z)V

    .line 244
    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v0, v1}, Landroid/view/SurfaceView;->setClickable(Z)V

    .line 245
    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v0, v1}, Landroid/view/SurfaceView;->setFocusableInTouchMode(Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 248
    const/4 v0, 0x2

    const-string v2, "PsyVK"

    const/4 v3, 0x1

    if-ne p3, v0, :cond_1

    .line 249
    const/4 v4, 0x0

    .line 251
    .local v4, "overlay":Z
    :try_start_1
    sget-object v5, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v5, v3}, Landroid/view/SurfaceView;->setZOrderMediaOverlay(Z)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 252
    const/4 v4, 0x1

    .line 255
    goto :goto_0

    .line 253
    :catchall_0
    move-exception v5

    .line 254
    .local v5, "t":Ljava/lang/Throwable;
    :try_start_2
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "media overlay rejected: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v2, v6}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 256
    .end local v5    # "t":Ljava/lang/Throwable;
    :goto_0
    if-nez v4, :cond_0

    .line 257
    sget-object v5, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v5, v3}, Landroid/view/SurfaceView;->setZOrderOnTop(Z)V

    .line 259
    :cond_0
    const-string v5, "content"

    move-object v4, v5

    .line 260
    .local v4, "parentName":Ljava/lang/String;
    goto :goto_1

    .line 261
    .end local v4    # "parentName":Ljava/lang/String;
    :cond_1
    sget-object v4, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v4, v3}, Landroid/view/SurfaceView;->setZOrderOnTop(Z)V

    .line 262
    if-ne p3, v3, :cond_2

    .line 263
    sget-object v4, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v4}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v4

    const/4 v5, -0x3

    invoke-interface {v4, v5}, Landroid/view/SurfaceHolder;->setFormat(I)V

    .line 265
    :cond_2
    const-string v4, "decor"

    .line 268
    .restart local v4    # "parentName":Ljava/lang/String;
    :goto_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 269
    if-ne p3, v3, :cond_3

    const-string v3, "+onTop(translucent)"

    goto :goto_2

    :cond_3
    const-string v3, "+onTop(opaque)"

    :goto_2
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 270
    .local v3, "modeName":Ljava/lang/String;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "adding "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    sput-object v5, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 271
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "adding surface view: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 274
    if-lez p1, :cond_5

    if-gtz p2, :cond_4

    goto :goto_3

    .line 281
    :cond_4
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v5, 0x33

    invoke-direct {v1, p1, p2, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 282
    .local v1, "lp":Landroid/widget/FrameLayout$LayoutParams;
    const/16 v5, 0x8

    iput v5, v1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 283
    iput v5, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    goto :goto_4

    .line 276
    .end local v1    # "lp":Landroid/widget/FrameLayout$LayoutParams;
    :cond_5
    :goto_3
    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v6, -0x1

    invoke-direct {v5, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 278
    .local v5, "lp":Landroid/widget/FrameLayout$LayoutParams;
    iput v1, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 279
    iput v1, v5, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    move-object v1, v5

    .line 286
    .end local v5    # "lp":Landroid/widget/FrameLayout$LayoutParams;
    .restart local v1    # "lp":Landroid/widget/FrameLayout$LayoutParams;
    :goto_4
    sget-object v5, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v5}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v5

    new-instance v6, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$5;

    invoke-direct {v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$5;-><init>()V

    invoke-interface {v5, v6}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 316
    if-ne p3, v0, :cond_6

    .line 317
    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->addContentView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    goto :goto_5

    .line 319
    :cond_6
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 320
    .local v0, "decor":Landroid/view/ViewGroup;
    sget-object v5, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v0, v5, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 323
    .end local v0    # "decor":Landroid/view/ViewGroup;
    :goto_5
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "added "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 324
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "SurfaceView added ("

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, "x"

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, ", "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, ")"

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 325
    const-string v0, ""
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    return-object v0

    .line 326
    .end local v1    # "lp":Landroid/widget/FrameLayout$LayoutParams;
    .end local v3    # "modeName":Ljava/lang/String;
    .end local v4    # "parentName":Ljava/lang/String;
    :catchall_1
    move-exception v0

    .line 327
    .local v0, "t":Ljava/lang/Throwable;
    const-string v1, "add failed"

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 328
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "addOverlay failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method public static addTexture(ILjava/lang/String;)Ljava/lang/String;
    .locals 18
    .param p0, "slot"    # I
    .param p1, "path"    # Ljava/lang/String;

    .line 1022
    move/from16 v1, p0

    move-object/from16 v2, p1

    const-string v0, "assets/"

    const-string v3, ".png"

    const-string v4, "PsyVK"

    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v5

    .line 1023
    .local v5, "ctx":Landroid/content/Context;
    invoke-virtual {v5}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v6

    .line 1025
    .local v6, "am":Landroid/content/res/AssetManager;
    const/4 v7, 0x0

    .line 1026
    .local v7, "bmp":Landroid/graphics/Bitmap;
    const/4 v8, 0x4

    new-array v8, v8, [Ljava/lang/String;

    const/4 v9, 0x0

    aput-object v2, v8, v9

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    const/4 v11, 0x1

    aput-object v10, v8, v11

    const/4 v10, 0x2

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    aput-object v11, v8, v10

    const/4 v10, 0x3

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v8, v10

    move-object v3, v8

    .line 1027
    .local v3, "tries":[Ljava/lang/String;
    array-length v8, v3

    :goto_0
    if-ge v9, v8, :cond_4

    aget-object v0, v3, v9
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_3

    move-object v10, v0

    .line 1028
    .local v10, "p":Ljava/lang/String;
    :try_start_1
    invoke-virtual {v6, v10}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    move-object v11, v0

    .line 1029
    .local v11, "is":Ljava/io/InputStream;
    :try_start_2
    invoke-static {v11}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-object v7, v0

    .line 1030
    if-eqz v7, :cond_1

    .line 1033
    if-eqz v11, :cond_0

    :try_start_3
    invoke-virtual {v11}, Ljava/io/InputStream;->close()V

    .line 1031
    :cond_0
    goto :goto_3

    .line 1033
    :cond_1
    if-eqz v11, :cond_2

    invoke-virtual {v11}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 1034
    .end local v11    # "is":Ljava/io/InputStream;
    :cond_2
    goto :goto_2

    .line 1028
    .restart local v11    # "is":Ljava/io/InputStream;
    :catchall_0
    move-exception v0

    move-object v12, v0

    if-eqz v11, :cond_3

    :try_start_4
    invoke-virtual {v11}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v0

    move-object v13, v0

    :try_start_5
    invoke-virtual {v12, v13}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    .end local v3    # "tries":[Ljava/lang/String;
    .end local v5    # "ctx":Landroid/content/Context;
    .end local v6    # "am":Landroid/content/res/AssetManager;
    .end local v7    # "bmp":Landroid/graphics/Bitmap;
    .end local v10    # "p":Ljava/lang/String;
    .end local p0    # "slot":I
    .end local p1    # "path":Ljava/lang/String;
    :cond_3
    :goto_1
    throw v12
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    .line 1033
    .end local v11    # "is":Ljava/io/InputStream;
    .restart local v3    # "tries":[Ljava/lang/String;
    .restart local v5    # "ctx":Landroid/content/Context;
    .restart local v6    # "am":Landroid/content/res/AssetManager;
    .restart local v7    # "bmp":Landroid/graphics/Bitmap;
    .restart local v10    # "p":Ljava/lang/String;
    .restart local p0    # "slot":I
    .restart local p1    # "path":Ljava/lang/String;
    :catchall_2
    move-exception v0

    .line 1027
    .end local v10    # "p":Ljava/lang/String;
    :goto_2
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 1036
    :cond_4
    :goto_3
    if-nez v7, :cond_5

    .line 1037
    :try_start_6
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "addTexture: not found "

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1038
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "not found: "

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 1041
    :cond_5
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v0

    .line 1042
    .local v0, "w":I
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v8

    .line 1043
    .local v8, "h":I
    mul-int v9, v0, v8

    new-array v9, v9, [I

    .line 1044
    .local v9, "px":[I
    const/4 v12, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    move-object v10, v7

    move-object v11, v9

    move v13, v0

    move/from16 v16, v0

    move/from16 v17, v8

    invoke-virtual/range {v10 .. v17}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 1045
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    .line 1047
    invoke-static {v1, v9, v0, v8}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeAddTexture(I[III)V

    .line 1048
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "texture slot "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, " <- "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, " ("

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, "x"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, ")"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v4, v10}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1049
    const-string v4, ""
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_3

    return-object v4

    .line 1050
    .end local v0    # "w":I
    .end local v3    # "tries":[Ljava/lang/String;
    .end local v5    # "ctx":Landroid/content/Context;
    .end local v6    # "am":Landroid/content/res/AssetManager;
    .end local v7    # "bmp":Landroid/graphics/Bitmap;
    .end local v8    # "h":I
    .end local v9    # "px":[I
    :catchall_3
    move-exception v0

    .line 1051
    .local v0, "t":Ljava/lang/Throwable;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "addTexture failed: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1052
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    return-object v3
.end method

.method private static attach(Landroid/view/Surface;)V
    .locals 4
    .param p0, "surface"    # Landroid/view/Surface;

    .line 366
    const-string v0, "PsyVK"

    if-eqz p0, :cond_7

    invoke-virtual {p0}, Landroid/view/Surface;->isValid()Z

    move-result v1

    if-nez v1, :cond_0

    goto/16 :goto_6

    .line 372
    :cond_0
    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-eqz v1, :cond_1

    .line 376
    const-string v1, "attach: already running, ignoring"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 377
    return-void

    .line 381
    :cond_1
    const/4 v1, 0x0

    :try_start_0
    sget v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    sget v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    invoke-static {p0, v2, v3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeCreate(Landroid/view/Surface;II)Ljava/lang/String;

    move-result-object v2

    .line 382
    .local v2, "err":Ljava/lang/String;
    if-eqz v2, :cond_3

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_2

    goto :goto_0

    :cond_2
    const/4 v3, 0x0

    goto :goto_1

    :cond_3
    :goto_0
    const/4 v3, 0x1

    :goto_1
    sput-boolean v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    .line 383
    if-nez v2, :cond_4

    const-string v3, ""

    goto :goto_2

    :cond_4
    move-object v3, v2

    :goto_2
    sput-object v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 387
    .end local v2    # "err":Ljava/lang/String;
    goto :goto_3

    .line 384
    :catchall_0
    move-exception v2

    .line 385
    .local v2, "t":Ljava/lang/Throwable;
    sput-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    .line 386
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "nativeCreate threw: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    .line 389
    .end local v2    # "t":Ljava/lang/Throwable;
    :goto_3
    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-eqz v1, :cond_5

    const-string v1, "ready"

    goto :goto_4

    :cond_5
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "native failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_4
    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 390
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 391
    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-eqz v1, :cond_6

    .line 392
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->loadTexture()V

    .line 393
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->loadTextTexture()V

    .line 394
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->loadGameTextures()V

    .line 395
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->startHudLoop()V

    goto :goto_5

    .line 397
    :cond_6
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "vulkan surface failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 399
    :goto_5
    return-void

    .line 367
    :cond_7
    :goto_6
    const-string v1, "attach: invalid surface"

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 368
    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 369
    return-void
.end method

.method private static checkDevice()Ljava/lang/String;
    .locals 6

    .line 213
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x18

    if-ge v0, v1, :cond_0

    .line 214
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Vulkan needs Android 7.0+ (API 24), this is API "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 217
    :cond_0
    const/4 v0, 0x0

    .line 218
    .local v0, "has64":Z
    sget-object v1, Landroid/os/Build;->SUPPORTED_64_BIT_ABIS:[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, v1, v3

    .line 219
    .local v4, "abi":Ljava/lang/String;
    const-string v5, "arm64"

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 220
    const/4 v0, 0x1

    .line 218
    .end local v4    # "abi":Ljava/lang/String;
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 223
    :cond_2
    if-nez v0, :cond_3

    .line 224
    const-string v1, "no arm64 ABI (the Vulkan bridge is 64-bit only)"

    invoke-static {v1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    return-object v1

    .line 226
    :cond_3
    const/4 v1, 0x0

    return-object v1
.end method

.method private static detach()V
    .locals 4

    .line 549
    const-string v0, "PsyVK"

    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-nez v1, :cond_0

    .line 550
    return-void

    .line 553
    :cond_0
    :try_start_0
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeDestroy()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 556
    goto :goto_0

    .line 554
    :catchall_0
    move-exception v1

    .line 555
    .local v1, "t":Ljava/lang/Throwable;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "nativeDestroy failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 557
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    const/4 v1, 0x0

    sput-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    .line 558
    const-string v1, "destroyed"

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 559
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 560
    return-void
.end method

.method public static declared-synchronized diag()Ljava/lang/String;
    .locals 9

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 634
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "stage="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " attempt="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " created="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-boolean v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 635
    .local v1, "base":Ljava/lang/String;
    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-nez v2, :cond_0

    .line 636
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " view=null err="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v2

    .line 639
    :cond_0
    :try_start_1
    invoke-virtual {v2}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v2

    .line 640
    .local v2, "holder":Landroid/view/SurfaceHolder;
    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v2, :cond_1

    invoke-interface {v2}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v5

    if-eqz v5, :cond_1

    .line 641
    invoke-interface {v2}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v5

    invoke-virtual {v5}, Landroid/view/Surface;->isValid()Z

    move-result v5

    if-eqz v5, :cond_1

    const/4 v5, 0x1

    goto :goto_0

    :cond_1
    const/4 v5, 0x0

    .line 642
    .local v5, "valid":Z
    :goto_0
    sget-object v6, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v6}, Landroid/view/SurfaceView;->getParent()Landroid/view/ViewParent;

    move-result-object v6

    check-cast v6, Landroid/view/View;

    .line 644
    .local v6, "parent":Landroid/view/View;
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, " view="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    sget-object v8, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 645
    invoke-virtual {v8}, Landroid/view/SurfaceView;->getWidth()I

    move-result v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, "x"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    sget-object v8, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v8}, Landroid/view/SurfaceView;->getHeight()I

    move-result v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, " visible="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    sget-object v8, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 646
    invoke-virtual {v8}, Landroid/view/SurfaceView;->getVisibility()I

    move-result v8

    if-nez v8, :cond_2

    goto :goto_1

    :cond_2
    const/4 v3, 0x0

    :goto_1
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " attached="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    sget-object v4, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 647
    invoke-virtual {v4}, Landroid/view/SurfaceView;->isAttachedToWindow()Z

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " valid="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " parent="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 649
    if-nez v6, :cond_3

    const-string v4, "null"

    goto :goto_2

    :cond_3
    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v4

    :goto_2
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " err="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    sget-object v4, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 644
    monitor-exit v0

    return-object v3

    .line 633
    .end local v1    # "base":Ljava/lang/String;
    .end local v2    # "holder":Landroid/view/SurfaceHolder;
    .end local v5    # "valid":Z
    .end local v6    # "parent":Landroid/view/View;
    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private static drawHudLine(ILjava/lang/String;)V
    .locals 18
    .param p0, "id"    # I
    .param p1, "line"    # Ljava/lang/String;

    .line 979
    move/from16 v0, p0

    move-object/from16 v1, p1

    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2}, Landroid/graphics/Paint;-><init>()V

    .line 980
    .local v2, "paint":Landroid/graphics/Paint;
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setAntiAlias(Z)V

    .line 981
    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 982
    const/high16 v3, 0x42200000    # 40.0f

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 983
    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 984
    const/high16 v3, 0x40800000    # 4.0f

    const/4 v4, 0x0

    const/high16 v5, 0x40000000    # 2.0f

    const/high16 v6, -0x1000000

    invoke-virtual {v2, v3, v4, v5, v6}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V

    .line 986
    invoke-virtual {v2, v1}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;)F

    move-result v3

    float-to-double v3, v3

    invoke-static {v3, v4}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v3

    double-to-int v3, v3

    add-int/lit8 v3, v3, 0xc

    .line 987
    .local v3, "w":I
    const/16 v4, 0x38

    .line 988
    .local v4, "h":I
    const/16 v6, 0x10

    if-ge v3, v6, :cond_0

    .line 989
    return-void

    .line 992
    :cond_0
    sget-object v6, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v4, v6}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v14

    .line 994
    .local v14, "bmp":Landroid/graphics/Bitmap;
    new-instance v6, Landroid/graphics/Canvas;

    invoke-direct {v6, v14}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    move-object v15, v6

    .line 995
    .local v15, "canvas":Landroid/graphics/Canvas;
    const/high16 v6, 0x40c00000    # 6.0f

    const/high16 v7, 0x42280000    # 42.0f

    invoke-virtual {v15, v1, v6, v7, v2}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 997
    mul-int v6, v3, v4

    new-array v13, v6, [I

    .line 998
    .local v13, "px":[I
    const/4 v8, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    move-object v6, v14

    move-object v7, v13

    move v9, v3

    move v12, v3

    move-object v5, v13

    .end local v13    # "px":[I
    .local v5, "px":[I
    move v13, v4

    invoke-virtual/range {v6 .. v13}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 999
    invoke-virtual {v14}, Landroid/graphics/Bitmap;->recycle()V

    .line 1001
    add-int/lit8 v6, v0, 0x30

    .line 1002
    .local v6, "slot":I
    invoke-static {v6, v5, v3, v4}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeAddTexture(I[III)V

    .line 1004
    sget v7, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    if-lez v7, :cond_1

    int-to-float v7, v7

    goto :goto_0

    :cond_1
    const/high16 v7, 0x43f00000    # 480.0f

    .line 1005
    .local v7, "viewW":F
    :goto_0
    sget v8, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    if-lez v8, :cond_2

    int-to-float v8, v8

    goto :goto_1

    :cond_2
    const/high16 v8, 0x43870000    # 270.0f

    .line 1006
    .local v8, "viewH":F
    :goto_1
    const v9, 0x3d6147ae    # 0.055f

    mul-float v9, v9, v8

    int-to-float v10, v4

    div-float/2addr v9, v10

    .line 1007
    .local v9, "scale":F
    int-to-float v10, v3

    mul-float v10, v10, v9

    .line 1008
    .local v10, "qw":F
    int-to-float v11, v4

    mul-float v11, v11, v9

    .line 1009
    .local v11, "qh":F
    const v12, 0x3c75c28f    # 0.015f

    mul-float v12, v12, v7

    .line 1010
    .local v12, "x":F
    sub-float v13, v8, v11

    const v17, 0x3c23d70a    # 0.01f

    mul-float v17, v17, v7

    sub-float v13, v13, v17

    move-object/from16 v17, v2

    .end local v2    # "paint":Landroid/graphics/Paint;
    .local v17, "paint":Landroid/graphics/Paint;
    int-to-float v2, v0

    const/high16 v16, 0x40000000    # 2.0f

    add-float v16, v11, v16

    mul-float v2, v2, v16

    sub-float/2addr v13, v2

    .line 1012
    .local v13, "y":F
    invoke-static {v12, v13, v10, v11, v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativePushTextQuad(FFFFI)V

    .line 1013
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v16, v5

    .end local v5    # "px":[I
    .local v16, "px":[I
    const-string v5, "hud "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, ": \""

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "\" -> slot "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, " "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "x"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v5, "PsyVK"

    invoke-static {v5, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1014
    return-void
.end method

.method private static drawTextToSlot(ILjava/lang/String;I)[I
    .locals 16
    .param p0, "slot"    # I
    .param p1, "text"    # Ljava/lang/String;
    .param p2, "color"    # I

    .line 915
    move-object/from16 v0, p1

    new-instance v1, Landroid/graphics/Paint;

    invoke-direct {v1}, Landroid/graphics/Paint;-><init>()V

    .line 916
    .local v1, "paint":Landroid/graphics/Paint;
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setAntiAlias(Z)V

    .line 917
    move/from16 v3, p2

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 918
    const/high16 v4, 0x42400000    # 48.0f

    invoke-virtual {v1, v4}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 919
    sget-object v4, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v1, v4}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 920
    const/high16 v4, 0x40400000    # 3.0f

    const/4 v5, 0x0

    const/high16 v6, 0x40000000    # 2.0f

    const/high16 v7, -0x1000000

    invoke-virtual {v1, v4, v5, v6, v7}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V

    .line 922
    invoke-virtual {v1, v0}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;)F

    move-result v4

    float-to-double v4, v4

    invoke-static {v4, v5}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v4

    double-to-int v4, v4

    const/16 v5, 0xa

    add-int/2addr v4, v5

    .line 923
    .local v4, "w":I
    const/16 v14, 0x40

    .line 924
    .local v14, "h":I
    if-ge v4, v5, :cond_0

    .line 925
    const/4 v2, 0x0

    return-object v2

    .line 928
    :cond_0
    sget-object v5, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v4, v14, v5}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v5

    .line 930
    .local v5, "bmp":Landroid/graphics/Bitmap;
    new-instance v6, Landroid/graphics/Canvas;

    invoke-direct {v6, v5}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    move-object v15, v6

    .line 931
    .local v15, "canvas":Landroid/graphics/Canvas;
    const/high16 v6, 0x40a00000    # 5.0f

    const/high16 v7, 0x42440000    # 49.0f

    invoke-virtual {v15, v0, v6, v7, v1}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 933
    mul-int v6, v4, v14

    new-array v13, v6, [I

    .line 934
    .local v13, "px":[I
    const/4 v8, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    move-object v6, v5

    move-object v7, v13

    move v9, v4

    move v12, v4

    move-object v2, v13

    .end local v13    # "px":[I
    .local v2, "px":[I
    move v13, v14

    invoke-virtual/range {v6 .. v13}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 935
    invoke-virtual {v5}, Landroid/graphics/Bitmap;->recycle()V

    .line 937
    move/from16 v6, p0

    invoke-static {v6, v2, v4, v14}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeAddTexture(I[III)V

    .line 938
    const/4 v7, 0x2

    new-array v7, v7, [I

    aput v4, v7, v8

    const/4 v8, 0x1

    aput v14, v7, v8

    return-object v7
.end method

.method private static fail(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "message"    # Ljava/lang/String;

    .line 654
    sput-object p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    .line 655
    sput-object p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 656
    const-string v0, "PsyVK"

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 657
    return-object p0
.end method

.method public static declared-synchronized hideOverlay()V
    .locals 5

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 606
    :try_start_0
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Landroid/view/SurfaceView;->getTranslationY()F

    move-result v1

    const v2, 0x469c4000    # 20000.0f

    cmpl-float v1, v1, v2

    if-eqz v1, :cond_0

    .line 607
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v1, v2}, Landroid/view/SurfaceView;->setTranslationY(F)V

    .line 608
    const-string v1, "PsyVK"

    const-string v2, "overlay hidden"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 612
    :cond_0
    goto :goto_0

    .line 610
    :catchall_0
    move-exception v1

    .line 611
    .local v1, "t":Ljava/lang/Throwable;
    :try_start_1
    const-string v2, "PsyVK"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "hideOverlay failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 613
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    monitor-exit v0

    return-void

    .line 605
    :catchall_1
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private static hudTick()V
    .locals 4

    .line 942
    sget-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-nez v0, :cond_0

    .line 943
    const/4 v0, 0x0

    sput-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudLoopStarted:Z

    .line 944
    return-void

    .line 947
    :cond_0
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->pullTextureRequests()V

    .line 948
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->pullTextRequests()V

    .line 953
    const/4 v0, 0x0

    .local v0, "id":I
    :goto_0
    if-gez v0, :cond_4

    .line 955
    :try_start_0
    invoke-static {v0}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeGetHudLine(I)Ljava/lang/String;

    move-result-object v1

    .line 956
    .local v1, "line":Ljava/lang/String;
    if-eqz v1, :cond_3

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-nez v2, :cond_1

    goto :goto_1

    .line 959
    :cond_1
    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudCache:[Ljava/lang/String;

    aget-object v3, v2, v0

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 960
    goto :goto_2

    .line 962
    :cond_2
    aput-object v1, v2, v0

    .line 963
    invoke-static {v0, v1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->drawHudLine(ILjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 966
    .end local v1    # "line":Ljava/lang/String;
    goto :goto_2

    .line 957
    .restart local v1    # "line":Ljava/lang/String;
    :cond_3
    :goto_1
    goto :goto_2

    .line 964
    .end local v1    # "line":Ljava/lang/String;
    :catchall_0
    move-exception v1

    .line 965
    .local v1, "t":Ljava/lang/Throwable;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "hud line "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "PsyVK"

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 953
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 969
    .end local v0    # "id":I
    :cond_4
    const-wide/16 v0, 0x15e

    new-instance v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$7;

    invoke-direct {v2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$7;-><init>()V

    invoke-static {v0, v1, v2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->later(JLjava/lang/Runnable;)V

    .line 975
    return-void
.end method

.method public static declared-synchronized info()Ljava/lang/String;
    .locals 4

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 620
    :try_start_0
    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-nez v1, :cond_1

    .line 621
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "not running"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, " ("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastError:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    :cond_0
    const-string v2, ""

    :goto_0
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    monitor-exit v0

    return-object v1

    .line 625
    :cond_1
    :try_start_1
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeInfo()Ljava/lang/String;

    move-result-object v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 628
    .local v1, "text":Ljava/lang/String;
    goto :goto_1

    .line 626
    .end local v1    # "text":Ljava/lang/String;
    :catchall_0
    move-exception v1

    .line 627
    .local v1, "t":Ljava/lang/Throwable;
    :try_start_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "native info unavailable: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object v1, v2

    .line 629
    .local v1, "text":Ljava/lang/String;
    :goto_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    if-nez v1, :cond_2

    const-string v3, "?"

    goto :goto_2

    :cond_2
    move-object v3, v1

    :goto_2
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " | "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget v3, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    monitor-exit v0

    return-object v2

    .line 619
    .end local v1    # "text":Ljava/lang/String;
    :catchall_1
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method public static declared-synchronized isRunning()Z
    .locals 2

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 616
    :try_start_0
    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return v1

    .line 616
    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private static later(JLjava/lang/Runnable;)V
    .locals 3
    .param p0, "delayMs"    # J
    .param p2, "action"    # Ljava/lang/Runnable;

    .line 671
    :try_start_0
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    invoke-virtual {v0, p2, p0, p1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 674
    goto :goto_0

    .line 672
    :catchall_0
    move-exception v0

    .line 673
    .local v0, "t":Ljava/lang/Throwable;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "postDelayed failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "PsyVK"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 675
    .end local v0    # "t":Ljava/lang/Throwable;
    :goto_0
    return-void
.end method

.method private static loadGameTextures()V
    .locals 7

    .line 716
    const-string v0, "week1/images/stageback.png"

    const-string v1, "week1/images/stagecurtains.png"

    const-string v2, "week1/images/stagefront.png"

    const-string v3, "week1/images/stage_light.png"

    const-string v4, "shared/images/characters/BOYFRIEND.png"

    const-string v5, "shared/images/characters/DADDY_DEAREST.png"

    const-string v6, "shared/images/characters/GF_assets.png"

    filled-new-array/range {v0 .. v6}, [Ljava/lang/String;

    move-result-object v0

    .line 726
    .local v0, "paths":[Ljava/lang/String;
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v2, v0

    if-ge v1, v2, :cond_1

    .line 727
    add-int/lit8 v2, v1, 0x3

    aget-object v3, v0, v1

    invoke-static {v2, v3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->addTexture(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 728
    .local v2, "err":Ljava/lang/String;
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_0

    .line 729
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "slot "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    add-int/lit8 v4, v1, 0x3

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " <- "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    aget-object v4, v0, v1

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ": "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "PsyVK"

    invoke-static {v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 726
    .end local v2    # "err":Ljava/lang/String;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 732
    .end local v1    # "i":I
    :cond_1
    return-void
.end method

.method private static loadTextTexture()V
    .locals 15

    .line 520
    const-string v0, "PsyVK"

    const/16 v1, 0x300

    const/16 v2, 0x6e

    :try_start_0
    sget-object v3, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v1, v2, v3}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 522
    .local v1, "bmp":Landroid/graphics/Bitmap;
    new-instance v2, Landroid/graphics/Canvas;

    invoke-direct {v2, v1}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    move-object v10, v2

    .line 524
    .local v10, "canvas":Landroid/graphics/Canvas;
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2}, Landroid/graphics/Paint;-><init>()V

    move-object v11, v2

    .line 525
    .local v11, "paint":Landroid/graphics/Paint;
    const/4 v2, 0x1

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setAntiAlias(Z)V

    .line 526
    const/4 v2, -0x1

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 527
    const/high16 v2, 0x42300000    # 44.0f

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 528
    sget-object v2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 529
    const-string v2, "PSY VULKAN"

    const/high16 v3, 0x42600000    # 56.0f

    const/high16 v4, 0x41000000    # 8.0f

    invoke-virtual {v10, v2, v4, v3, v11}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 531
    const/high16 v2, 0x41d00000    # 26.0f

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 532
    const v2, -0x651940

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 533
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v3, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " / atlas + text"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/high16 v3, 0x42c00000    # 96.0f

    invoke-virtual {v10, v2, v4, v3, v11}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 535
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    move v12, v2

    .line 536
    .local v12, "w":I
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    move v13, v2

    .line 537
    .local v13, "h":I
    mul-int v2, v12, v13

    new-array v2, v2, [I

    move-object v14, v2

    .line 538
    .local v14, "px":[I
    const/4 v4, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v2, v1

    move-object v3, v14

    move v5, v12

    move v8, v12

    move v9, v13

    invoke-virtual/range {v2 .. v9}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 539
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    .line 541
    invoke-static {v14, v12, v13}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeSetText([III)V

    .line 542
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "text texture "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 545
    nop

    .end local v1    # "bmp":Landroid/graphics/Bitmap;
    .end local v10    # "canvas":Landroid/graphics/Canvas;
    .end local v11    # "paint":Landroid/graphics/Paint;
    .end local v12    # "w":I
    .end local v13    # "h":I
    .end local v14    # "px":[I
    goto :goto_0

    .line 543
    :catchall_0
    move-exception v1

    .line 544
    .local v1, "t":Ljava/lang/Throwable;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "text texture failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 546
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    return-void
.end method

.method private static loadTexture()V
    .locals 13

    .line 460
    const-string v0, "PsyVK"

    sget-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textureSent:Z

    if-eqz v1, :cond_0

    .line 461
    return-void

    .line 463
    :cond_0
    const/4 v1, 0x1

    sput-boolean v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textureSent:Z

    .line 466
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->tryLoadAtlas()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 467
    return-void

    .line 470
    :cond_1
    const/4 v1, 0x0

    .line 472
    .local v1, "bmp":Landroid/graphics/Bitmap;
    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 473
    .local v2, "ctx":Landroid/content/Context;
    invoke-virtual {v2}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v3

    .line 474
    .local v3, "am":Landroid/content/res/AssetManager;
    const-string v4, "assets/shared/images/newgrounds_logo.png"

    const-string v5, "assets/shared/images/Menu_Tracks.png"

    filled-new-array {v4, v5}, [Ljava/lang/String;

    move-result-object v4

    .line 478
    .local v4, "paths":[Ljava/lang/String;
    array-length v5, v4

    const/4 v6, 0x0

    :goto_0
    if-ge v6, v5, :cond_6

    aget-object v7, v4, v6
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_3

    .line 479
    .local v7, "path":Ljava/lang/String;
    :try_start_1
    invoke-virtual {v3, v7}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v8
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 480
    .local v8, "is":Ljava/io/InputStream;
    :try_start_2
    invoke-static {v8}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v9

    move-object v1, v9

    .line 481
    if-eqz v1, :cond_3

    .line 482
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "texture from "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, " ("

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "x"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 483
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, ")"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 482
    invoke-static {v0, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 486
    if-eqz v8, :cond_2

    :try_start_3
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V

    .line 484
    :cond_2
    goto :goto_3

    .line 486
    :cond_3
    if-eqz v8, :cond_4

    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 487
    .end local v8    # "is":Ljava/io/InputStream;
    :cond_4
    goto :goto_2

    .line 479
    .restart local v8    # "is":Ljava/io/InputStream;
    :catchall_0
    move-exception v9

    if-eqz v8, :cond_5

    :try_start_4
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v10

    :try_start_5
    invoke-virtual {v9, v10}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    .end local v1    # "bmp":Landroid/graphics/Bitmap;
    .end local v2    # "ctx":Landroid/content/Context;
    .end local v3    # "am":Landroid/content/res/AssetManager;
    .end local v4    # "paths":[Ljava/lang/String;
    .end local v7    # "path":Ljava/lang/String;
    :cond_5
    :goto_1
    throw v9
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    .line 486
    .end local v8    # "is":Ljava/io/InputStream;
    .restart local v1    # "bmp":Landroid/graphics/Bitmap;
    .restart local v2    # "ctx":Landroid/content/Context;
    .restart local v3    # "am":Landroid/content/res/AssetManager;
    .restart local v4    # "paths":[Ljava/lang/String;
    .restart local v7    # "path":Ljava/lang/String;
    :catchall_2
    move-exception v8

    .line 478
    .end local v7    # "path":Ljava/lang/String;
    :goto_2
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 491
    .end local v2    # "ctx":Landroid/content/Context;
    .end local v3    # "am":Landroid/content/res/AssetManager;
    .end local v4    # "paths":[Ljava/lang/String;
    :cond_6
    :goto_3
    goto :goto_4

    .line 489
    :catchall_3
    move-exception v2

    .line 490
    .local v2, "t":Ljava/lang/Throwable;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "asset texture failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 493
    .end local v2    # "t":Ljava/lang/Throwable;
    :goto_4
    if-nez v1, :cond_a

    .line 494
    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/16 v3, 0x40

    invoke-static {v3, v3, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 496
    const/4 v2, 0x0

    .local v2, "y":I
    :goto_5
    if-ge v2, v3, :cond_9

    .line 497
    const/4 v4, 0x0

    .local v4, "x":I
    :goto_6
    if-ge v4, v3, :cond_8

    .line 498
    div-int/lit8 v5, v4, 0x8

    div-int/lit8 v6, v2, 0x8

    add-int/2addr v5, v6

    rem-int/lit8 v5, v5, 0x2

    if-nez v5, :cond_7

    const/4 v5, -0x1

    goto :goto_7

    :cond_7
    const v5, -0xdfdfe0

    :goto_7
    invoke-virtual {v1, v4, v2, v5}, Landroid/graphics/Bitmap;->setPixel(III)V

    .line 497
    add-int/lit8 v4, v4, 0x1

    goto :goto_6

    .line 496
    .end local v4    # "x":I
    :cond_8
    add-int/lit8 v2, v2, 0x1

    goto :goto_5

    .line 501
    .end local v2    # "y":I
    :cond_9
    const-string v2, "texture: generated checkerboard 64x64"

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 504
    :cond_a
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    .line 505
    .local v2, "w":I
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v11

    .line 506
    .local v11, "h":I
    mul-int v3, v2, v11

    new-array v12, v3, [I

    .line 507
    .local v12, "px":[I
    const/4 v5, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    move-object v3, v1

    move-object v4, v12

    move v6, v2

    move v9, v2

    move v10, v11

    invoke-virtual/range {v3 .. v10}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 508
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    .line 511
    :try_start_6
    invoke-static {v12, v2, v11}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeSetTexture([III)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_4

    .line 514
    goto :goto_8

    .line 512
    :catchall_4
    move-exception v3

    .line 513
    .local v3, "t":Ljava/lang/Throwable;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "nativeSetTexture failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 515
    .end local v3    # "t":Ljava/lang/Throwable;
    :goto_8
    return-void
.end method

.method private static native nativeAddTexture(I[III)V
.end method

.method private static native nativeClearText()V
.end method

.method private static native nativeCreate(Landroid/view/Surface;II)Ljava/lang/String;
.end method

.method private static native nativeDestroy()V
.end method

.method private static native nativeGetHudLine(I)Ljava/lang/String;
.end method

.method private static native nativeInfo()Ljava/lang/String;
.end method

.method private static native nativePumpQuads()V
.end method

.method private static native nativePushTextQuad(FFFFI)V
.end method

.method private static native nativeSetAtlas([III[II)V
.end method

.method private static native nativeSetHudValues([FI)V
.end method

.method private static native nativeSetText([III)V
.end method

.method private static native nativeSetTexture([III)V
.end method

.method private static native nativeSubmitQuads([FI)V
.end method

.method private static pullTextRequests()V
    .locals 18

    .line 849
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeClearText()V

    .line 851
    new-instance v0, Ljava/io/File;

    const-string v1, "/storage/emulated/0/Android/data/com.shadowmario.psychengine/files/vk_text.txt"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    move-object v1, v0

    .line 852
    .local v1, "f":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 853
    return-void

    .line 856
    :cond_0
    const/4 v2, 0x0

    .line 858
    .local v2, "reader":Ljava/io/BufferedReader;
    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/FileReader;

    invoke-direct {v3, v1}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v0, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    move-object v2, v0

    .line 860
    const/4 v0, 0x0

    move v3, v0

    .line 862
    .local v3, "n":I
    :goto_0
    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    move-object v4, v0

    .local v4, "line":Ljava/lang/String;
    if-eqz v0, :cond_6

    const/16 v0, 0xa

    if-ge v3, v0, :cond_6

    .line 863
    const-string v0, "\t"

    invoke-virtual {v4, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    move-object v5, v0

    .line 864
    .local v5, "p":[Ljava/lang/String;
    array-length v0, v5
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    const/4 v6, 0x6

    if-ge v0, v6, :cond_1

    .line 865
    goto :goto_0

    .line 868
    :cond_1
    const/4 v0, 0x0

    :try_start_1
    aget-object v6, v5, v0

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    .line 869
    .local v6, "id":I
    const/4 v7, 0x1

    aget-object v8, v5, v7

    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v8

    .line 870
    .local v8, "x":F
    const/4 v9, 0x2

    aget-object v10, v5, v9

    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v10

    .line 871
    .local v10, "y":F
    const/4 v11, 0x3

    aget-object v11, v5, v11

    invoke-virtual {v11}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v11

    .line 872
    .local v11, "h":F
    const/4 v12, 0x4

    aget-object v12, v5, v12

    invoke-virtual {v12}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v12

    long-to-int v13, v12

    .line 873
    .local v13, "color":I
    const/4 v12, 0x5

    aget-object v12, v5, v12

    .line 875
    .local v12, "text":Ljava/lang/String;
    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v14

    if-eqz v14, :cond_5

    const/high16 v14, 0x40000000    # 2.0f

    cmpg-float v14, v11, v14

    if-ltz v14, :cond_5

    if-ltz v6, :cond_5

    const/16 v14, 0x9

    if-le v6, v14, :cond_2

    goto :goto_2

    .line 879
    :cond_2
    add-int/lit8 v14, v6, 0x34

    .line 880
    .local v14, "slot":I
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v15, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v15

    const-string v7, "|"

    invoke-virtual {v15, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 883
    .local v7, "key":Ljava/lang/String;
    sget-object v15, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textCache:[Ljava/lang/String;

    aget-object v0, v15, v6

    invoke-virtual {v7, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textW:[I

    aget v0, v0, v6

    if-lez v0, :cond_3

    .line 884
    new-array v9, v9, [I

    const/4 v15, 0x0

    aput v0, v9, v15

    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textH:[I

    aget v0, v0, v6

    const/4 v15, 0x1

    aput v0, v9, v15

    move-object v0, v9

    const/4 v15, 0x1

    .local v0, "wh":[I
    goto :goto_1

    .line 886
    .end local v0    # "wh":[I
    :cond_3
    invoke-static {v14, v12, v13}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->drawTextToSlot(ILjava/lang/String;I)[I

    move-result-object v0

    .line 887
    .restart local v0    # "wh":[I
    if-nez v0, :cond_4

    .line 888
    goto/16 :goto_0

    .line 890
    :cond_4
    aput-object v7, v15, v6

    .line 891
    sget-object v9, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textW:[I

    const/4 v15, 0x0

    aget v17, v0, v15

    aput v17, v9, v6

    .line 892
    sget-object v9, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->textH:[I

    const/4 v15, 0x1

    aget v16, v0, v15

    aput v16, v9, v6

    .line 895
    :goto_1
    aget v9, v0, v15

    int-to-float v9, v9

    div-float v9, v11, v9

    .line 896
    .local v9, "s":F
    const/4 v15, 0x0

    aget v15, v0, v15

    int-to-float v15, v15

    mul-float v15, v15, v9

    invoke-static {v8, v10, v15, v11, v14}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativePushTextQuad(FFFFI)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 897
    nop

    .end local v0    # "wh":[I
    .end local v6    # "id":I
    .end local v7    # "key":Ljava/lang/String;
    .end local v8    # "x":F
    .end local v9    # "s":F
    .end local v10    # "y":F
    .end local v11    # "h":F
    .end local v12    # "text":Ljava/lang/String;
    .end local v13    # "color":I
    .end local v14    # "slot":I
    add-int/lit8 v3, v3, 0x1

    .line 899
    goto :goto_3

    .line 876
    .restart local v6    # "id":I
    .restart local v8    # "x":F
    .restart local v10    # "y":F
    .restart local v11    # "h":F
    .restart local v12    # "text":Ljava/lang/String;
    .restart local v13    # "color":I
    :cond_5
    :goto_2
    goto/16 :goto_0

    .line 898
    .end local v6    # "id":I
    .end local v8    # "x":F
    .end local v10    # "y":F
    .end local v11    # "h":F
    .end local v12    # "text":Ljava/lang/String;
    .end local v13    # "color":I
    :catchall_0
    move-exception v0

    .line 900
    .end local v5    # "p":[Ljava/lang/String;
    :goto_3
    goto/16 :goto_0

    .line 905
    .end local v3    # "n":I
    .end local v4    # "line":Ljava/lang/String;
    :cond_6
    nop

    .line 906
    :try_start_2
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 909
    :cond_7
    :goto_4
    goto :goto_5

    .line 908
    :catchall_1
    move-exception v0

    .line 910
    goto :goto_5

    .line 901
    :catchall_2
    move-exception v0

    .line 902
    .local v0, "t":Ljava/lang/Throwable;
    :try_start_3
    const-string v3, "PsyVK"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "pullTextRequests failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_3

    .line 905
    .end local v0    # "t":Ljava/lang/Throwable;
    if-eqz v2, :cond_7

    .line 906
    :try_start_4
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_4

    .line 911
    :goto_5
    return-void

    .line 904
    :catchall_3
    move-exception v0

    move-object v3, v0

    .line 905
    if-eqz v2, :cond_8

    .line 906
    :try_start_5
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    goto :goto_6

    .line 908
    :catchall_4
    move-exception v0

    goto :goto_7

    .line 909
    :cond_8
    :goto_6
    nop

    .line 910
    :goto_7
    throw v3
.end method

.method private static pullTextureRequests()V
    .locals 19

    .line 770
    const-string v1, "PsyVK"

    new-instance v0, Ljava/io/File;

    const-string v2, "/storage/emulated/0/Android/data/com.shadowmario.psychengine/files/vk_tex.txt"

    invoke-direct {v0, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    move-object v2, v0

    .line 771
    .local v2, "f":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 772
    return-void

    .line 775
    :cond_0
    const/4 v3, 0x0

    .line 777
    .local v3, "reader":Ljava/io/BufferedReader;
    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/FileReader;

    invoke-direct {v4, v2}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v0, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    move-object v3, v0

    .line 779
    const/4 v0, 0x0

    move v4, v0

    .line 781
    .local v4, "handled":I
    :goto_0
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    move-object v5, v0

    .local v5, "line":Ljava/lang/String;
    if-eqz v0, :cond_9

    const/16 v0, 0x18

    if-ge v4, v0, :cond_9

    .line 782
    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    move-object v5, v0

    .line 783
    const/16 v0, 0x9

    invoke-virtual {v5, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_4

    move v6, v0

    .line 784
    .local v6, "tab":I
    if-gtz v6, :cond_1

    .line 785
    goto :goto_0

    .line 788
    :cond_1
    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {v5, v0, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    .line 789
    .local v7, "slot":I
    add-int/lit8 v8, v6, 0x1

    invoke-virtual {v5, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    .line 790
    .local v8, "spec":Ljava/lang/String;
    const/16 v9, 0xb

    if-lt v7, v9, :cond_8

    const/16 v9, 0x2f

    if-gt v7, v9, :cond_8

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v9

    const/4 v10, 0x4

    if-ge v9, v10, :cond_2

    move-object/from16 v18, v5

    goto/16 :goto_6

    .line 795
    :cond_2
    const-string v9, "no candidate"

    .line 796
    .local v9, "lastErr":Ljava/lang/String;
    const/4 v11, 0x0

    .line 797
    .local v11, "ok":Z
    const-string v12, "\\|"

    invoke-virtual {v8, v12}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v12

    array-length v13, v12
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    :goto_1
    const-string v14, " <- "

    if-ge v0, v13, :cond_6

    :try_start_2
    aget-object v15, v12, v0

    .line 798
    .local v15, "cand":Ljava/lang/String;
    invoke-virtual {v15}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v16

    move-object/from16 v17, v16

    .line 799
    .local v17, "c":Ljava/lang/String;
    invoke-virtual/range {v17 .. v17}, Ljava/lang/String;->length()I

    move-result v10
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    move-object/from16 v18, v5

    const/4 v5, 0x4

    .end local v5    # "line":Ljava/lang/String;
    .local v18, "line":Ljava/lang/String;
    if-ge v10, v5, :cond_3

    .line 800
    goto :goto_2

    .line 802
    :cond_3
    move-object/from16 v10, v17

    .end local v17    # "c":Ljava/lang/String;
    .local v10, "c":Ljava/lang/String;
    :try_start_3
    invoke-static {v7, v10}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->addTexture(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v16

    .line 803
    .local v16, "err":Ljava/lang/String;
    if-eqz v16, :cond_5

    invoke-virtual/range {v16 .. v16}, Ljava/lang/String;->length()I

    move-result v17

    if-nez v17, :cond_4

    goto :goto_3

    .line 808
    :cond_4
    move-object/from16 v9, v16

    .line 797
    .end local v10    # "c":Ljava/lang/String;
    .end local v15    # "cand":Ljava/lang/String;
    .end local v16    # "err":Ljava/lang/String;
    :goto_2
    add-int/lit8 v0, v0, 0x1

    move-object/from16 v5, v18

    const/4 v10, 0x4

    goto :goto_1

    .line 804
    .restart local v10    # "c":Ljava/lang/String;
    .restart local v15    # "cand":Ljava/lang/String;
    .restart local v16    # "err":Ljava/lang/String;
    :cond_5
    :goto_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "tex request: slot "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 805
    const/4 v11, 0x1

    .line 806
    goto :goto_4

    .line 797
    .end local v10    # "c":Ljava/lang/String;
    .end local v15    # "cand":Ljava/lang/String;
    .end local v16    # "err":Ljava/lang/String;
    .end local v18    # "line":Ljava/lang/String;
    .restart local v5    # "line":Ljava/lang/String;
    :cond_6
    move-object/from16 v18, v5

    .line 810
    .end local v5    # "line":Ljava/lang/String;
    .restart local v18    # "line":Ljava/lang/String;
    :goto_4
    if-nez v11, :cond_7

    .line 811
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "tex request failed: slot "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, ": "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_5

    .line 814
    .end local v7    # "slot":I
    .end local v8    # "spec":Ljava/lang/String;
    .end local v9    # "lastErr":Ljava/lang/String;
    .end local v11    # "ok":Z
    :catchall_0
    move-exception v0

    goto :goto_7

    .line 813
    .restart local v7    # "slot":I
    .restart local v8    # "spec":Ljava/lang/String;
    .restart local v9    # "lastErr":Ljava/lang/String;
    .restart local v11    # "ok":Z
    :cond_7
    :goto_5
    nop

    .end local v7    # "slot":I
    .end local v8    # "spec":Ljava/lang/String;
    .end local v9    # "lastErr":Ljava/lang/String;
    .end local v11    # "ok":Z
    add-int/lit8 v4, v4, 0x1

    .line 815
    goto :goto_7

    .line 790
    .end local v18    # "line":Ljava/lang/String;
    .restart local v5    # "line":Ljava/lang/String;
    .restart local v7    # "slot":I
    .restart local v8    # "spec":Ljava/lang/String;
    :cond_8
    move-object/from16 v18, v5

    .line 791
    .end local v5    # "line":Ljava/lang/String;
    .restart local v18    # "line":Ljava/lang/String;
    :goto_6
    goto/16 :goto_0

    .line 814
    .end local v7    # "slot":I
    .end local v8    # "spec":Ljava/lang/String;
    .end local v18    # "line":Ljava/lang/String;
    .restart local v5    # "line":Ljava/lang/String;
    :catchall_1
    move-exception v0

    move-object/from16 v18, v5

    .line 816
    .end local v5    # "line":Ljava/lang/String;
    .end local v6    # "tab":I
    .restart local v18    # "line":Ljava/lang/String;
    :goto_7
    goto/16 :goto_0

    .line 821
    .end local v4    # "handled":I
    .end local v18    # "line":Ljava/lang/String;
    :cond_9
    nop

    .line 822
    :try_start_4
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    .line 825
    goto :goto_8

    .line 824
    :catchall_2
    move-exception v0

    .line 827
    :goto_8
    :try_start_5
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_3

    .line 829
    :goto_9
    goto :goto_c

    .line 828
    :catchall_3
    move-exception v0

    .line 830
    goto :goto_c

    .line 817
    :catchall_4
    move-exception v0

    .line 818
    .local v0, "t":Ljava/lang/Throwable;
    :try_start_6
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "pullTextureRequests failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_6

    .line 821
    .end local v0    # "t":Ljava/lang/Throwable;
    if-eqz v3, :cond_a

    .line 822
    :try_start_7
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_5

    goto :goto_a

    .line 824
    :catchall_5
    move-exception v0

    goto :goto_b

    .line 825
    :cond_a
    :goto_a
    nop

    .line 827
    :goto_b
    :try_start_8
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_3

    goto :goto_9

    .line 831
    :goto_c
    return-void

    .line 820
    :catchall_6
    move-exception v0

    move-object v1, v0

    .line 821
    if-eqz v3, :cond_b

    .line 822
    :try_start_9
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_7

    goto :goto_d

    .line 824
    :catchall_7
    move-exception v0

    goto :goto_e

    .line 825
    :cond_b
    :goto_d
    nop

    .line 827
    :goto_e
    :try_start_a
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_8

    .line 829
    goto :goto_f

    .line 828
    :catchall_8
    move-exception v0

    .line 830
    :goto_f
    throw v1
.end method

.method private static readMarker()Ljava/lang/String;
    .locals 9

    .line 98
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "/storage/emulated/0/.PsychEngine/mods/vulkan_surface.txt"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 100
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, "/.PsychEngine/mods/vulkan_surface.txt"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v3, 0x1

    aput-object v1, v0, v3

    .line 104
    .local v0, "paths":[Ljava/lang/String;
    array-length v1, v0

    :goto_0
    const-string v3, ""

    if-ge v2, v1, :cond_5

    aget-object v4, v0, v2

    .line 105
    .local v4, "p":Ljava/lang/String;
    const/4 v5, 0x0

    .line 107
    .local v5, "reader":Ljava/io/BufferedReader;
    :try_start_0
    new-instance v6, Ljava/io/File;

    invoke-direct {v6, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 108
    .local v6, "f":Ljava/io/File;
    invoke-virtual {v6}, Ljava/io/File;->exists()Z

    move-result v7
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-nez v7, :cond_1

    .line 118
    if-eqz v5, :cond_0

    .line 119
    :try_start_1
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    .line 121
    :catchall_0
    move-exception v3

    .line 109
    goto :goto_5

    .line 122
    :cond_0
    :goto_1
    goto :goto_5

    .line 111
    :cond_1
    :try_start_2
    new-instance v7, Ljava/io/BufferedReader;

    new-instance v8, Ljava/io/FileReader;

    invoke-direct {v8, v6}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v7, v8}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    move-object v5, v7

    .line 112
    invoke-virtual {v5}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v7

    .line 113
    .local v7, "line":Ljava/lang/String;
    if-nez v7, :cond_2

    goto :goto_2

    :cond_2
    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    .line 118
    :goto_2
    nop

    .line 119
    :try_start_3
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 122
    goto :goto_3

    .line 121
    :catchall_1
    move-exception v1

    .line 113
    :goto_3
    return-object v3

    .line 114
    .end local v6    # "f":Ljava/io/File;
    .end local v7    # "line":Ljava/lang/String;
    :catchall_2
    move-exception v3

    .line 115
    .local v3, "t":Ljava/lang/Throwable;
    :try_start_4
    const-string v6, "PsyVK"

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "readMarker failed for "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, ": "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_4

    .line 118
    .end local v3    # "t":Ljava/lang/Throwable;
    if-eqz v5, :cond_3

    .line 119
    :try_start_5
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_3

    goto :goto_4

    .line 121
    :catchall_3
    move-exception v3

    .line 123
    goto :goto_5

    .line 122
    :cond_3
    :goto_4
    nop

    .line 104
    .end local v4    # "p":Ljava/lang/String;
    .end local v5    # "reader":Ljava/io/BufferedReader;
    :goto_5
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 117
    .restart local v4    # "p":Ljava/lang/String;
    .restart local v5    # "reader":Ljava/io/BufferedReader;
    :catchall_4
    move-exception v1

    .line 118
    if-eqz v5, :cond_4

    .line 119
    :try_start_6
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_5

    goto :goto_6

    .line 121
    :catchall_5
    move-exception v2

    goto :goto_7

    .line 122
    :cond_4
    :goto_6
    nop

    .line 123
    :goto_7
    throw v1

    .line 125
    .end local v4    # "p":Ljava/lang/String;
    .end local v5    # "reader":Ljava/io/BufferedReader;
    :cond_5
    return-object v3
.end method

.method private static retry(Landroid/app/Activity;II)V
    .locals 4
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "width"    # I
    .param p2, "height"    # I

    .line 333
    sget-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->created:Z

    if-eqz v0, :cond_0

    .line 334
    return-void

    .line 336
    :cond_0
    sget v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    .line 337
    const/4 v1, 0x2

    if-le v0, v1, :cond_1

    .line 338
    return-void

    .line 341
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "retry "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ": "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->diag()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "PsyVK"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 344
    :try_start_0
    sget-object v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-eqz v0, :cond_3

    .line 345
    invoke-virtual {v0}, Landroid/view/SurfaceView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 346
    .local v0, "parent":Landroid/view/ViewGroup;
    if-eqz v0, :cond_2

    .line 347
    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 349
    :cond_2
    const/4 v2, 0x0

    sput-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 353
    .end local v0    # "parent":Landroid/view/ViewGroup;
    :cond_3
    goto :goto_0

    .line 351
    :catchall_0
    move-exception v0

    .line 352
    .local v0, "t":Ljava/lang/Throwable;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "could not remove old view: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 356
    .end local v0    # "t":Ljava/lang/Throwable;
    :goto_0
    sget v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->attempt:I

    .line 357
    .local v0, "mode":I
    new-instance v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;

    invoke-direct {v1, p0, p1, p2, v0}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;-><init>(Landroid/app/Activity;III)V

    invoke-static {p0, v1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->runOnUi(Landroid/app/Activity;Ljava/lang/Runnable;)V

    .line 363
    return-void
.end method

.method private static runOnUi(Landroid/app/Activity;Ljava/lang/Runnable;)V
    .locals 3
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "action"    # Ljava/lang/Runnable;

    .line 662
    :try_start_0
    invoke-virtual {p0, p1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 666
    goto :goto_0

    .line 663
    :catchall_0
    move-exception v0

    .line 664
    .local v0, "t":Ljava/lang/Throwable;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "runOnUiThread failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "PsyVK"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 665
    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    .line 667
    .end local v0    # "t":Ljava/lang/Throwable;
    :goto_0
    return-void
.end method

.method public static declared-synchronized showOverlay()V
    .locals 5

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 595
    :try_start_0
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Landroid/view/SurfaceView;->getTranslationY()F

    move-result v1

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-eqz v1, :cond_0

    .line 596
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v1, v2}, Landroid/view/SurfaceView;->setTranslationY(F)V

    .line 597
    const-string v1, "PsyVK"

    const-string v2, "overlay shown"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 601
    :cond_0
    goto :goto_0

    .line 599
    :catchall_0
    move-exception v1

    .line 600
    .local v1, "t":Ljava/lang/Throwable;
    :try_start_1
    const-string v2, "PsyVK"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "showOverlay failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 602
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    monitor-exit v0

    return-void

    .line 594
    :catchall_1
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method public static declared-synchronized start(II)Ljava/lang/String;
    .locals 13
    .param p0, "width"    # I
    .param p1, "height"    # I

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 148
    :try_start_0
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-eqz v1, :cond_0

    .line 149
    const-string v1, ""
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    .line 152
    :cond_0
    :try_start_1
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->checkDevice()Ljava/lang/String;

    move-result-object v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 153
    .local v1, "guard":Ljava/lang/String;
    if-eqz v1, :cond_1

    .line 154
    monitor-exit v0

    return-object v1

    .line 157
    :cond_1
    :try_start_2
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 158
    .local v2, "context":Landroid/content/Context;
    if-nez v2, :cond_2

    .line 159
    const-string v3, "no activity context yet"

    invoke-static {v3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    monitor-exit v0

    return-object v3

    .line 161
    :cond_2
    :try_start_3
    instance-of v3, v2, Landroid/app/Activity;

    if-nez v3, :cond_3

    .line 162
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "context is not an Activity: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    monitor-exit v0

    return-object v3

    .line 165
    :cond_3
    :try_start_4
    move-object v3, v2

    check-cast v3, Landroid/app/Activity;

    .line 166
    .local v3, "activity":Landroid/app/Activity;
    new-instance v4, Ljava/util/concurrent/CountDownLatch;

    const/4 v5, 0x1

    invoke-direct {v4, v5}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    move-object v10, v4

    .line 167
    .local v10, "latch":Ljava/util/concurrent/CountDownLatch;
    const-string v4, ""

    filled-new-array {v4}, [Ljava/lang/String;

    move-result-object v4

    move-object v11, v4

    .line 168
    .local v11, "result":[Ljava/lang/String;
    const-string v4, "posting to ui thread"

    sput-object v4, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 170
    new-instance v12, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;

    move-object v4, v12

    move-object v5, v11

    move-object v6, v3

    move v7, p0

    move v8, p1

    move-object v9, v10

    invoke-direct/range {v4 .. v9}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;-><init>([Ljava/lang/String;Landroid/app/Activity;IILjava/util/concurrent/CountDownLatch;)V

    invoke-static {v3, v12}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->runOnUi(Landroid/app/Activity;Ljava/lang/Runnable;)V

    .line 178
    const-wide/16 v4, 0x3

    sget-object v6, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v10, v4, v5, v6}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    .line 182
    const-wide/16 v4, 0x5dc

    new-instance v6, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;

    invoke-direct {v6, v3, p0, p1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;-><init>(Landroid/app/Activity;II)V

    invoke-static {v4, v5, v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->later(JLjava/lang/Runnable;)V

    .line 190
    const-wide/16 v4, 0xdac

    new-instance v6, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$3;

    invoke-direct {v6, v3, p0, p1}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$3;-><init>(Landroid/app/Activity;II)V

    invoke-static {v4, v5, v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->later(JLjava/lang/Runnable;)V

    .line 198
    const-wide/16 v4, 0x1388

    new-instance v6, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$4;

    invoke-direct {v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$4;-><init>()V

    invoke-static {v4, v5, v6}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->later(JLjava/lang/Runnable;)V

    .line 205
    const/4 v4, 0x0

    aget-object v4, v11, v4
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    monitor-exit v0

    return-object v4

    .line 206
    .end local v1    # "guard":Ljava/lang/String;
    .end local v2    # "context":Landroid/content/Context;
    .end local v3    # "activity":Landroid/app/Activity;
    .end local v10    # "latch":Ljava/util/concurrent/CountDownLatch;
    .end local v11    # "result":[Ljava/lang/String;
    :catchall_0
    move-exception v1

    .line 207
    .local v1, "t":Ljava/lang/Throwable;
    :try_start_5
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "start failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->fail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    monitor-exit v0

    return-object v2

    .line 147
    .end local v1    # "t":Ljava/lang/Throwable;
    .end local p0    # "width":I
    .end local p1    # "height":I
    :catchall_1
    move-exception p0

    monitor-exit v0

    throw p0
.end method

.method public static startDefault()Ljava/lang/String;
    .locals 9

    .line 66
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->readMarker()Ljava/lang/String;

    move-result-object v0

    .line 67
    .local v0, "marker":Ljava/lang/String;
    const-string v1, "full"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_1

    const-string v1, "screen"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v1, 0x1

    .line 69
    .local v1, "full":Z
    :goto_1
    const-string v3, "PsyVK"

    if-eqz v1, :cond_2

    .line 70
    const-string v4, "startDefault: marker says fullscreen"

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 71
    invoke-static {v2, v2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->start(II)Ljava/lang/String;

    move-result-object v2

    return-object v2

    .line 74
    :cond_2
    const/16 v4, 0x1e0

    .line 75
    .local v4, "w":I
    const/16 v5, 0x10e

    .line 76
    .local v5, "h":I
    const/16 v6, 0x78

    invoke-virtual {v0, v6}, Ljava/lang/String;->indexOf(I)I

    move-result v6

    .line 77
    .local v6, "x":I
    if-lez v6, :cond_4

    .line 79
    :try_start_0
    invoke-virtual {v0, v2, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    .line 80
    .local v2, "mw":I
    add-int/lit8 v7, v6, 0x1

    invoke-virtual {v0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 81
    .local v7, "mh":I
    if-lez v2, :cond_3

    if-lez v7, :cond_3

    const/16 v8, 0x1000

    if-gt v2, v8, :cond_3

    if-gt v7, v8, :cond_3

    .line 82
    move v4, v2

    .line 83
    move v5, v7

    .line 86
    .end local v2    # "mw":I
    .end local v7    # "mh":I
    :cond_3
    goto :goto_2

    .line 85
    :catchall_0
    move-exception v2

    .line 89
    :cond_4
    :goto_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "startDefault: marker=\""

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v7, "\" -> "

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v7, "x"

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 90
    invoke-static {v4, v5}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->start(II)Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method public static startFullscreen()Ljava/lang/String;
    .locals 2

    .line 136
    const-string v0, "PsyVK"

    const-string v1, "startFullscreen requested"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 137
    const/4 v0, 0x0

    invoke-static {v0, v0}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->start(II)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static startHudLoop()V
    .locals 3

    .line 749
    sget-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudLoopStarted:Z

    if-eqz v0, :cond_0

    .line 750
    return-void

    .line 752
    :cond_0
    const/4 v0, 0x1

    sput-boolean v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudLoopStarted:Z

    .line 753
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    const/4 v1, 0x3

    if-ge v0, v1, :cond_1

    .line 754
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudCache:[Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v2, v1, v0

    .line 753
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 756
    .end local v0    # "i":I
    :cond_1
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->hudTick()V

    .line 757
    return-void
.end method

.method public static declared-synchronized stop()V
    .locals 5

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 564
    :try_start_0
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->detach()V

    .line 565
    sget-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    if-eqz v1, :cond_1

    .line 566
    invoke-virtual {v1}, Landroid/view/SurfaceView;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    .line 567
    .local v1, "parent":Landroid/view/ViewGroup;
    if-eqz v1, :cond_0

    .line 568
    sget-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 570
    :cond_0
    const/4 v2, 0x0

    sput-object v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->view:Landroid/view/SurfaceView;

    .line 572
    .end local v1    # "parent":Landroid/view/ViewGroup;
    :cond_1
    const-string v1, "stopped"

    sput-object v1, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->stage:Ljava/lang/String;

    .line 573
    const-string v2, "PsyVK"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 576
    goto :goto_0

    .line 574
    :catchall_0
    move-exception v1

    .line 575
    .local v1, "t":Ljava/lang/Throwable;
    :try_start_1
    const-string v2, "PsyVK"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "stop failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 577
    .end local v1    # "t":Ljava/lang/Throwable;
    :goto_0
    monitor-exit v0

    return-void

    .line 563
    :catchall_1
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private static tryLoadAtlas()Z
    .locals 25

    .line 405
    const-string v1, "PsyVK"

    const-string v2, "assets/shared/images/noteSkins/NOTE_assets.xml"

    .line 406
    .local v2, "xmlPath":Ljava/lang/String;
    const-string v3, "assets/shared/images/noteSkins/NOTE_assets.png"

    .line 409
    .local v3, "pngPath":Ljava/lang/String;
    const/4 v4, 0x0

    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    move-object v5, v0

    .line 410
    .local v5, "ctx":Landroid/content/Context;
    invoke-virtual {v5}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    move-object v6, v0

    .line 413
    .local v6, "am":Landroid/content/res/AssetManager;
    const-string v0, "assets/shared/images/noteSkins/NOTE_assets.png"

    invoke-virtual {v6, v0}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_4

    move-object v7, v0

    .line 414
    .local v7, "is":Ljava/io/InputStream;
    :try_start_1
    invoke-static {v7}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    move-object/from16 v16, v0

    .line 415
    .local v16, "bmp":Landroid/graphics/Bitmap;
    if-eqz v7, :cond_0

    :try_start_2
    invoke-virtual {v7}, Ljava/io/InputStream;->close()V

    .line 416
    .end local v7    # "is":Ljava/io/InputStream;
    :cond_0
    if-nez v16, :cond_1

    .line 417
    return v4

    .line 422
    :cond_1
    invoke-static {}, Ljavax/xml/parsers/DocumentBuilderFactory;->newInstance()Ljavax/xml/parsers/DocumentBuilderFactory;

    move-result-object v0

    move-object v7, v0

    .line 423
    .local v7, "factory":Ljavax/xml/parsers/DocumentBuilderFactory;
    const-string v0, "assets/shared/images/noteSkins/NOTE_assets.xml"

    invoke-virtual {v6, v0}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_4

    move-object v8, v0

    .line 424
    .local v8, "is":Ljava/io/InputStream;
    :try_start_3
    invoke-virtual {v7}, Ljavax/xml/parsers/DocumentBuilderFactory;->newDocumentBuilder()Ljavax/xml/parsers/DocumentBuilder;

    move-result-object v0

    invoke-virtual {v0, v8}, Ljavax/xml/parsers/DocumentBuilder;->parse(Ljava/io/InputStream;)Lorg/w3c/dom/Document;

    move-result-object v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 425
    .local v0, "doc":Lorg/w3c/dom/Document;
    if-eqz v8, :cond_2

    :try_start_4
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V

    .line 427
    .end local v8    # "is":Ljava/io/InputStream;
    :cond_2
    const-string v8, "SubTexture"

    invoke-interface {v0, v8}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v8

    move-object v15, v8

    .line 428
    .local v15, "list":Lorg/w3c/dom/NodeList;
    invoke-interface {v15}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v8

    move v14, v8

    .line 429
    .local v14, "n":I
    if-gtz v14, :cond_3

    .line 430
    invoke-virtual/range {v16 .. v16}, Landroid/graphics/Bitmap;->recycle()V

    .line 431
    return v4

    .line 434
    :cond_3
    mul-int/lit8 v8, v14, 0x4

    new-array v8, v8, [I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_4

    move-object v13, v8

    .line 435
    .local v13, "rects":[I
    const/4 v8, 0x0

    .local v8, "i":I
    :goto_0
    const-string v12, "x"

    const/16 v17, 0x1

    if-ge v8, v14, :cond_4

    .line 436
    :try_start_5
    invoke-interface {v15, v8}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v9

    check-cast v9, Lorg/w3c/dom/Element;

    .line 437
    .local v9, "e":Lorg/w3c/dom/Element;
    mul-int/lit8 v10, v8, 0x4

    add-int/2addr v10, v4

    invoke-interface {v9, v12}, Lorg/w3c/dom/Element;->getAttribute(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11

    aput v11, v13, v10

    .line 438
    mul-int/lit8 v10, v8, 0x4

    add-int/lit8 v10, v10, 0x1

    const-string v11, "y"

    invoke-interface {v9, v11}, Lorg/w3c/dom/Element;->getAttribute(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11

    aput v11, v13, v10

    .line 439
    mul-int/lit8 v10, v8, 0x4

    add-int/lit8 v10, v10, 0x2

    const-string v11, "width"

    invoke-interface {v9, v11}, Lorg/w3c/dom/Element;->getAttribute(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11

    aput v11, v13, v10

    .line 440
    mul-int/lit8 v10, v8, 0x4

    add-int/lit8 v10, v10, 0x3

    const-string v11, "height"

    invoke-interface {v9, v11}, Lorg/w3c/dom/Element;->getAttribute(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11

    aput v11, v13, v10

    .line 435
    .end local v9    # "e":Lorg/w3c/dom/Element;
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 443
    .end local v8    # "i":I
    :cond_4
    invoke-virtual/range {v16 .. v16}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v8

    move v11, v8

    .line 444
    .local v11, "bw":I
    invoke-virtual/range {v16 .. v16}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v8

    move v10, v8

    .line 445
    .local v10, "bh":I
    mul-int v8, v11, v10

    new-array v8, v8, [I

    move-object v9, v8

    .line 446
    .local v9, "px":[I
    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v20, 0x0

    move-object/from16 v8, v16

    move-object/from16 v21, v9

    .end local v9    # "px":[I
    .local v21, "px":[I
    move/from16 v22, v10

    .end local v10    # "bh":I
    .local v22, "bh":I
    move/from16 v10, v18

    move/from16 v18, v11

    .end local v11    # "bw":I
    .local v18, "bw":I
    move-object v4, v12

    move/from16 v12, v19

    move-object/from16 v23, v13

    .end local v13    # "rects":[I
    .local v23, "rects":[I
    move/from16 v13, v20

    move/from16 v24, v14

    .end local v14    # "n":I
    .local v24, "n":I
    move/from16 v14, v18

    move-object/from16 v19, v15

    .end local v15    # "list":Lorg/w3c/dom/NodeList;
    .local v19, "list":Lorg/w3c/dom/NodeList;
    move/from16 v15, v22

    invoke-virtual/range {v8 .. v15}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 447
    invoke-virtual/range {v16 .. v16}, Landroid/graphics/Bitmap;->recycle()V

    .line 449
    move/from16 v10, v18

    move-object/from16 v12, v21

    move/from16 v11, v22

    move-object/from16 v9, v23

    move/from16 v8, v24

    .end local v18    # "bw":I
    .end local v21    # "px":[I
    .end local v22    # "bh":I
    .end local v23    # "rects":[I
    .end local v24    # "n":I
    .local v8, "n":I
    .local v9, "rects":[I
    .local v10, "bw":I
    .local v11, "bh":I
    .local v12, "px":[I
    invoke-static {v12, v10, v11, v9, v8}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->nativeSetAtlas([III[II)V

    .line 450
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "atlas from assets/shared/images/noteSkins/NOTE_assets.xml ("

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v13, ", "

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v13, " frames)"

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    .line 451
    return v17

    .line 423
    .end local v0    # "doc":Lorg/w3c/dom/Document;
    .end local v9    # "rects":[I
    .end local v10    # "bw":I
    .end local v11    # "bh":I
    .end local v12    # "px":[I
    .end local v19    # "list":Lorg/w3c/dom/NodeList;
    .local v8, "is":Ljava/io/InputStream;
    :catchall_0
    move-exception v0

    move-object v4, v0

    if-eqz v8, :cond_5

    :try_start_6
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v0

    move-object v9, v0

    :try_start_7
    invoke-virtual {v4, v9}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    .end local v2    # "xmlPath":Ljava/lang/String;
    .end local v3    # "pngPath":Ljava/lang/String;
    :cond_5
    :goto_1
    throw v4
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_4

    .line 413
    .end local v8    # "is":Ljava/io/InputStream;
    .end local v16    # "bmp":Landroid/graphics/Bitmap;
    .restart local v2    # "xmlPath":Ljava/lang/String;
    .restart local v3    # "pngPath":Ljava/lang/String;
    .local v7, "is":Ljava/io/InputStream;
    :catchall_2
    move-exception v0

    move-object v4, v0

    if-eqz v7, :cond_6

    :try_start_8
    invoke-virtual {v7}, Ljava/io/InputStream;->close()V
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_3

    goto :goto_2

    :catchall_3
    move-exception v0

    move-object v8, v0

    :try_start_9
    invoke-virtual {v4, v8}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    .end local v2    # "xmlPath":Ljava/lang/String;
    .end local v3    # "pngPath":Ljava/lang/String;
    :cond_6
    :goto_2
    throw v4
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_4

    .line 452
    .end local v5    # "ctx":Landroid/content/Context;
    .end local v6    # "am":Landroid/content/res/AssetManager;
    .end local v7    # "is":Ljava/io/InputStream;
    .restart local v2    # "xmlPath":Ljava/lang/String;
    .restart local v3    # "pngPath":Ljava/lang/String;
    :catchall_4
    move-exception v0

    .line 453
    .local v0, "t":Ljava/lang/Throwable;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "atlas load failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 454
    const/4 v1, 0x0

    return v1
.end method

.method public static declared-synchronized viewSize()Ljava/lang/String;
    .locals 3

    const-class v0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;

    monitor-enter v0

    .line 142
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    sget v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastWidth:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    sget v2, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->lastHeight:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    .line 142
    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method
