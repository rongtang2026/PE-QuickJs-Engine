.class Lorg/libsdl/app/SDLClipboardHandler_API11;
.super Ljava/lang/Object;
.source "SDLActivity.java"

# interfaces
.implements Lorg/libsdl/app/SDLClipboardHandler;
.implements Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;


# instance fields
.field protected mClipMgr:Landroid/content/ClipboardManager;


# direct methods
.method constructor <init>()V
    .locals 2

    .line 2304
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2305
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "clipboard"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    iput-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    .line 2306
    invoke-virtual {v0, p0}, Landroid/content/ClipboardManager;->addPrimaryClipChangedListener(Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;)V

    .line 2307
    return-void
.end method


# virtual methods
.method public clipboardGetText()Ljava/lang/String;
    .locals 2

    .line 2317
    iget-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    .line 2318
    .local v0, "text":Ljava/lang/CharSequence;
    if-eqz v0, :cond_0

    .line 2319
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    return-object v1

    .line 2321
    :cond_0
    const/4 v1, 0x0

    return-object v1
.end method

.method public clipboardHasText()Z
    .locals 1

    .line 2311
    iget-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    invoke-virtual {v0}, Landroid/content/ClipboardManager;->hasText()Z

    move-result v0

    return v0
.end method

.method public clipboardSetText(Ljava/lang/String;)V
    .locals 1
    .param p1, "string"    # Ljava/lang/String;

    .line 2326
    iget-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    invoke-virtual {v0, p0}, Landroid/content/ClipboardManager;->removePrimaryClipChangedListener(Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;)V

    .line 2327
    iget-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    invoke-virtual {v0, p1}, Landroid/content/ClipboardManager;->setText(Ljava/lang/CharSequence;)V

    .line 2328
    iget-object v0, p0, Lorg/libsdl/app/SDLClipboardHandler_API11;->mClipMgr:Landroid/content/ClipboardManager;

    invoke-virtual {v0, p0}, Landroid/content/ClipboardManager;->addPrimaryClipChangedListener(Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;)V

    .line 2329
    return-void
.end method

.method public onPrimaryClipChanged()V
    .locals 0

    .line 2333
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeClipboardChanged()V

    .line 2334
    return-void
.end method
