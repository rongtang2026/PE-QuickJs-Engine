.class Lorg/libsdl/app/SDLJoystickHandler_API16$RangeComparator;
.super Ljava/lang/Object;
.source "SDLControllerManager.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/libsdl/app/SDLJoystickHandler_API16;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "RangeComparator"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Landroid/view/InputDevice$MotionRange;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 149
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Landroid/view/InputDevice$MotionRange;Landroid/view/InputDevice$MotionRange;)I
    .locals 4
    .param p1, "arg0"    # Landroid/view/InputDevice$MotionRange;
    .param p2, "arg1"    # Landroid/view/InputDevice$MotionRange;

    .line 153
    invoke-virtual {p1}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v0

    .line 154
    .local v0, "arg0Axis":I
    invoke-virtual {p2}, Landroid/view/InputDevice$MotionRange;->getAxis()I

    move-result v1

    .line 155
    .local v1, "arg1Axis":I
    const/16 v2, 0x17

    const/16 v3, 0x16

    if-ne v0, v3, :cond_0

    .line 156
    const/16 v0, 0x17

    goto :goto_0

    .line 157
    :cond_0
    if-ne v0, v2, :cond_1

    .line 158
    const/16 v0, 0x16

    .line 160
    :cond_1
    :goto_0
    if-ne v1, v3, :cond_2

    .line 161
    const/16 v1, 0x17

    goto :goto_1

    .line 162
    :cond_2
    if-ne v1, v2, :cond_3

    .line 163
    const/16 v1, 0x16

    .line 166
    :cond_3
    :goto_1
    sub-int v2, v0, v1

    return v2
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 149
    check-cast p1, Landroid/view/InputDevice$MotionRange;

    check-cast p2, Landroid/view/InputDevice$MotionRange;

    invoke-virtual {p0, p1, p2}, Lorg/libsdl/app/SDLJoystickHandler_API16$RangeComparator;->compare(Landroid/view/InputDevice$MotionRange;Landroid/view/InputDevice$MotionRange;)I

    move-result p1

    return p1
.end method
