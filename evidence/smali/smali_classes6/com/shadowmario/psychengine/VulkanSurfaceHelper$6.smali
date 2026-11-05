.class Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;
.super Ljava/lang/Object;
.source "VulkanSurfaceHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->retry(Landroid/app/Activity;II)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$activity:Landroid/app/Activity;

.field final synthetic val$height:I

.field final synthetic val$mode:I

.field final synthetic val$width:I


# direct methods
.method constructor <init>(Landroid/app/Activity;III)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 357
    iput-object p1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$activity:Landroid/app/Activity;

    iput p2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$width:I

    iput p3, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$height:I

    iput p4, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$mode:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 360
    iget-object v0, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$activity:Landroid/app/Activity;

    iget v1, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$width:I

    iget v2, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$height:I

    iget v3, p0, Lcom/shadowmario/psychengine/VulkanSurfaceHelper$6;->val$mode:I

    invoke-static {v0, v1, v2, v3}, Lcom/shadowmario/psychengine/VulkanSurfaceHelper;->access$000(Landroid/app/Activity;III)Ljava/lang/String;

    .line 361
    return-void
.end method
