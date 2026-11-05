.class LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper$5;
.super Ljava/lang/Object;
.source "VulkanSurfaceHelper.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->addOverlay(Landroid/app/Activity;III)Ljava/lang/String;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 286
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;
    .param p2, "format"    # I
    .param p3, "w"    # I
    .param p4, "h"    # I

    .line 301
    invoke-static {p3}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$302(I)I

    .line 302
    invoke-static {p4}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$402(I)I

    .line 303
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "surfaceChanged "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "x"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$502(Ljava/lang/String;)Ljava/lang/String;

    .line 304
    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$500()Ljava/lang/String;

    move-result-object v0

    const-string v1, "PsyVK"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 305
    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    invoke-static {v0}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$600(Landroid/view/Surface;)V

    .line 306
    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 3
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 289
    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurfaceFrame()Landroid/graphics/Rect;

    move-result-object v0

    .line 290
    .local v0, "frame":Landroid/graphics/Rect;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v1

    if-lez v1, :cond_0

    .line 291
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v1

    invoke-static {v1}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$302(I)I

    .line 292
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v1

    invoke-static {v1}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$402(I)I

    .line 294
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "surfaceCreated "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$300()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$400()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$502(Ljava/lang/String;)Ljava/lang/String;

    .line 295
    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$500()Ljava/lang/String;

    move-result-object v1

    const-string v2, "PsyVK"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 296
    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v1

    invoke-static {v1}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$600(Landroid/view/Surface;)V

    .line 297
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 310
    const-string v0, "surfaceDestroyed"

    invoke-static {v0}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$502(Ljava/lang/String;)Ljava/lang/String;

    .line 311
    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$500()Ljava/lang/String;

    move-result-object v0

    const-string v1, "PsyVK"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 312
    invoke-static {}, LDingLing/pe/QuickJs/Engine/VulkanSurfaceHelper;->access$700()V

    .line 313
    return-void
.end method
