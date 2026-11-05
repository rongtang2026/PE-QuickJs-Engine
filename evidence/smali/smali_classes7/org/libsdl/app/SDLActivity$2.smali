.class Lorg/libsdl/app/SDLActivity$2;
.super Ljava/lang/Object;
.source "SDLActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/libsdl/app/SDLActivity;->pressBackButton()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/SDLActivity;


# direct methods
.method constructor <init>(Lorg/libsdl/app/SDLActivity;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/SDLActivity;

    .line 469
    iput-object p1, p0, Lorg/libsdl/app/SDLActivity$2;->this$0:Lorg/libsdl/app/SDLActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 472
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity$2;->this$0:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_0

    .line 473
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity$2;->this$0:Lorg/libsdl/app/SDLActivity;

    invoke-virtual {v0}, Lorg/libsdl/app/SDLActivity;->superOnBackPressed()V

    .line 475
    :cond_0
    return-void
.end method
