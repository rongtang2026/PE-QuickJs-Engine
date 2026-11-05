.class Lorg/libsdl/app/SDLActivity$5;
.super Ljava/lang/Object;
.source "SDLActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/libsdl/app/SDLActivity;->onCreateDialog(ILandroid/os/Bundle;)Landroid/app/Dialog;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/libsdl/app/SDLActivity;

.field final synthetic val$dialog:Landroid/app/Dialog;

.field final synthetic val$id:I


# direct methods
.method constructor <init>(Lorg/libsdl/app/SDLActivity;ILandroid/app/Dialog;)V
    .locals 0
    .param p1, "this$0"    # Lorg/libsdl/app/SDLActivity;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1404
    iput-object p1, p0, Lorg/libsdl/app/SDLActivity$5;->this$0:Lorg/libsdl/app/SDLActivity;

    iput p2, p0, Lorg/libsdl/app/SDLActivity$5;->val$id:I

    iput-object p3, p0, Lorg/libsdl/app/SDLActivity$5;->val$dialog:Landroid/app/Dialog;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 3
    .param p1, "v"    # Landroid/view/View;

    .line 1407
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity$5;->this$0:Lorg/libsdl/app/SDLActivity;

    iget-object v0, v0, Lorg/libsdl/app/SDLActivity;->messageboxSelection:[I

    iget v1, p0, Lorg/libsdl/app/SDLActivity$5;->val$id:I

    const/4 v2, 0x0

    aput v1, v0, v2

    .line 1408
    iget-object v0, p0, Lorg/libsdl/app/SDLActivity$5;->val$dialog:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    .line 1409
    return-void
.end method
