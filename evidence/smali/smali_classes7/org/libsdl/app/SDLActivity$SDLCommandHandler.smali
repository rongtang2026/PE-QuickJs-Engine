.class public Lorg/libsdl/app/SDLActivity$SDLCommandHandler;
.super Landroid/os/Handler;
.source "SDLActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/libsdl/app/SDLActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "SDLCommandHandler"
.end annotation


# direct methods
.method protected constructor <init>()V
    .locals 0

    .line 583
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 7
    .param p1, "msg"    # Landroid/os/Message;

    .line 586
    invoke-static {}, Lorg/libsdl/app/SDL;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 587
    .local v0, "context":Landroid/content/Context;
    const-string v1, "SDL"

    if-nez v0, :cond_0

    .line 588
    const-string v2, "error handling message, getContext() returned null"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 589
    return-void

    .line 591
    :cond_0
    iget v2, p1, Landroid/os/Message;->arg1:I

    const/4 v3, 0x1

    const-string v4, "error handling message, getContext() returned no Activity"

    const/4 v5, 0x0

    packed-switch v2, :pswitch_data_0

    .line 686
    instance-of v2, v0, Lorg/libsdl/app/SDLActivity;

    if-eqz v2, :cond_c

    move-object v2, v0

    check-cast v2, Lorg/libsdl/app/SDLActivity;

    iget v3, p1, Landroid/os/Message;->arg1:I

    iget-object v4, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v2, v3, v4}, Lorg/libsdl/app/SDLActivity;->onUnhandledMessage(ILjava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_c

    .line 687
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "error handling message, command is "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v3, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_3

    .line 647
    :pswitch_0
    instance-of v1, v0, Landroid/app/Activity;

    if-eqz v1, :cond_c

    .line 648
    move-object v1, v0

    check-cast v1, Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    .line 649
    .local v1, "window":Landroid/view/Window;
    if-eqz v1, :cond_2

    .line 650
    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    instance-of v2, v2, Ljava/lang/Integer;

    const/16 v3, 0x80

    if-eqz v2, :cond_1

    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    if-eqz v2, :cond_1

    .line 651
    invoke-virtual {v1, v3}, Landroid/view/Window;->addFlags(I)V

    goto :goto_0

    .line 653
    :cond_1
    invoke-virtual {v1, v3}, Landroid/view/Window;->clearFlags(I)V

    .line 656
    .end local v1    # "window":Landroid/view/Window;
    :cond_2
    :goto_0
    goto/16 :goto_3

    .line 661
    :pswitch_1
    iget-object v1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 664
    .local v1, "format":I
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    if-nez v2, :cond_3

    .line 665
    return-void

    .line 668
    :cond_3
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v2}, Lorg/libsdl/app/SDLSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v2

    .line 669
    .local v2, "holder":Landroid/view/SurfaceHolder;
    if-nez v2, :cond_4

    .line 670
    return-void

    .line 673
    :cond_4
    if-ne v1, v3, :cond_5

    .line 674
    const/4 v3, 0x1

    .local v3, "pf":I
    goto :goto_1

    .line 675
    .end local v3    # "pf":I
    :cond_5
    const/4 v3, 0x2

    if-ne v1, v3, :cond_6

    .line 676
    const/4 v3, 0x2

    .restart local v3    # "pf":I
    goto :goto_1

    .line 678
    .end local v3    # "pf":I
    :cond_6
    const/4 v3, 0x4

    .line 681
    .restart local v3    # "pf":I
    :goto_1
    invoke-interface {v2, v3}, Landroid/view/SurfaceHolder;->setFormat(I)V

    .line 683
    goto/16 :goto_3

    .line 631
    .end local v1    # "format":I
    .end local v2    # "holder":Landroid/view/SurfaceHolder;
    .end local v3    # "pf":I
    :pswitch_2
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mTextEdit:Landroid/view/View;

    if-eqz v1, :cond_c

    .line 635
    sget-object v1, Lorg/libsdl/app/SDLActivity;->mTextEdit:Landroid/view/View;

    new-instance v2, Landroid/widget/RelativeLayout$LayoutParams;

    invoke-direct {v2, v5, v5}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 637
    const-string v1, "input_method"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/inputmethod/InputMethodManager;

    .line 638
    .local v1, "imm":Landroid/view/inputmethod/InputMethodManager;
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mTextEdit:Landroid/view/View;

    invoke-virtual {v2}, Landroid/view/View;->getWindowToken()Landroid/os/IBinder;

    move-result-object v2

    invoke-virtual {v1, v2, v5}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z

    .line 640
    sput-boolean v5, Lorg/libsdl/app/SDLActivity;->mScreenKeyboardShown:Z

    .line 642
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mSurface:Lorg/libsdl/app/SDLSurface;

    invoke-virtual {v2}, Lorg/libsdl/app/SDLSurface;->requestFocus()Z

    .line 643
    .end local v1    # "imm":Landroid/view/inputmethod/InputMethodManager;
    goto :goto_3

    .line 600
    :pswitch_3
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v6, 0x13

    if-ge v2, v6, :cond_7

    .line 602
    goto :goto_3

    .line 604
    :cond_7
    instance-of v2, v0, Landroid/app/Activity;

    if-eqz v2, :cond_a

    .line 605
    move-object v1, v0

    check-cast v1, Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    .line 606
    .local v1, "window":Landroid/view/Window;
    if-eqz v1, :cond_9

    .line 607
    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    instance-of v2, v2, Ljava/lang/Integer;

    const/16 v4, 0x400

    const/16 v6, 0x800

    if-eqz v2, :cond_8

    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    if-eqz v2, :cond_8

    .line 608
    const/16 v2, 0x1706

    .line 614
    .local v2, "flags":I
    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v5

    invoke-virtual {v5, v2}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 615
    invoke-virtual {v1, v4}, Landroid/view/Window;->addFlags(I)V

    .line 616
    invoke-virtual {v1, v6}, Landroid/view/Window;->clearFlags(I)V

    .line 617
    sput-boolean v3, Lorg/libsdl/app/SDLActivity;->mFullscreenModeActive:Z

    .line 618
    .end local v2    # "flags":I
    goto :goto_2

    .line 619
    :cond_8
    const/16 v2, 0x100

    .line 620
    .restart local v2    # "flags":I
    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 621
    invoke-virtual {v1, v6}, Landroid/view/Window;->addFlags(I)V

    .line 622
    invoke-virtual {v1, v4}, Landroid/view/Window;->clearFlags(I)V

    .line 623
    sput-boolean v5, Lorg/libsdl/app/SDLActivity;->mFullscreenModeActive:Z

    .line 626
    .end local v1    # "window":Landroid/view/Window;
    .end local v2    # "flags":I
    :cond_9
    :goto_2
    goto :goto_3

    .line 627
    :cond_a
    invoke-static {v1, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 629
    goto :goto_3

    .line 593
    :pswitch_4
    instance-of v2, v0, Landroid/app/Activity;

    if-eqz v2, :cond_b

    .line 594
    move-object v1, v0

    check-cast v1, Landroid/app/Activity;

    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/app/Activity;->setTitle(Ljava/lang/CharSequence;)V

    goto :goto_3

    .line 596
    :cond_b
    invoke-static {v1, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 690
    :cond_c
    :goto_3
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
