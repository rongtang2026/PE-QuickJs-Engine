.class Lorg/libsdl/app/SDLGenericMotionListener_API24;
.super Lorg/libsdl/app/SDLGenericMotionListener_API12;
.source "SDLControllerManager.java"


# instance fields
.field private mRelativeModeEnabled:Z


# direct methods
.method constructor <init>()V
    .locals 0

    .line 613
    invoke-direct {p0}, Lorg/libsdl/app/SDLGenericMotionListener_API12;-><init>()V

    return-void
.end method


# virtual methods
.method public getEventX(Landroid/view/MotionEvent;)F
    .locals 1
    .param p1, "event"    # Landroid/view/MotionEvent;

    .line 656
    iget-boolean v0, p0, Lorg/libsdl/app/SDLGenericMotionListener_API24;->mRelativeModeEnabled:Z

    if-eqz v0, :cond_0

    .line 657
    const/16 v0, 0x1b

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getAxisValue(I)F

    move-result v0

    return v0

    .line 660
    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getX(I)F

    move-result v0

    return v0
.end method

.method public getEventY(Landroid/view/MotionEvent;)F
    .locals 1
    .param p1, "event"    # Landroid/view/MotionEvent;

    .line 666
    iget-boolean v0, p0, Lorg/libsdl/app/SDLGenericMotionListener_API24;->mRelativeModeEnabled:Z

    if-eqz v0, :cond_0

    .line 667
    const/16 v0, 0x1c

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getAxisValue(I)F

    move-result v0

    return v0

    .line 670
    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result v0

    return v0
.end method

.method public inRelativeMode()Z
    .locals 1

    .line 645
    iget-boolean v0, p0, Lorg/libsdl/app/SDLGenericMotionListener_API24;->mRelativeModeEnabled:Z

    return v0
.end method

.method public onGenericMotion(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 5
    .param p1, "v"    # Landroid/view/View;
    .param p2, "event"    # Landroid/view/MotionEvent;

    .line 622
    iget-boolean v0, p0, Lorg/libsdl/app/SDLGenericMotionListener_API24;->mRelativeModeEnabled:Z

    if-eqz v0, :cond_0

    .line 623
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getSource()I

    move-result v0

    const/16 v1, 0x2002

    if-ne v0, v1, :cond_0

    .line 624
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 625
    .local v0, "action":I
    const/4 v1, 0x7

    if-ne v0, v1, :cond_0

    .line 626
    const/16 v1, 0x1b

    invoke-virtual {p2, v1}, Landroid/view/MotionEvent;->getAxisValue(I)F

    move-result v1

    .line 627
    .local v1, "x":F
    const/16 v2, 0x1c

    invoke-virtual {p2, v2}, Landroid/view/MotionEvent;->getAxisValue(I)F

    move-result v2

    .line 628
    .local v2, "y":F
    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-static {v3, v0, v1, v2, v4}, Lorg/libsdl/app/SDLActivity;->onNativeMouse(IIFFZ)V

    .line 629
    return v4

    .line 635
    .end local v0    # "action":I
    .end local v1    # "x":F
    .end local v2    # "y":F
    :cond_0
    invoke-super {p0, p1, p2}, Lorg/libsdl/app/SDLGenericMotionListener_API12;->onGenericMotion(Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v0

    return v0
.end method

.method public setRelativeMouseEnabled(Z)Z
    .locals 1
    .param p1, "enabled"    # Z

    .line 650
    iput-boolean p1, p0, Lorg/libsdl/app/SDLGenericMotionListener_API24;->mRelativeModeEnabled:Z

    .line 651
    const/4 v0, 0x1

    return v0
.end method

.method public supportsRelativeMouse()Z
    .locals 1

    .line 640
    const/4 v0, 0x1

    return v0
.end method
