.class Lorg/libsdl/app/SDLMain;
.super Ljava/lang/Object;
.source "SDLActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method constructor <init>()V
    .locals 0

    .line 1639
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    .line 1643
    const-string v0, "SDL"

    sget-object v1, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v1}, Lorg/libsdl/app/SDLActivity;->getMainSharedObject()Ljava/lang/String;

    move-result-object v1

    .line 1644
    .local v1, "library":Ljava/lang/String;
    sget-object v2, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v2}, Lorg/libsdl/app/SDLActivity;->getMainFunction()Ljava/lang/String;

    move-result-object v2

    .line 1645
    .local v2, "function":Ljava/lang/String;
    sget-object v3, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v3}, Lorg/libsdl/app/SDLActivity;->getArguments()[Ljava/lang/String;

    move-result-object v3

    .line 1648
    .local v3, "arguments":[Ljava/lang/String;
    const/4 v4, -0x4

    :try_start_0
    invoke-static {v4}, Landroid/os/Process;->setThreadPriority(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1651
    goto :goto_0

    .line 1649
    :catch_0
    move-exception v4

    .line 1650
    .local v4, "e":Ljava/lang/Exception;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "modify thread properties failed "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v4}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1653
    .end local v4    # "e":Ljava/lang/Exception;
    :goto_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Running main function "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " from library "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1655
    invoke-static {v1, v2, v3}, Lorg/libsdl/app/SDLActivity;->nativeRunMain(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)I

    .line 1657
    const-string v4, "Finished main function"

    invoke-static {v0, v4}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 1659
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    if-eqz v0, :cond_1

    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_1

    .line 1663
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lorg/libsdl/app/SDLActivity;->mSDLThread:Ljava/lang/Thread;

    .line 1664
    sget-object v0, Lorg/libsdl/app/SDLActivity;->mSingleton:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->finish()V

    .line 1666
    :cond_1
    :goto_1
    return-void
.end method
