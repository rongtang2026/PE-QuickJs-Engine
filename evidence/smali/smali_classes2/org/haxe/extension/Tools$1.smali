.class Lorg/haxe/extension/Tools$1;
.super Ljava/lang/Object;
.source "Tools.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/haxe/extension/Tools;->makeToastText(Ljava/lang/String;IIII)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$duration:I

.field final synthetic val$gravity:I

.field final synthetic val$message:Ljava/lang/String;

.field final synthetic val$xOffset:I

.field final synthetic val$yOffset:I


# direct methods
.method constructor <init>(Ljava/lang/String;IIII)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 84
    iput-object p1, p0, Lorg/haxe/extension/Tools$1;->val$message:Ljava/lang/String;

    iput p2, p0, Lorg/haxe/extension/Tools$1;->val$duration:I

    iput p3, p0, Lorg/haxe/extension/Tools$1;->val$gravity:I

    iput p4, p0, Lorg/haxe/extension/Tools$1;->val$xOffset:I

    iput p5, p0, Lorg/haxe/extension/Tools$1;->val$yOffset:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 88
    sget-object v0, Lorg/haxe/extension/Extension;->mainContext:Landroid/content/Context;

    iget-object v1, p0, Lorg/haxe/extension/Tools$1;->val$message:Ljava/lang/String;

    iget v2, p0, Lorg/haxe/extension/Tools$1;->val$duration:I

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    .line 90
    .local v0, "toast":Landroid/widget/Toast;
    iget v1, p0, Lorg/haxe/extension/Tools$1;->val$gravity:I

    if-ltz v1, :cond_0

    .line 91
    iget v2, p0, Lorg/haxe/extension/Tools$1;->val$xOffset:I

    iget v3, p0, Lorg/haxe/extension/Tools$1;->val$yOffset:I

    invoke-virtual {v0, v1, v2, v3}, Landroid/widget/Toast;->setGravity(III)V

    .line 93
    :cond_0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 94
    return-void
.end method
