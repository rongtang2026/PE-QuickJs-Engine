.class Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;
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

.field final synthetic val$width:I


# direct methods
.method constructor <init>(Landroid/app/Activity;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 182
    iput-object p1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$activity:Landroid/app/Activity;

    iput p2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$width:I

    iput p3, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$height:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 185
    invoke-static {}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->access$100()Z

    move-result v0

    if-nez v0, :cond_0

    .line 186
    iget-object v0, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$activity:Landroid/app/Activity;

    iget v1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$width:I

    iget v2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$2;->val$height:I

    invoke-static {v0, v1, v2}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->access$200(Landroid/app/Activity;II)V

    .line 188
    :cond_0
    return-void
.end method
