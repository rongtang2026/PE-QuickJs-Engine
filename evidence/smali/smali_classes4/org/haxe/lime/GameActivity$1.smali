.class Lorg/haxe/lime/GameActivity$1;
.super Ljava/lang/Object;
.source "GameActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/haxe/lime/GameActivity;->postUICallback(J)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$handle:J


# direct methods
.method constructor <init>(J)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 368
    iput-wide p1, p0, Lorg/haxe/lime/GameActivity$1;->val$handle:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 372
    iget-wide v0, p0, Lorg/haxe/lime/GameActivity$1;->val$handle:J

    invoke-static {v0, v1}, Lorg/haxe/lime/Lime;->onCallback(J)V

    .line 374
    return-void
.end method
