.class Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;
.super Ljava/lang/Object;
.source "VulkanSurfaceHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->start(II)Ljava/lang/String;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$activity:Landroid/app/Activity;

.field final synthetic val$height:I

.field final synthetic val$latch:Ljava/util/concurrent/CountDownLatch;

.field final synthetic val$result:[Ljava/lang/String;

.field final synthetic val$width:I


# direct methods
.method constructor <init>([Ljava/lang/String;Landroid/app/Activity;IILjava/util/concurrent/CountDownLatch;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 170
    iput-object p1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$result:[Ljava/lang/String;

    iput-object p2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$activity:Landroid/app/Activity;

    iput p3, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$width:I

    iput p4, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$height:I

    iput-object p5, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$latch:Ljava/util/concurrent/CountDownLatch;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 173
    iget-object v0, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$result:[Ljava/lang/String;

    iget-object v1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$activity:Landroid/app/Activity;

    iget v2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$width:I

    iget v3, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$height:I

    const/4 v4, 0x0

    invoke-static {v1, v2, v3, v4}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->access$000(Landroid/app/Activity;III)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v0, v4

    .line 174
    iget-object v0, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$1;->val$latch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {v0}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 175
    return-void
.end method
