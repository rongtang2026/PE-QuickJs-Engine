.class public Lorg/libsdl/app/SDLActivity;
.super Landroid/app/Activity;
.source "SDLActivity.java"

# interfaces
.implements Landroid/view/View$OnSystemUiVisibilityChangeListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/libsdl/app/SDLActivity$SDLCommandHandler;,
        Lorg/libsdl/app/SDLActivity$NativeState;,
        Lorg/libsdl/app/SDLActivity$ShowTextInputTask;
    }
.end annotation


# static fields
.field static final COMMAND_CHANGE_SURFACEVIEW_FORMAT:I = 0x4

.field static final COMMAND_CHANGE_TITLE:I = 0x1

.field static final COMMAND_CHANGE_WINDOW_STYLE:I = 0x2

.field static final COMMAND_SET_KEEP_SCREEN_ON:I = 0x5

.field static final COMMAND_TEXTEDIT_HIDE:I = 0x3

.field protected static final COMMAND_USER:I = 0x8000

.field protected static final SDL_ORIENTATION_LANDSCAPE:I = 0x1

.field protected static final SDL_ORIENTATION_LANDSCAPE_FLIPPED:I = 0x2

.field protected static final SDL_ORIENTATION_PORTRAIT:I = 0x3

.field protected static final SDL_ORIENTATION_PORTRAIT_FLIPPED:I = 0x4

.field protected static final SDL_ORIENTATION_UNKNOWN:I = 0x0

.field private static final SDL_SYSTEM_CURSOR_ARROW:I = 0x0

.field private static final SDL_SYSTEM_CURSOR_CROSSHAIR:I = 0x3

.field private static final SDL_SYSTEM_CURSOR_HAND:I = 0xb

.field private static final SDL_SYSTEM_CURSOR_IBEAM:I = 0x1

.field private static final SDL_SYSTEM_CURSOR_NO:I = 0xa

.field private static final SDL_SYSTEM_CURSOR_NONE:I = -0x1

.field private static final SDL_SYSTEM_CURSOR_SIZEALL:I = 0x9

.field private static final SDL_SYSTEM_CURSOR_SIZENESW:I = 0x6

.field private static final SDL_SYSTEM_CURSOR_SIZENS:I = 0x8

.field private static final SDL_SYSTEM_CURSOR_SIZENWSE:I = 0x5

.field private static final SDL_SYSTEM_CURSOR_SIZEWE:I = 0x7

.field private static final SDL_SYSTEM_CURSOR_WAIT:I = 0x2

.field private static final SDL_SYSTEM_CURSOR_WAITARROW:I = 0x4

.field private static final TAG:Ljava/lang/String; = "SDL"

.field private static expansionFile:Ljava/lang/Object;

.field private static expansionFileMethod:Ljava/lang/reflect/Method;

.field public static mBrokenLibraries:Z

.field protected static mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

.field public static mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

.field protected static mCurrentOrientation:I

.field protected static mCursors:Ljava/util/Hashtable;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Hashtable<",
            "Ljava/lang/Integer;",
            "Landroid/view/PointerIcon;",
            ">;"
        }
    .end annotation
.end field

.field protected static mFullscreenModeActive:Z

.field protected static mHIDDeviceManager:Lorg/libsdl/app/HIDDeviceManager;

.field public static mHasFocus:Z

.field public static final mHasMultiWindow:Z

.field public static mIsResumedCalled:Z

.field protected static mLastCursorID:I

.field protected static mLayout:Landroid/view/ViewGroup;

.field protected static mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

.field public static mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

.field protected static mSDLThread:Ljava/lang/Thread;

.field protected static mScreenKeyboardShown:Z

.field protected static mSingleton:Lorg/libsdl/app/SDLActivity;

.field protected static mSurface:Lorg/libsdl/app/SDLSurface;

.field protected static mTextEdit:Landroid/view/View;


# instance fields
.field commandHandler:Landroid/os/Handler;

.field protected dialogs:I

.field protected final messageboxSelection:[I

.field private final rehideSystemUi:Ljava/lang/Runnable;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 41
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x18

    if-lt v0, v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    sput-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 37
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 694
    new-instance v0, Lorg/libsdl/app/SDLActivity$SDLCommandHandler;

    invoke-direct {v0}, Lorg/libsdl/app/SDLActivity$SDLCommandHandler;-><init>()V

    iput-object v0, p0, Lorg/libsdl/app/SDLActivity;->commandHandler:Landroid/os/Handler;

    .line 1271
    const/4 v0, 0x1

    new-array v0, v0, [I

    iput-object v0, p0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    .line 1274
    const/4 v0, 0x0

    iput v0, p0, Lorg/libsdl/app/SDLActivity;->dialogs:I

    .line 1473
    new-instance v0, Lorg/libsdl/app/SDLActivity$7;

    invoke-direct {v0, p0}, Lorg/libsdl/app/SDLActivity$7;-><init>(Lorg/libsdl/app/SDLActivity;)V

    iput-object v0, p0, Lorg/libsdl/app/SDLActivity;->rehideSystemUi:Ljava/lang/Runnable;

    return-void
.end method

.method public static clipboardGetText()Ljava/lang/String;
    .locals 1

    .line 1510
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

    invoke-interface {v0}, Lorg/libsdl/app/SDLClipboardHandler;->clipboardGetText()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static clipboardHasText()Z
    .locals 1

    .line 1503
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

    invoke-interface {v0}, Lorg/libsdl/app/SDLClipboardHandler;->clipboardHasText()Z

    move-result v0

    return v0
.end method

.method public static clipboardSetText(Ljava/lang/String;)V
    .locals 1
    .param p0, "string"    # Ljava/lang/String;

    .line 1517
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

    invoke-interface {v0, p0}, Lorg/libsdl/app/SDLClipboardHandler;->clipboardSetText(Ljava/lang/String;)V

    .line 1518
    return-void
.end method

.method public static createCustomCursor([IIIII)I
    .locals 6
    .param p0, "colors"    # [I
    .param p1, "width"    # I
    .param p2, "height"    # I
    .param p3, "hotSpotX"    # I
    .param p4, "hotSpotY"    # I

    .line 1524
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {p0, p1, p2, v0}, Landroid/graphics/Bitmap;->createBitmap([IIILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 1525
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    sget v1, Lorg/libsdl/app/SDLActivity;->mLastCursorID:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lorg/libsdl/app/SDLActivity;->mLastCursorID:I

    .line 1527
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v2, 0x0

    const/16 v3, 0x18

    if-lt v1, v3, :cond_0

    .line 1529
    :try_start_0
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mCursors:Ljava/util/Hashtable;

    sget v3, Lorg/libsdl/app/SDLActivity;->mLastCursorID:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    int-to-float v4, p3

    int-to-float v5, p4

    invoke-static {v0, v4, v5}, Landroid/view/PointerIcon;->create(Landroid/graphics/Bitmap;FF)Landroid/view/PointerIcon;

    move-result-object v4

    invoke-virtual {v1, v3, v4}, Ljava/util/Hashtable;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1532
    nop

    .line 1536
    sget v1, Lorg/libsdl/app/SDLActivity;->mLastCursorID:I

    return v1

    .line 1530
    :catch_0
    move-exception v1

    .line 1531
    .local v1, "e":Ljava/lang/Exception;
    return v2

    .line 1534
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_0
    return v2
.end method

.method public static getContentView()Landroid/view/View;
    .locals 1

    .line 1094
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mLayout:Landroid/view/ViewGroup;

    return-object v0
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .line 987
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v0

    return-object v0
.end method

.method public static getCurrentOrientation()I
    .locals 4

    .line 347
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 348
    .local v0, "context":Landroid/content/Context;
    const-string v1, "window"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    .line 350
    .local v1, "display":Landroid/view/Display;
    const/4 v2, 0x0

    .line 352
    .local v2, "result":I
    invoke-virtual {v1}, Landroid/view/Display;->getRotation()I

    move-result v3

    packed-switch v3, :pswitch_data_0

    goto :goto_0

    .line 366
    :pswitch_0
    const/4 v2, 0x2

    goto :goto_0

    .line 362
    :pswitch_1
    const/4 v2, 0x4

    .line 363
    goto :goto_0

    .line 358
    :pswitch_2
    const/4 v2, 0x1

    .line 359
    goto :goto_0

    .line 354
    :pswitch_3
    const/4 v2, 0x3

    .line 355
    nop

    .line 370
    :goto_0
    return v2

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static getDisplayDPI()Landroid/util/DisplayMetrics;
    .locals 1

    .line 1061
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    return-object v0
.end method

.method public static getManifestEnvironmentVariables()Z
    .locals 9

    .line 1069
    const/4 v0, 0x0

    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const/16 v3, 0x80

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v1

    .line 1070
    .local v1, "applicationInfo":Landroid/content/pm/ApplicationInfo;
    iget-object v2, v1, Landroid/content/pm/ApplicationInfo;->metaData:Landroid/os/Bundle;

    .line 1071
    .local v2, "bundle":Landroid/os/Bundle;
    if-nez v2, :cond_0

    .line 1072
    return v0

    .line 1074
    :cond_0
    const-string v3, "SDL_ENV."

    .line 1075
    .local v3, "prefix":Ljava/lang/String;
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    .line 1076
    .local v4, "trimLength":I
    invoke-virtual {v2}, Landroid/os/Bundle;->keySet()Ljava/util/Set;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_0
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_2

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 1077
    .local v6, "key":Ljava/lang/String;
    invoke-virtual {v6, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 1078
    invoke-virtual {v6, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v7

    .line 1079
    .local v7, "name":Ljava/lang/String;
    invoke-virtual {v2, v6}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    .line 1080
    .local v8, "value":Ljava/lang/String;
    invoke-static {v7, v8}, Lorg/libsdl/app/SDLActivity;->nativeSetenv(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1082
    .end local v6    # "key":Ljava/lang/String;
    .end local v7    # "name":Ljava/lang/String;
    .end local v8    # "value":Ljava/lang/String;
    :cond_1
    goto :goto_0

    .line 1084
    :cond_2
    const/4 v0, 0x1

    return v0

    .line 1085
    .end local v1    # "applicationInfo":Landroid/content/pm/ApplicationInfo;
    .end local v2    # "bundle":Landroid/os/Bundle;
    .end local v3    # "prefix":Ljava/lang/String;
    .end local v4    # "trimLength":I
    :catch_0
    move-exception v1

    .line 1086
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "exception "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v1}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "SDL"

    invoke-static {v3, v2}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1088
    .end local v1    # "e":Ljava/lang/Exception;
    return v0
.end method

.method protected static getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;
    .locals 2

    .line 93
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

    if-nez v0, :cond_2

    .line 94
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 95
    new-instance v0, Lorg/libsdl/app/SDLGenericMotionListener_API26;

    invoke-direct {v0}, Lorg/libsdl/app/SDLGenericMotionListener_API26;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

    goto :goto_0

    .line 97
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x18

    if-lt v0, v1, :cond_1

    .line 98
    new-instance v0, Lorg/libsdl/app/SDLGenericMotionListener_API24;

    invoke-direct {v0}, Lorg/libsdl/app/SDLGenericMotionListener_API24;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

    goto :goto_0

    .line 100
    :cond_1
    new-instance v0, Lorg/libsdl/app/SDLGenericMotionListener_API12;

    invoke-direct {v0}, Lorg/libsdl/app/SDLGenericMotionListener_API12;-><init>()V

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

    .line 104
    :cond_2
    :goto_0
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mMotionListener:Lorg/libsdl/app/SDLGenericMotionListener_API12;

    return-object v0
.end method

.method public static getNativeSurface()Landroid/view/Surface;
    .locals 1

    .line 1168
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    if-nez v0, :cond_0

    .line 1169
    const/4 v0, 0x0

    return-object v0

    .line 1171
    :cond_0
    invoke-virtual {v0}, Lorg/libsdl/app/SDLSurface;->getNativeSurface()Landroid/view/Surface;

    move-result-object v0

    return-object v0
.end method

.method public static handleNativeState()V
    .locals 3

    .line 507
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sget-object v1, Lorg/libsdl/app/SDLActivity;->mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    if-ne v0, v1, :cond_0

    .line 509
    return-void

    .line 513
    :cond_0
    sget-object v1, Lorg/libsdl/app/SDLActivity$NativeState;->INIT:Lorg/libsdl/app/SDLActivity$NativeState;

    if-ne v0, v1, :cond_1

    .line 515
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 516
    return-void

    .line 520
    :cond_1
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sget-object v1, Lorg/libsdl/app/SDLActivity$NativeState;->PAUSED:Lorg/libsdl/app/SDLActivity$NativeState;

    if-ne v0, v1, :cond_4

    .line 521
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    if-eqz v0, :cond_2

    .line 522
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativePause()V

    .line 524
    :cond_2
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    if-eqz v0, :cond_3

    .line 525
    invoke-virtual {v0}, Lorg/libsdl/app/SDLSurface;->handlePause()V

    .line 527
    :cond_3
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 528
    return-void

    .line 532
    :cond_4
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sget-object v1, Lorg/libsdl/app/SDLActivity$NativeState;->RESUMED:Lorg/libsdl/app/SDLActivity$NativeState;

    if-ne v0, v1, :cond_6

    .line 533
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    iget-boolean v0, v0, Lorg/libsdl/app/SDLSurface;->mIsSurfaceReady:Z

    if-eqz v0, :cond_6

    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasFocus:Z

    if-eqz v0, :cond_6

    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mIsResumedCalled:Z

    if-eqz v0, :cond_6

    .line 534
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    if-nez v0, :cond_5

    .line 539
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lorg/libsdl/app/SDLMain;

    invoke-direct {v1}, Lorg/libsdl/app/SDLMain;-><init>()V

    const-string v2, "SDLThread"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    .line 540
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, v1}, Lorg/libsdl/app/SDLSurface;->enableSensor(IZ)V

    .line 541
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 544
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLSurface;->handleResume()V

    goto :goto_0

    .line 546
    :cond_5
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativeResume()V

    .line 547
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLSurface;->handleResume()V

    .line 550
    :goto_0
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 553
    :cond_6
    return-void
.end method

.method public static initTouch()V
    .locals 5

    .line 1188
    invoke-static {}, Landroid/view/InputDevice;->getDeviceIds()[I

    move-result-object v0

    .line 1190
    .local v0, "ids":[I
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v2, v0

    if-ge v1, v2, :cond_1

    .line 1191
    aget v2, v0, v1

    invoke-static {v2}, Landroid/view/InputDevice;->getDevice(I)Landroid/view/InputDevice;

    move-result-object v2

    .line 1192
    .local v2, "device":Landroid/view/InputDevice;
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/view/InputDevice;->getSources()I

    move-result v3

    and-int/lit16 v3, v3, 0x1002

    if-eqz v3, :cond_0

    .line 1193
    invoke-virtual {v2}, Landroid/view/InputDevice;->getId()I

    move-result v3

    invoke-virtual {v2}, Landroid/view/InputDevice;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Lorg/libsdl/app/SDLActivity;->nativeAddTouch(ILjava/lang/String;)V

    .line 1190
    .end local v2    # "device":Landroid/view/InputDevice;
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1196
    .end local v1    # "i":I
    :cond_1
    return-void
.end method

.method public static initialize()V
    .locals 2

    .line 170
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    .line 171
    sput-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    .line 172
    sput-object v0, Lorg/libsdl/app/SDLActivity;->mTextEdit:Landroid/view/View;

    .line 173
    sput-object v0, Lorg/libsdl/app/SDLActivity;->mLayout:Landroid/view/ViewGroup;

    .line 174
    sput-object v0, Lorg/libsdl/app/SDLActivity;->mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

    .line 175
    new-instance v1, Ljava/util/Hashtable;

    invoke-direct {v1}, Ljava/util/Hashtable;-><init>()V

    sput-object v1, Lorg/libsdl/app/SDLActivity;->mCursors:Ljava/util/Hashtable;

    .line 176
    const/4 v1, 0x0

    sput v1, Lorg/libsdl/app/SDLActivity;->mLastCursorID:I

    .line 177
    sput-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    .line 178
    sput-boolean v1, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    .line 179
    sput-boolean v1, Lorg/libsdl/app/SDLActivity;->mIsResumedCalled:Z

    .line 180
    const/4 v0, 0x1

    sput-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasFocus:Z

    .line 181
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->INIT:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 182
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->INIT:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mCurrentNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 183
    return-void
.end method

.method public static isAndroidTV()Z
    .locals 5

    .line 994
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "uimode"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/UiModeManager;

    .line 995
    .local v0, "uiModeManager":Landroid/app/UiModeManager;
    invoke-virtual {v0}, Landroid/app/UiModeManager;->getCurrentModeType()I

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x4

    if-ne v1, v3, :cond_0

    .line 996
    return v2

    .line 998
    :cond_0
    sget-object v1, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    const-string v3, "MINIX"

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    sget-object v1, Landroid/os/Build;->MODEL:Ljava/lang/String;

    const-string v3, "NEO-U1"

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 999
    return v2

    .line 1001
    :cond_1
    sget-object v1, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    const-string v3, "Amlogic"

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    sget-object v1, Landroid/os/Build;->MODEL:Ljava/lang/String;

    const-string v4, "X96-W"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1002
    return v2

    .line 1004
    :cond_2
    sget-object v1, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3

    sget-object v1, Landroid/os/Build;->MODEL:Ljava/lang/String;

    const-string v3, "TV"

    invoke-virtual {v1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 1005
    return v2

    .line 1007
    :cond_3
    const/4 v1, 0x0

    return v1
.end method

.method public static isChromebook()Z
    .locals 2

    .line 1034
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1035
    const/4 v0, 0x0

    return v0

    .line 1037
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const-string v1, "org.chromium.arc.device_management"

    invoke-virtual {v0, v1}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public static isDeXMode()Z
    .locals 5

    .line 1044
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x18

    if-ge v0, v2, :cond_0

    .line 1045
    return v1

    .line 1048
    :cond_0
    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    .line 1049
    .local v0, "config":Landroid/content/res/Configuration;
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    .line 1050
    .local v2, "configClass":Ljava/lang/Class;
    const-string v3, "SEM_DESKTOP_MODE_ENABLED"

    invoke-virtual {v2, v3}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v3

    const-string v4, "semDesktopModeEnabled"

    .line 1051
    invoke-virtual {v2, v4}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v4
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-ne v3, v4, :cond_1

    const/4 v1, 0x1

    .line 1050
    :cond_1
    return v1

    .line 1052
    .end local v0    # "config":Landroid/content/res/Configuration;
    .end local v2    # "configClass":Ljava/lang/Class;
    :catch_0
    move-exception v0

    .line 1053
    .local v0, "ignored":Ljava/lang/Exception;
    return v1
.end method

.method public static isScreenKeyboardShown()Z
    .locals 2

    .line 924
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mTextEdit:Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 925
    return v1

    .line 928
    :cond_0
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mScreenKeyboardShown:Z

    if-nez v0, :cond_1

    .line 929
    return v1

    .line 932
    :cond_1
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "input_method"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    .line 933
    .local v0, "imm":Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual {v0}, Landroid/view/inputmethod/InputMethodManager;->isAcceptingText()Z

    move-result v1

    return v1
.end method

.method public static isTablet()Z
    .locals 12

    .line 1014
    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 1015
    .local v0, "metrics":Landroid/util/DisplayMetrics;
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v1

    check-cast v1, Landroid/app/Activity;

    .line 1016
    .local v1, "activity":Landroid/app/Activity;
    const/4 v2, 0x0

    if-nez v1, :cond_0

    .line 1017
    return v2

    .line 1019
    :cond_0
    invoke-virtual {v1}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v3

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-virtual {v3, v0}, Landroid/view/Display;->getMetrics(Landroid/util/DisplayMetrics;)V

    .line 1021
    iget v3, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-double v3, v3

    iget v5, v0, Landroid/util/DisplayMetrics;->xdpi:F

    float-to-double v5, v5

    div-double/2addr v3, v5

    .line 1022
    .local v3, "dWidthInches":D
    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-double v5, v5

    iget v7, v0, Landroid/util/DisplayMetrics;->ydpi:F

    float-to-double v7, v7

    div-double/2addr v5, v7

    .line 1024
    .local v5, "dHeightInches":D
    mul-double v7, v3, v3

    mul-double v9, v5, v5

    add-double/2addr v7, v9

    invoke-static {v7, v8}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v7

    .line 1027
    .local v7, "dDiagonal":D
    const-wide/high16 v9, 0x401c000000000000L    # 7.0

    cmpl-double v11, v7, v9

    if-ltz v11, :cond_1

    const/4 v2, 0x1

    :cond_1
    return v2
.end method

.method public static isTextInputEvent(Landroid/view/KeyEvent;)Z
    .locals 3
    .param p0, "event"    # Landroid/view/KeyEvent;

    .line 1157
    invoke-virtual {p0}, Landroid/view/KeyEvent;->isCtrlPressed()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 1158
    return v1

    .line 1161
    :cond_0
    invoke-virtual {p0}, Landroid/view/KeyEvent;->isPrintingKey()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v2, 0x3e

    if-ne v0, v2, :cond_2

    :cond_1
    const/4 v1, 0x1

    :cond_2
    return v1
.end method

.method public static manualBackButton()V
    .locals 1

    .line 464
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->pressBackButton()V

    .line 465
    return-void
.end method

.method public static minimizeWindow()V
    .locals 2

    .line 885
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    if-nez v0, :cond_0

    .line 886
    return-void

    .line 889
    :cond_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MAIN"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 890
    .local v0, "startMain":Landroid/content/Intent;
    const-string v1, "android.intent.category.HOME"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 891
    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    .line 892
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v1, v0}, Lorg/libsdl/app/SDLActivity;->startActivity(Landroid/content/Intent;)V

    .line 893
    return-void
.end method

.method public static native nativeAddTouch(ILjava/lang/String;)V
.end method

.method public static native nativeFocusChanged(Z)V
.end method

.method public static native nativeGetHint(Ljava/lang/String;)Ljava/lang/String;
.end method

.method public static native nativeLowMemory()V
.end method

.method public static native nativePause()V
.end method

.method public static native nativePermissionResult(IZ)V
.end method

.method public static native nativeQuit()V
.end method

.method public static native nativeResume()V
.end method

.method public static native nativeRunMain(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)I
.end method

.method public static native nativeSendQuit()V
.end method

.method public static native nativeSetScreenResolution(IIIIIF)V
.end method

.method public static native nativeSetenv(Ljava/lang/String;Ljava/lang/String;)V
.end method

.method public static native nativeSetupJNI()I
.end method

.method public static native onNativeAccel(FFF)V
.end method

.method public static native onNativeClipboardChanged()V
.end method

.method public static native onNativeDropFile(Ljava/lang/String;)V
.end method

.method public static native onNativeKeyDown(I)V
.end method

.method public static native onNativeKeyUp(I)V
.end method

.method public static native onNativeKeyboardFocusLost()V
.end method

.method public static native onNativeMouse(IIFFZ)V
.end method

.method public static native onNativeOrientationChanged(I)V
.end method

.method public static native onNativeResize()V
.end method

.method public static native onNativeSoftReturnKey()Z
.end method

.method public static native onNativeSurfaceChanged()V
.end method

.method public static native onNativeSurfaceCreated()V
.end method

.method public static native onNativeSurfaceDestroyed()V
.end method

.method public static native onNativeTouch(IIIFFF)V
.end method

.method public static openAPKExpansionInputStream(Ljava/lang/String;)Ljava/io/InputStream;
    .locals 13
    .param p0, "fileName"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1213
    sget-object v0, Lorg/libsdl/app/SDLActivity;->expansionFile:Ljava/lang/Object;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_2

    .line 1214
    const-string v0, "SDL_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION"

    invoke-static {v0}, Lorg/libsdl/app/SDLActivity;->nativeGetHint(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1215
    .local v0, "mainHint":Ljava/lang/String;
    const/4 v3, 0x0

    if-nez v0, :cond_0

    .line 1216
    return-object v3

    .line 1218
    :cond_0
    const-string v4, "SDL_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION"

    invoke-static {v4}, Lorg/libsdl/app/SDLActivity;->nativeGetHint(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1219
    .local v4, "patchHint":Ljava/lang/String;
    if-nez v4, :cond_1

    .line 1220
    return-object v3

    .line 1226
    :cond_1
    :try_start_0
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v5

    .line 1227
    .local v5, "mainVersion":Ljava/lang/Integer;
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v6
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1231
    .local v6, "patchVersion":Ljava/lang/Integer;
    nop

    .line 1236
    :try_start_1
    const-string v7, "com.android.vending.expansion.zipfile.APKExpansionSupport"

    invoke-static {v7}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    const-string v8, "getAPKExpansionZipFile"

    const/4 v9, 0x3

    new-array v10, v9, [Ljava/lang/Class;

    const-class v11, Landroid/content/Context;

    aput-object v11, v10, v1

    sget-object v11, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v11, v10, v2

    sget-object v11, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v12, 0x2

    aput-object v11, v10, v12

    .line 1237
    invoke-virtual {v7, v8, v10}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    new-array v8, v9, [Ljava/lang/Object;

    .line 1238
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v9

    aput-object v9, v8, v1

    aput-object v5, v8, v2

    aput-object v6, v8, v12

    invoke-virtual {v7, v3, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    sput-object v7, Lorg/libsdl/app/SDLActivity;->expansionFile:Ljava/lang/Object;

    .line 1240
    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    const-string v8, "getInputStream"

    new-array v9, v2, [Ljava/lang/Class;

    const-class v10, Ljava/lang/String;

    aput-object v10, v9, v1

    .line 1241
    invoke-virtual {v7, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    sput-object v7, Lorg/libsdl/app/SDLActivity;->expansionFileMethod:Ljava/lang/reflect/Method;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 1247
    goto :goto_0

    .line 1242
    :catch_0
    move-exception v1

    .line 1243
    .local v1, "ex":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 1244
    sput-object v3, Lorg/libsdl/app/SDLActivity;->expansionFile:Ljava/lang/Object;

    .line 1245
    sput-object v3, Lorg/libsdl/app/SDLActivity;->expansionFileMethod:Ljava/lang/reflect/Method;

    .line 1246
    new-instance v2, Ljava/io/IOException;

    const-string v3, "Could not access APK expansion support library"

    invoke-direct {v2, v3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v2

    .line 1228
    .end local v1    # "ex":Ljava/lang/Exception;
    .end local v5    # "mainVersion":Ljava/lang/Integer;
    .end local v6    # "patchVersion":Ljava/lang/Integer;
    :catch_1
    move-exception v1

    .line 1229
    .local v1, "ex":Ljava/lang/NumberFormatException;
    invoke-virtual {v1}, Ljava/lang/NumberFormatException;->printStackTrace()V

    .line 1230
    new-instance v2, Ljava/io/IOException;

    const-string v3, "No valid file versions set for APK expansion files"

    invoke-direct {v2, v3, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v2

    .line 1253
    .end local v0    # "mainHint":Ljava/lang/String;
    .end local v1    # "ex":Ljava/lang/NumberFormatException;
    .end local v4    # "patchHint":Ljava/lang/String;
    :cond_2
    :goto_0
    :try_start_2
    sget-object v0, Lorg/libsdl/app/SDLActivity;->expansionFileMethod:Ljava/lang/reflect/Method;

    sget-object v3, Lorg/libsdl/app/SDLActivity;->expansionFile:Ljava/lang/Object;

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v1

    invoke-virtual {v0, v3, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/io/InputStream;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    .line 1258
    .local v0, "fileStream":Ljava/io/InputStream;
    nop

    .line 1260
    if-eqz v0, :cond_3

    .line 1265
    return-object v0

    .line 1262
    :cond_3
    new-instance v1, Ljava/io/IOException;

    const-string v2, "Could not find path in APK expansion file"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 1254
    .end local v0    # "fileStream":Ljava/io/InputStream;
    :catch_2
    move-exception v0

    .line 1256
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 1257
    new-instance v1, Ljava/io/IOException;

    const-string v2, "Could not open stream from APK expansion file"

    invoke-direct {v1, v2, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method public static requestPermission(Ljava/lang/String;I)V
    .locals 3
    .param p0, "permission"    # Ljava/lang/String;
    .param p1, "requestCode"    # I

    .line 1613
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x1

    const/16 v2, 0x17

    if-ge v0, v2, :cond_0

    .line 1614
    invoke-static {p1, v1}, Lorg/libsdl/app/SDLActivity;->nativePermissionResult(IZ)V

    .line 1615
    return-void

    .line 1618
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    check-cast v0, Landroid/app/Activity;

    .line 1619
    .local v0, "activity":Landroid/app/Activity;
    invoke-virtual {v0, p0}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_1

    .line 1620
    new-array v1, v1, [Ljava/lang/String;

    const/4 v2, 0x0

    aput-object p0, v1, v2

    invoke-virtual {v0, v1, p1}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    goto :goto_0

    .line 1622
    :cond_1
    invoke-static {p1, v1}, Lorg/libsdl/app/SDLActivity;->nativePermissionResult(IZ)V

    .line 1624
    :goto_0
    return-void
.end method

.method public static sendMessage(II)Z
    .locals 2
    .param p0, "command"    # I
    .param p1, "param"    # I

    .line 977
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    if-nez v0, :cond_0

    .line 978
    const/4 v0, 0x0

    return v0

    .line 980
    :cond_0
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Lorg/libsdl/app/SDLActivity;->sendCommand(ILjava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static setActivityTitle(Ljava/lang/String;)Z
    .locals 2
    .param p0, "title"    # Ljava/lang/String;

    .line 794
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p0}, Lorg/libsdl/app/SDLActivity;->sendCommand(ILjava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static setCustomCursor(I)Z
    .locals 4
    .param p0, "cursorID"    # I

    .line 1544
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x0

    const/16 v2, 0x18

    if-lt v0, v2, :cond_0

    .line 1546
    :try_start_0
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    sget-object v2, Lorg/libsdl/app/SDLActivity;->mCursors:Ljava/util/Hashtable;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/util/Hashtable;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/PointerIcon;

    invoke-virtual {v0, v2}, Lorg/libsdl/app/SDLSurface;->setPointerIcon(Landroid/view/PointerIcon;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1549
    nop

    .line 1553
    const/4 v0, 0x1

    return v0

    .line 1547
    :catch_0
    move-exception v0

    .line 1548
    .local v0, "e":Ljava/lang/Exception;
    return v1

    .line 1551
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_0
    return v1
.end method

.method public static setOrientation(IIZLjava/lang/String;)V
    .locals 1
    .param p0, "w"    # I
    .param p1, "h"    # I
    .param p2, "resizable"    # Z
    .param p3, "hint"    # Ljava/lang/String;

    .line 812
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    if-eqz v0, :cond_0

    .line 813
    invoke-virtual {v0, p0, p1, p2, p3}, Lorg/libsdl/app/SDLActivity;->setOrientationBis(IIZLjava/lang/String;)V

    .line 815
    :cond_0
    return-void
.end method

.method public static setRelativeMouseEnabled(Z)Z
    .locals 1
    .param p0, "enabled"    # Z

    .line 966
    if-eqz p0, :cond_0

    invoke-static {}, Lorg/libsdl/app/SDLActivity;->supportsRelativeMouse()Z

    move-result v0

    if-nez v0, :cond_0

    .line 967
    const/4 v0, 0x0

    return v0

    .line 970
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;

    move-result-object v0

    invoke-virtual {v0, p0}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->setRelativeMouseEnabled(Z)Z

    move-result v0

    return v0
.end method

.method public static setSurfaceViewFormat(I)V
    .locals 3
    .param p0, "format"    # I

    .line 1178
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x4

    invoke-virtual {v0, v2, v1}, Lorg/libsdl/app/SDLActivity;->sendCommand(ILjava/lang/Object;)Z

    .line 1179
    return-void
.end method

.method public static setSystemCursor(I)Z
    .locals 3
    .param p0, "cursorID"    # I

    .line 1560
    const/4 v0, 0x0

    .line 1561
    .local v0, "cursor_type":I
    packed-switch p0, :pswitch_data_0

    goto :goto_0

    .line 1596
    :pswitch_0
    const/16 v0, 0x3ea

    goto :goto_0

    .line 1593
    :pswitch_1
    const/16 v0, 0x3f4

    .line 1594
    goto :goto_0

    .line 1590
    :pswitch_2
    const/16 v0, 0x3fc

    .line 1591
    goto :goto_0

    .line 1587
    :pswitch_3
    const/16 v0, 0x3f7

    .line 1588
    goto :goto_0

    .line 1584
    :pswitch_4
    const/16 v0, 0x3f6

    .line 1585
    goto :goto_0

    .line 1581
    :pswitch_5
    const/16 v0, 0x3f8

    .line 1582
    goto :goto_0

    .line 1578
    :pswitch_6
    const/16 v0, 0x3f9

    .line 1579
    goto :goto_0

    .line 1575
    :pswitch_7
    const/16 v0, 0x3ec

    .line 1576
    goto :goto_0

    .line 1572
    :pswitch_8
    const/16 v0, 0x3ef

    .line 1573
    goto :goto_0

    .line 1569
    :pswitch_9
    const/16 v0, 0x3ec

    .line 1570
    goto :goto_0

    .line 1566
    :pswitch_a
    const/16 v0, 0x3f0

    .line 1567
    goto :goto_0

    .line 1563
    :pswitch_b
    const/16 v0, 0x3e8

    .line 1564
    nop

    .line 1599
    :goto_0
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x18

    if-lt v1, v2, :cond_0

    .line 1601
    :try_start_0
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2, v0}, Landroid/view/PointerIcon;->getSystemIcon(Landroid/content/Context;I)Landroid/view/PointerIcon;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/libsdl/app/SDLSurface;->setPointerIcon(Landroid/view/PointerIcon;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1604
    goto :goto_1

    .line 1602
    :catch_0
    move-exception v1

    .line 1603
    .local v1, "e":Ljava/lang/Exception;
    const/4 v2, 0x0

    return v2

    .line 1606
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_0
    :goto_1
    const/4 v1, 0x1

    return v1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static setWindowStyle(Z)V
    .locals 3
    .param p0, "fullscreen"    # Z

    .line 802
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x2

    invoke-virtual {v0, v2, v1}, Lorg/libsdl/app/SDLActivity;->sendCommand(ILjava/lang/Object;)Z

    .line 803
    return-void
.end method

.method public static shouldMinimizeOnFocusLoss()Z
    .locals 1

    .line 916
    const/4 v0, 0x0

    return v0
.end method

.method public static showTextInput(IIII)Z
    .locals 2
    .param p0, "x"    # I
    .param p1, "y"    # I
    .param p2, "w"    # I
    .param p3, "h"    # I

    .line 1151
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    iget-object v0, v0, Lorg/libsdl/app/SDLActivity;->commandHandler:Landroid/os/Handler;

    new-instance v1, Lorg/libsdl/app/SDLActivity$ShowTextInputTask;

    invoke-direct {v1, p0, p1, p2, p3}, Lorg/libsdl/app/SDLActivity$ShowTextInputTask;-><init>(IIII)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    move-result v0

    return v0
.end method

.method public static supportsRelativeMouse()Z
    .locals 3

    .line 943
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->isChromebook()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 944
    return v1

    .line 954
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1b

    if-ge v0, v2, :cond_1

    invoke-static {}, Lorg/libsdl/app/SDLActivity;->isDeXMode()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 955
    return v1

    .line 958
    :cond_1
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;

    move-result-object v0

    invoke-virtual {v0}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->supportsRelativeMouse()Z

    move-result v0

    return v0
.end method


# virtual methods
.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 3
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 487
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 488
    return v1

    .line 491
    :cond_0
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    .line 493
    .local v0, "keyCode":I
    const/16 v2, 0x19

    if-eq v0, v2, :cond_2

    const/16 v2, 0x18

    if-eq v0, v2, :cond_2

    const/16 v2, 0x1b

    if-eq v0, v2, :cond_2

    const/16 v2, 0xa8

    if-eq v0, v2, :cond_2

    const/16 v2, 0xa9

    if-ne v0, v2, :cond_1

    goto :goto_0

    .line 501
    :cond_1
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    move-result v1

    return v1

    .line 499
    :cond_2
    :goto_0
    return v1
.end method

.method protected getArguments()[Ljava/lang/String;
    .locals 1

    .line 164
    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/String;

    return-object v0
.end method

.method protected getLibraries()[Ljava/lang/String;
    .locals 2

    .line 139
    const-string v0, "SDL2"

    const-string v1, "main"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method protected getMainFunction()Ljava/lang/String;
    .locals 1

    .line 127
    const-string v0, "SDL_main"

    return-object v0
.end method

.method protected getMainSharedObject()Ljava/lang/String;
    .locals 4

    .line 113
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->getLibraries()[Ljava/lang/String;

    move-result-object v0

    .line 114
    .local v0, "libraries":[Ljava/lang/String;
    array-length v1, v0

    if-lez v1, :cond_0

    .line 115
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "lib"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    array-length v2, v0

    add-int/lit8 v2, v2, -0x1

    aget-object v2, v0, v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ".so"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .local v1, "library":Ljava/lang/String;
    goto :goto_0

    .line 117
    .end local v1    # "library":Ljava/lang/String;
    :cond_0
    const-string v1, "libmain.so"

    .line 119
    .restart local v1    # "library":Ljava/lang/String;
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v3

    iget-object v3, v3, Landroid/content/pm/ApplicationInfo;->nativeLibraryDir:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method public loadLibraries()V
    .locals 4

    .line 152
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->getLibraries()[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, v0, v2

    .line 153
    .local v3, "lib":Ljava/lang/String;
    invoke-static {v3}, Lorg/libsdl/app/SDL;->loadLibrary(Ljava/lang/String;)V

    .line 152
    .end local v3    # "lib":Ljava/lang/String;
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 155
    :cond_0
    return-void
.end method

.method public messageboxShowMessageBox(ILjava/lang/String;Ljava/lang/String;[I[I[Ljava/lang/String;[I)I
    .locals 5
    .param p1, "flags"    # I
    .param p2, "title"    # Ljava/lang/String;
    .param p3, "message"    # Ljava/lang/String;
    .param p4, "buttonFlags"    # [I
    .param p5, "buttonIds"    # [I
    .param p6, "buttonTexts"    # [Ljava/lang/String;
    .param p7, "colors"    # [I

    .line 1295
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    const/4 v1, 0x0

    const/4 v2, -0x1

    aput v2, v0, v1

    .line 1299
    array-length v0, p4

    array-length v3, p5

    if-eq v0, v3, :cond_0

    array-length v0, p5

    array-length v3, p6

    if-eq v0, v3, :cond_0

    .line 1300
    return v2

    .line 1305
    :cond_0
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 1306
    .local v0, "args":Landroid/os/Bundle;
    const-string v3, "flags"

    invoke-virtual {v0, v3, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 1307
    const-string v3, "title"

    invoke-virtual {v0, v3, p2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 1308
    const-string v3, "message"

    invoke-virtual {v0, v3, p3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 1309
    const-string v3, "buttonFlags"

    invoke-virtual {v0, v3, p4}, Landroid/os/Bundle;->putIntArray(Ljava/lang/String;[I)V

    .line 1310
    const-string v3, "buttonIds"

    invoke-virtual {v0, v3, p5}, Landroid/os/Bundle;->putIntArray(Ljava/lang/String;[I)V

    .line 1311
    const-string v3, "buttonTexts"

    invoke-virtual {v0, v3, p6}, Landroid/os/Bundle;->putStringArray(Ljava/lang/String;[Ljava/lang/String;)V

    .line 1312
    const-string v3, "colors"

    invoke-virtual {v0, v3, p7}, Landroid/os/Bundle;->putIntArray(Ljava/lang/String;[I)V

    .line 1316
    new-instance v3, Lorg/libsdl/app/SDLActivity$3;

    invoke-direct {v3, p0, v0}, Lorg/libsdl/app/SDLActivity$3;-><init>(Lorg/libsdl/app/SDLActivity;Landroid/os/Bundle;)V

    invoke-virtual {p0, v3}, Lorg/libsdl/app/SDLActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 1325
    iget-object v3, p0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    monitor-enter v3

    .line 1327
    :try_start_0
    iget-object v4, p0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    invoke-virtual {v4}, Ljava/lang/Object;->wait()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1331
    nop

    .line 1332
    :try_start_1
    monitor-exit v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1336
    iget-object v2, p0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    aget v1, v2, v1

    return v1

    .line 1332
    :catchall_0
    move-exception v1

    goto :goto_0

    .line 1328
    :catch_0
    move-exception v1

    .line 1329
    .local v1, "ex":Ljava/lang/InterruptedException;
    :try_start_2
    invoke-virtual {v1}, Ljava/lang/InterruptedException;->printStackTrace()V

    .line 1330
    monitor-exit v3

    return v2

    .line 1332
    .end local v1    # "ex":Ljava/lang/InterruptedException;
    :goto_0
    monitor-exit v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v1
.end method

.method public onBackPressed()V
    .locals 2

    .line 450
    const-string v0, "SDL_ANDROID_TRAP_BACK_BUTTON"

    invoke-static {v0}, Lorg/libsdl/app/SDLActivity;->nativeGetHint(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 451
    .local v0, "trapBack":Ljava/lang/String;
    if-eqz v0, :cond_0

    const-string v1, "1"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 453
    return-void

    .line 457
    :cond_0
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->isFinishing()Z

    move-result v1

    if-nez v1, :cond_1

    .line 458
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V

    .line 460
    :cond_1
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 188
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Device: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Landroid/os/Build;->DEVICE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SDL"

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 189
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Model: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v2, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 190
    const-string v0, "onCreate()"

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 191
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 194
    :try_start_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    const-string v2, "SDLActivity"

    invoke-virtual {v0, v2}, Ljava/lang/Thread;->setName(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 197
    goto :goto_0

    .line 195
    :catch_0
    move-exception v0

    .line 196
    .local v0, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "modify thread properties failed "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 200
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    const-string v0, ""

    .line 202
    .local v0, "errorMsgBrokenLib":Ljava/lang/String;
    const/4 v2, 0x1

    :try_start_1
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->loadLibraries()V
    :try_end_1
    .catch Ljava/lang/UnsatisfiedLinkError; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 211
    :goto_1
    goto :goto_2

    .line 207
    :catch_1
    move-exception v3

    .line 208
    .local v3, "e":Ljava/lang/Exception;
    sget-object v4, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 209
    sput-boolean v2, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    .line 210
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    goto :goto_2

    .line 203
    .end local v3    # "e":Ljava/lang/Exception;
    :catch_2
    move-exception v3

    .line 204
    .local v3, "e":Ljava/lang/UnsatisfiedLinkError;
    sget-object v4, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v3}, Ljava/lang/UnsatisfiedLinkError;->getMessage()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 205
    sput-boolean v2, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    .line 206
    invoke-virtual {v3}, Ljava/lang/UnsatisfiedLinkError;->getMessage()Ljava/lang/String;

    move-result-object v0

    .end local v3    # "e":Ljava/lang/UnsatisfiedLinkError;
    goto :goto_1

    .line 213
    :goto_2
    sget-boolean v2, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    .line 215
    sput-object p0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    .line 216
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 217
    .local v1, "dlgAlert":Landroid/app/AlertDialog$Builder;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "An error occurred while trying to start the application. Please try again and/or reinstall."

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 218
    const-string v4, "line.separator"

    invoke-static {v4}, Ljava/lang/System;->getProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 219
    invoke-static {v4}, Ljava/lang/System;->getProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "Error: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 217
    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 221
    const-string v2, "SDL Error"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 222
    new-instance v2, Lorg/libsdl/app/SDLActivity$1;

    invoke-direct {v2, p0}, Lorg/libsdl/app/SDLActivity$1;-><init>(Lorg/libsdl/app/SDLActivity;)V

    const-string v4, "Exit"

    invoke-virtual {v1, v4, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 230
    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    .line 231
    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v2

    invoke-virtual {v2}, Landroid/app/AlertDialog;->show()V

    .line 233
    return-void

    .line 237
    .end local v1    # "dlgAlert":Landroid/app/AlertDialog$Builder;
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDL;->setupJNI()V

    .line 240
    invoke-static {}, Lorg/libsdl/app/SDL;->initialize()V

    .line 243
    sput-object p0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    .line 244
    invoke-static {p0}, Lorg/libsdl/app/SDL;->setContext(Landroid/content/Context;)V

    .line 246
    new-instance v2, Lorg/libsdl/app/SDLClipboardHandler_API11;

    invoke-direct {v2}, Lorg/libsdl/app/SDLClipboardHandler_API11;-><init>()V

    sput-object v2, Lorg/libsdl/app/SDLActivity;->mClipboardHandler:Lorg/libsdl/app/SDLClipboardHandler;

    .line 252
    new-instance v2, Lorg/libsdl/app/SDLSurface;

    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->getApplication()Landroid/app/Application;

    move-result-object v4

    invoke-direct {v2, v4}, Lorg/libsdl/app/SDLSurface;-><init>(Landroid/content/Context;)V

    sput-object v2, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    .line 254
    new-instance v2, Landroid/widget/RelativeLayout;

    invoke-direct {v2, p0}, Landroid/widget/RelativeLayout;-><init>(Landroid/content/Context;)V

    sput-object v2, Lorg/libsdl/app/SDLActivity;->mLayout:Landroid/view/ViewGroup;

    .line 255
    sget-object v4, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v2, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 258
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getCurrentOrientation()I

    move-result v2

    sput v2, Lorg/libsdl/app/SDLActivity;->mCurrentOrientation:I

    .line 260
    invoke-static {v2}, Lorg/libsdl/app/SDLActivity;->onNativeOrientationChanged(I)V

    .line 262
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mLayout:Landroid/view/ViewGroup;

    invoke-virtual {p0, v2}, Lorg/libsdl/app/SDLActivity;->setContentView(Landroid/view/View;)V

    .line 264
    invoke-static {v3}, Lorg/libsdl/app/SDLActivity;->setWindowStyle(Z)V

    .line 266
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->getWindow()Landroid/view/Window;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/view/View;->setOnSystemUiVisibilityChangeListener(Landroid/view/View$OnSystemUiVisibilityChangeListener;)V

    .line 269
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    .line 270
    .local v2, "intent":Landroid/content/Intent;
    if-eqz v2, :cond_1

    invoke-virtual {v2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v3

    if-eqz v3, :cond_1

    .line 271
    invoke-virtual {v2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v3}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    move-result-object v3

    .line 272
    .local v3, "filename":Ljava/lang/String;
    if-eqz v3, :cond_1

    .line 273
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Got filename: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 274
    invoke-static {v3}, Lorg/libsdl/app/SDLActivity;->onNativeDropFile(Ljava/lang/String;)V

    .line 277
    .end local v3    # "filename":Ljava/lang/String;
    :cond_1
    return-void
.end method

.method protected onCreateDialog(ILandroid/os/Bundle;)Landroid/app/Dialog;
    .locals 20
    .param p1, "ignore"    # I
    .param p2, "args"    # Landroid/os/Bundle;

    .line 1346
    move-object/from16 v0, p0

    move-object/from16 v1, p2

    const-string v2, "colors"

    invoke-virtual {v1, v2}, Landroid/os/Bundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v2

    .line 1352
    .local v2, "colors":[I
    const/4 v3, 0x1

    if-eqz v2, :cond_0

    .line 1353
    const/4 v4, -0x1

    .line 1354
    .local v4, "i":I
    add-int/2addr v4, v3

    aget v5, v2, v4

    .line 1355
    .local v5, "backgroundColor":I
    add-int/2addr v4, v3

    aget v6, v2, v4

    .line 1356
    .local v6, "textColor":I
    add-int/2addr v4, v3

    aget v7, v2, v4

    .line 1357
    .local v7, "buttonBorderColor":I
    add-int/2addr v4, v3

    aget v8, v2, v4

    .line 1358
    .local v8, "buttonBackgroundColor":I
    add-int/2addr v4, v3

    aget v4, v2, v4

    .line 1359
    .local v4, "buttonSelectedColor":I
    goto :goto_0

    .line 1360
    .end local v4    # "buttonSelectedColor":I
    .end local v5    # "backgroundColor":I
    .end local v6    # "textColor":I
    .end local v7    # "buttonBorderColor":I
    .end local v8    # "buttonBackgroundColor":I
    :cond_0
    const/4 v5, 0x0

    .line 1361
    .restart local v5    # "backgroundColor":I
    const/4 v6, 0x0

    .line 1362
    .restart local v6    # "textColor":I
    const/4 v7, 0x0

    .line 1363
    .restart local v7    # "buttonBorderColor":I
    const/4 v8, 0x0

    .line 1364
    .restart local v8    # "buttonBackgroundColor":I
    const/4 v4, 0x0

    .line 1369
    .restart local v4    # "buttonSelectedColor":I
    :goto_0
    new-instance v9, Landroid/app/Dialog;

    invoke-direct {v9, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    .line 1370
    .local v9, "dialog":Landroid/app/Dialog;
    const-string v10, "title"

    invoke-virtual {v1, v10}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Landroid/app/Dialog;->setTitle(Ljava/lang/CharSequence;)V

    .line 1371
    const/4 v10, 0x0

    invoke-virtual {v9, v10}, Landroid/app/Dialog;->setCancelable(Z)V

    .line 1372
    new-instance v11, Lorg/libsdl/app/SDLActivity$4;

    invoke-direct {v11, v0}, Lorg/libsdl/app/SDLActivity$4;-><init>(Lorg/libsdl/app/SDLActivity;)V

    invoke-virtual {v9, v11}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    .line 1383
    new-instance v11, Landroid/widget/TextView;

    invoke-direct {v11, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1384
    .local v11, "message":Landroid/widget/TextView;
    const/16 v12, 0x11

    invoke-virtual {v11, v12}, Landroid/widget/TextView;->setGravity(I)V

    .line 1385
    const-string v13, "message"

    invoke-virtual {v1, v13}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v11, v13}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1386
    if-eqz v6, :cond_1

    .line 1387
    invoke-virtual {v11, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1392
    :cond_1
    const-string v13, "buttonFlags"

    invoke-virtual {v1, v13}, Landroid/os/Bundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v13

    .line 1393
    .local v13, "buttonFlags":[I
    const-string v14, "buttonIds"

    invoke-virtual {v1, v14}, Landroid/os/Bundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v14

    .line 1394
    .local v14, "buttonIds":[I
    const-string v15, "buttonTexts"

    invoke-virtual {v1, v15}, Landroid/os/Bundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v15

    .line 1396
    .local v15, "buttonTexts":[Ljava/lang/String;
    new-instance v16, Landroid/util/SparseArray;

    invoke-direct/range {v16 .. v16}, Landroid/util/SparseArray;-><init>()V

    move-object/from16 v17, v16

    .line 1398
    .local v17, "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1399
    .local v3, "buttons":Landroid/widget/LinearLayout;
    invoke-virtual {v3, v10}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1400
    invoke-virtual {v3, v12}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 1401
    const/4 v10, 0x0

    .local v10, "i":I
    :goto_1
    array-length v12, v15

    if-ge v10, v12, :cond_8

    .line 1402
    new-instance v12, Landroid/widget/Button;

    invoke-direct {v12, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    .line 1403
    .local v12, "button":Landroid/widget/Button;
    aget v1, v14, v10

    .line 1404
    .local v1, "id":I
    move-object/from16 v18, v2

    .end local v2    # "colors":[I
    .local v18, "colors":[I
    new-instance v2, Lorg/libsdl/app/SDLActivity$5;

    invoke-direct {v2, v0, v1, v9}, Lorg/libsdl/app/SDLActivity$5;-><init>(Lorg/libsdl/app/SDLActivity;ILandroid/app/Dialog;)V

    invoke-virtual {v12, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1411
    aget v2, v13, v10

    if-eqz v2, :cond_3

    .line 1413
    aget v2, v13, v10

    const/16 v16, 0x1

    and-int/lit8 v2, v2, 0x1

    if-eqz v2, :cond_2

    .line 1414
    const/16 v2, 0x42

    move/from16 v19, v1

    move-object/from16 v1, v17

    .end local v17    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .local v1, "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .local v19, "id":I
    invoke-virtual {v1, v2, v12}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_2

    .line 1413
    .end local v19    # "id":I
    .local v1, "id":I
    .restart local v17    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    :cond_2
    move/from16 v19, v1

    move-object/from16 v1, v17

    .line 1416
    .end local v17    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .local v1, "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .restart local v19    # "id":I
    :goto_2
    aget v2, v13, v10

    and-int/lit8 v2, v2, 0x2

    if-eqz v2, :cond_4

    .line 1417
    const/16 v2, 0x6f

    invoke-virtual {v1, v2, v12}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_3

    .line 1411
    .end local v19    # "id":I
    .local v1, "id":I
    .restart local v17    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    :cond_3
    move/from16 v19, v1

    move-object/from16 v1, v17

    .line 1420
    .end local v17    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .local v1, "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .restart local v19    # "id":I
    :cond_4
    :goto_3
    aget-object v2, v15, v10

    invoke-virtual {v12, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 1421
    if-eqz v6, :cond_5

    .line 1422
    invoke-virtual {v12, v6}, Landroid/widget/Button;->setTextColor(I)V

    .line 1424
    :cond_5
    nop

    .line 1427
    if-eqz v8, :cond_7

    .line 1428
    invoke-virtual {v12}, Landroid/widget/Button;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    .line 1429
    .local v2, "drawable":Landroid/graphics/drawable/Drawable;
    if-nez v2, :cond_6

    .line 1431
    invoke-virtual {v12, v8}, Landroid/widget/Button;->setBackgroundColor(I)V

    move/from16 v17, v4

    goto :goto_4

    .line 1434
    :cond_6
    move/from16 v17, v4

    .end local v4    # "buttonSelectedColor":I
    .local v17, "buttonSelectedColor":I
    sget-object v4, Landroid/graphics/PorterDuff$Mode;->MULTIPLY:Landroid/graphics/PorterDuff$Mode;

    invoke-virtual {v2, v8, v4}, Landroid/graphics/drawable/Drawable;->setColorFilter(ILandroid/graphics/PorterDuff$Mode;)V

    goto :goto_4

    .line 1427
    .end local v2    # "drawable":Landroid/graphics/drawable/Drawable;
    .end local v17    # "buttonSelectedColor":I
    .restart local v4    # "buttonSelectedColor":I
    :cond_7
    move/from16 v17, v4

    .line 1437
    .end local v4    # "buttonSelectedColor":I
    .restart local v17    # "buttonSelectedColor":I
    :goto_4
    nop

    .line 1440
    invoke-virtual {v3, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1401
    .end local v12    # "button":Landroid/widget/Button;
    .end local v19    # "id":I
    add-int/lit8 v10, v10, 0x1

    move/from16 v4, v17

    move-object/from16 v2, v18

    move-object/from16 v17, v1

    move-object/from16 v1, p2

    goto :goto_1

    .end local v1    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .end local v18    # "colors":[I
    .local v2, "colors":[I
    .restart local v4    # "buttonSelectedColor":I
    .local v17, "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    :cond_8
    move-object/from16 v18, v2

    move-object/from16 v1, v17

    move/from16 v17, v4

    .line 1445
    .end local v2    # "colors":[I
    .end local v4    # "buttonSelectedColor":I
    .end local v10    # "i":I
    .restart local v1    # "mapping":Landroid/util/SparseArray;, "Landroid/util/SparseArray<Landroid/widget/Button;>;"
    .local v17, "buttonSelectedColor":I
    .restart local v18    # "colors":[I
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1446
    .local v2, "content":Landroid/widget/LinearLayout;
    const/4 v4, 0x1

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1447
    invoke-virtual {v2, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1448
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1449
    if-eqz v5, :cond_9

    .line 1450
    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 1455
    :cond_9
    invoke-virtual {v9, v2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 1456
    new-instance v4, Lorg/libsdl/app/SDLActivity$6;

    invoke-direct {v4, v0, v1}, Lorg/libsdl/app/SDLActivity$6;-><init>(Lorg/libsdl/app/SDLActivity;Landroid/util/SparseArray;)V

    invoke-virtual {v9, v4}, Landroid/app/Dialog;->setOnKeyListener(Landroid/content/DialogInterface$OnKeyListener;)V

    .line 1470
    return-object v9
.end method

.method protected onDestroy()V
    .locals 4

    .line 413
    const-string v0, "SDL"

    const-string v1, "onDestroy()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 415
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mHIDDeviceManager:Lorg/libsdl/app/HIDDeviceManager;

    if-eqz v1, :cond_0

    .line 416
    invoke-static {v1}, Lorg/libsdl/app/HIDDeviceManager;->release(Lorg/libsdl/app/HIDDeviceManager;)V

    .line 417
    const/4 v1, 0x0

    sput-object v1, Lorg/libsdl/app/SDLActivity;->mHIDDeviceManager:Lorg/libsdl/app/HIDDeviceManager;

    .line 420
    :cond_0
    sget-boolean v1, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    if-eqz v1, :cond_1

    .line 421
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 422
    return-void

    .line 425
    :cond_1
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    if-eqz v1, :cond_2

    .line 428
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativeSendQuit()V

    .line 432
    :try_start_0
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    invoke-virtual {v1}, Ljava/lang/Thread;->join()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 435
    goto :goto_0

    .line 433
    :catch_0
    move-exception v1

    .line 434
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Problem stopping SDLThread: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 438
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_2
    :goto_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativeQuit()V

    .line 440
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 441
    return-void
.end method

.method public onLowMemory()V
    .locals 2

    .line 401
    const-string v0, "SDL"

    const-string v1, "onLowMemory()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 402
    invoke-super {p0}, Landroid/app/Activity;->onLowMemory()V

    .line 404
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    if-eqz v0, :cond_0

    .line 405
    return-void

    .line 408
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->nativeLowMemory()V

    .line 409
    return-void
.end method

.method protected onPause()V
    .locals 2

    .line 304
    const-string v0, "SDL"

    const-string v1, "onPause()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 305
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    .line 307
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mHIDDeviceManager:Lorg/libsdl/app/HIDDeviceManager;

    if-eqz v0, :cond_0

    .line 308
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lorg/libsdl/app/HIDDeviceManager;->setFrozen(Z)V

    .line 310
    :cond_0
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    if-nez v0, :cond_1

    .line 311
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->pauseNativeThread()V

    .line 313
    :cond_1
    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 2
    .param p1, "requestCode"    # I
    .param p2, "permissions"    # [Ljava/lang/String;
    .param p3, "grantResults"    # [I

    .line 1628
    array-length v0, p3

    const/4 v1, 0x0

    if-lez v0, :cond_0

    aget v0, p3, v1

    if-nez v0, :cond_0

    .line 1629
    const/4 v0, 0x1

    invoke-static {p1, v0}, Lorg/libsdl/app/SDLActivity;->nativePermissionResult(IZ)V

    goto :goto_0

    .line 1631
    :cond_0
    invoke-static {p1, v1}, Lorg/libsdl/app/SDLActivity;->nativePermissionResult(IZ)V

    .line 1633
    :goto_0
    return-void
.end method

.method protected onResume()V
    .locals 2

    .line 317
    const-string v0, "SDL"

    const-string v1, "onResume()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 318
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 320
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mHIDDeviceManager:Lorg/libsdl/app/HIDDeviceManager;

    if-eqz v0, :cond_0

    .line 321
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/libsdl/app/HIDDeviceManager;->setFrozen(Z)V

    .line 323
    :cond_0
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    if-nez v0, :cond_1

    .line 324
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->resumeNativeThread()V

    .line 326
    :cond_1
    return-void
.end method

.method protected onStart()V
    .locals 2

    .line 339
    const-string v0, "SDL"

    const-string v1, "onStart()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 340
    invoke-super {p0}, Landroid/app/Activity;->onStart()V

    .line 341
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    if-eqz v0, :cond_0

    .line 342
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->resumeNativeThread()V

    .line 344
    :cond_0
    return-void
.end method

.method protected onStop()V
    .locals 2

    .line 330
    const-string v0, "SDL"

    const-string v1, "onStop()"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 331
    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    .line 332
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    if-eqz v0, :cond_0

    .line 333
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->pauseNativeThread()V

    .line 335
    :cond_0
    return-void
.end method

.method public onSystemUiVisibilityChange(I)V
    .locals 4
    .param p1, "visibility"    # I

    .line 1488
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mFullscreenModeActive:Z

    if-eqz v0, :cond_1

    and-int/lit8 v0, p1, 0x4

    if-eqz v0, :cond_0

    and-int/lit8 v0, p1, 0x2

    if-nez v0, :cond_1

    .line 1490
    :cond_0
    invoke-virtual {p0}, Lorg/libsdl/app/SDLActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/View;->getHandler()Landroid/os/Handler;

    move-result-object v0

    .line 1491
    .local v0, "handler":Landroid/os/Handler;
    if-eqz v0, :cond_1

    .line 1492
    iget-object v1, p0, Lorg/libsdl/app/SDLActivity;->rehideSystemUi:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1493
    iget-object v1, p0, Lorg/libsdl/app/SDLActivity;->rehideSystemUi:Ljava/lang/Runnable;

    const-wide/16 v2, 0x7d0

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1497
    .end local v0    # "handler":Landroid/os/Handler;
    :cond_1
    return-void
.end method

.method protected onUnhandledMessage(ILjava/lang/Object;)Z
    .locals 1
    .param p1, "command"    # I
    .param p2, "param"    # Ljava/lang/Object;

    .line 575
    const/4 v0, 0x0

    return v0
.end method

.method public onWindowFocusChanged(Z)V
    .locals 2
    .param p1, "hasFocus"    # Z

    .line 375
    invoke-super {p0, p1}, Landroid/app/Activity;->onWindowFocusChanged(Z)V

    .line 376
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onWindowFocusChanged(): "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SDL"

    invoke-static {v1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 378
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    if-eqz v0, :cond_0

    .line 379
    return-void

    .line 382
    :cond_0
    sput-boolean p1, Lorg/libsdl/app/SDLActivity;->mHasFocus:Z

    .line 383
    if-eqz p1, :cond_1

    .line 384
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->RESUMED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 385
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getMotionListener()Lorg/libsdl/app/SDLGenericMotionListener_API12;

    move-result-object v0

    invoke-virtual {v0}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->reclaimRelativeMouseModeIfNeeded()V

    .line 387
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 388
    const/4 v0, 0x1

    invoke-static {v0}, Lorg/libsdl/app/SDLActivity;->nativeFocusChanged(Z)V

    goto :goto_0

    .line 391
    :cond_1
    const/4 v0, 0x0

    invoke-static {v0}, Lorg/libsdl/app/SDLActivity;->nativeFocusChanged(Z)V

    .line 392
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mHasMultiWindow:Z

    if-nez v0, :cond_2

    .line 393
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->PAUSED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 394
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 397
    :cond_2
    :goto_0
    return-void
.end method

.method protected pauseNativeThread()V
    .locals 1

    .line 280
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->PAUSED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 281
    const/4 v0, 0x0

    sput-boolean v0, Lorg/libsdl/app/SDLActivity;->mIsResumedCalled:Z

    .line 283
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    if-eqz v0, :cond_0

    .line 284
    return-void

    .line 287
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 288
    return-void
.end method

.method public pressBackButton()V
    .locals 1

    .line 469
    new-instance v0, Lorg/libsdl/app/SDLActivity$2;

    invoke-direct {v0, p0}, Lorg/libsdl/app/SDLActivity$2;-><init>(Lorg/libsdl/app/SDLActivity;)V

    invoke-virtual {p0, v0}, Lorg/libsdl/app/SDLActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 477
    return-void
.end method

.method protected resumeNativeThread()V
    .locals 1

    .line 291
    sget-object v0, Lorg/libsdl/app/SDLActivity$NativeState;->RESUMED:Lorg/libsdl/app/SDLActivity$NativeState;

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mNextNativeState:Lorg/libsdl/app/SDLActivity$NativeState;

    .line 292
    const/4 v0, 0x1

    sput-boolean v0, Lorg/libsdl/app/SDLActivity;->mIsResumedCalled:Z

    .line 294
    sget-boolean v0, Lorg/libsdl/app/SDLActivity;->mBrokenLibraries:Z

    if-eqz v0, :cond_0

    .line 295
    return-void

    .line 298
    :cond_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->handleNativeState()V

    .line 299
    return-void
.end method

.method sendCommand(ILjava/lang/Object;)Z
    .locals 9
    .param p1, "command"    # I
    .param p2, "data"    # Ljava/lang/Object;

    .line 698
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity;->commandHandler:Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/Handler;->obtainMessage()Landroid/os/Message;

    move-result-object v0

    .line 699
    .local v0, "msg":Landroid/os/Message;
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 700
    iput-object p2, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 701
    iget-object v1, p0, Lorg/libsdl/app/SDLActivity;->commandHandler:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    move-result v1

    .line 703
    .local v1, "result":Z
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x13

    if-lt v2, v3, :cond_4

    const/4 v2, 0x2

    if-ne p1, v2, :cond_4

    .line 707
    const/4 v2, 0x0

    .line 709
    .local v2, "bShouldWait":Z
    instance-of v3, p2, Ljava/lang/Integer;

    if-eqz v3, :cond_3

    .line 711
    const-string v3, "window"

    invoke-virtual {p0, v3}, Lorg/libsdl/app/SDLActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/WindowManager;

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    .line 712
    .local v3, "display":Landroid/view/Display;
    new-instance v4, Landroid/util/DisplayMetrics;

    invoke-direct {v4}, Landroid/util/DisplayMetrics;-><init>()V

    .line 713
    .local v4, "realMetrics":Landroid/util/DisplayMetrics;
    invoke-virtual {v3, v4}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 715
    iget v5, v4, Landroid/util/DisplayMetrics;->widthPixels:I

    sget-object v6, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v6}, Lorg/libsdl/app/SDLSurface;->getWidth()I

    move-result v6

    const/4 v7, 0x0

    const/4 v8, 0x1

    if-ne v5, v6, :cond_0

    iget v5, v4, Landroid/util/DisplayMetrics;->heightPixels:I

    sget-object v6, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    .line 716
    invoke-virtual {v6}, Lorg/libsdl/app/SDLSurface;->getHeight()I

    move-result v6

    if-ne v5, v6, :cond_0

    const/4 v5, 0x1

    goto :goto_0

    :cond_0
    const/4 v5, 0x0

    .line 718
    .local v5, "bFullscreenLayout":Z
    :goto_0
    move-object v6, p2

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    if-ne v6, v8, :cond_2

    .line 724
    if-nez v5, :cond_1

    const/4 v7, 0x1

    :cond_1
    move v2, v7

    goto :goto_1

    .line 730
    :cond_2
    move v2, v5

    .line 734
    .end local v3    # "display":Landroid/view/Display;
    .end local v4    # "realMetrics":Landroid/util/DisplayMetrics;
    .end local v5    # "bFullscreenLayout":Z
    :cond_3
    :goto_1
    if-eqz v2, :cond_4

    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v3

    if-eqz v3, :cond_4

    .line 744
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v3

    monitor-enter v3

    .line 746
    :try_start_0
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->getContext()Landroid/content/Context;

    move-result-object v4

    const-wide/16 v5, 0x1f4

    invoke-virtual {v4, v5, v6}, Ljava/lang/Object;->wait(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 750
    goto :goto_2

    .line 751
    :catchall_0
    move-exception v4

    goto :goto_3

    .line 748
    :catch_0
    move-exception v4

    .line 749
    .local v4, "ie":Ljava/lang/InterruptedException;
    :try_start_1
    invoke-virtual {v4}, Ljava/lang/InterruptedException;->printStackTrace()V

    .line 751
    .end local v4    # "ie":Ljava/lang/InterruptedException;
    :goto_2
    monitor-exit v3

    goto :goto_4

    :goto_3
    monitor-exit v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v4

    .line 755
    .end local v2    # "bShouldWait":Z
    :cond_4
    :goto_4
    return v1
.end method

.method public setOrientationBis(IIZLjava/lang/String;)V
    .locals 7
    .param p1, "w"    # I
    .param p2, "h"    # I
    .param p3, "resizable"    # Z
    .param p4, "hint"    # Ljava/lang/String;

    .line 822
    const/4 v0, -0x1

    .line 823
    .local v0, "orientation_landscape":I
    const/4 v1, -0x1

    .line 826
    .local v1, "orientation_portrait":I
    const-string v2, "LandscapeRight"

    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    const-string v4, "LandscapeLeft"

    if-eqz v3, :cond_0

    invoke-virtual {p4, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 827
    const/4 v0, 0x6

    goto :goto_0

    .line 828
    :cond_0
    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 829
    const/4 v0, 0x0

    goto :goto_0

    .line 830
    :cond_1
    invoke-virtual {p4, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 831
    const/16 v0, 0x8

    .line 834
    :cond_2
    :goto_0
    const-string v2, "Portrait"

    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    const-string v4, "PortraitUpsideDown"

    if-eqz v3, :cond_3

    invoke-virtual {p4, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 835
    const/4 v1, 0x7

    goto :goto_1

    .line 836
    :cond_3
    invoke-virtual {p4, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 837
    const/4 v1, 0x1

    goto :goto_1

    .line 838
    :cond_4
    invoke-virtual {p4, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_5

    .line 839
    const/16 v1, 0x9

    .line 842
    :cond_5
    :goto_1
    const/4 v2, 0x0

    const/4 v3, 0x1

    const/4 v4, -0x1

    if-ne v0, v4, :cond_6

    const/4 v5, 0x0

    goto :goto_2

    :cond_6
    const/4 v5, 0x1

    .line 843
    .local v5, "is_landscape_allowed":Z
    :goto_2
    if-ne v1, v4, :cond_7

    goto :goto_3

    :cond_7
    const/4 v2, 0x1

    .line 844
    .local v2, "is_portrait_allowed":Z
    :goto_3
    const/4 v3, -0x1

    .line 847
    .local v3, "req":I
    if-nez v2, :cond_a

    if-nez v5, :cond_a

    .line 848
    if-eqz p3, :cond_8

    .line 850
    const/16 v3, 0xa

    goto :goto_8

    .line 853
    :cond_8
    if-le p1, p2, :cond_9

    const/4 v4, 0x6

    goto :goto_4

    :cond_9
    const/4 v4, 0x7

    :goto_4
    move v3, v4

    goto :goto_8

    .line 857
    :cond_a
    if-eqz p3, :cond_d

    .line 858
    if-eqz v2, :cond_b

    if-eqz v5, :cond_b

    .line 860
    const/16 v3, 0xa

    goto :goto_8

    .line 863
    :cond_b
    if-eqz v5, :cond_c

    move v4, v0

    goto :goto_5

    :cond_c
    move v4, v1

    :goto_5
    move v3, v4

    goto :goto_8

    .line 867
    :cond_d
    if-eqz v2, :cond_f

    if-eqz v5, :cond_f

    .line 868
    if-le p1, p2, :cond_e

    move v4, v0

    goto :goto_6

    :cond_e
    move v4, v1

    :goto_6
    move v3, v4

    goto :goto_8

    .line 871
    :cond_f
    if-eqz v5, :cond_10

    move v4, v0

    goto :goto_7

    :cond_10
    move v4, v1

    :goto_7
    move v3, v4

    .line 876
    :goto_8
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "setOrientation() requestedOrientation="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " width="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " height="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " resizable="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " hint="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v6, "SDL"

    invoke-static {v6, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 877
    sget-object v4, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v4, v3}, Lorg/libsdl/app/SDLActivity;->setRequestedOrientation(I)V

    .line 878
    return-void
.end method

.method public superOnBackPressed()V
    .locals 0

    .line 481
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V

    .line 482
    return-void
.end method
