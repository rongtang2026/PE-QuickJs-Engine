.class Lorg/libsdl/app/SDLInputConnection;
.super Landroid/view/inputmethod/BaseInputConnection;
.source "SDLActivity.java"


# direct methods
.method public constructor <init>(Landroid/view/View;Z)V
    .locals 0
    .param p1, "targetView"    # Landroid/view/View;
    .param p2, "fullEditor"    # Z

    .line 2210
    invoke-direct {p0, p1, p2}, Landroid/view/inputmethod/BaseInputConnection;-><init>(Landroid/view/View;Z)V

    .line 2212
    return-void
.end method

.method public static native nativeCommitText(Ljava/lang/String;I)V
.end method


# virtual methods
.method public commitText(Ljava/lang/CharSequence;I)Z
    .locals 3
    .param p1, "text"    # Ljava/lang/CharSequence;
    .param p2, "newCursorPosition"    # I

    .line 2241
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    invoke-interface {p1}, Ljava/lang/CharSequence;->length()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 2242
    invoke-interface {p1, v0}, Ljava/lang/CharSequence;->charAt(I)C

    move-result v1

    .line 2243
    .local v1, "c":C
    const/16 v2, 0xa

    if-ne v1, v2, :cond_0

    .line 2244
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeSoftReturnKey()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 2245
    const/4 v2, 0x1

    return v2

    .line 2248
    :cond_0
    invoke-virtual {p0, v1}, Lorg/libsdl/app/SDLInputConnection;->nativeGenerateScancodeForUnichar(C)V

    .line 2241
    .end local v1    # "c":C
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 2251
    .end local v0    # "i":I
    :cond_1
    invoke-interface {p1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p2}, Lorg/libsdl/app/SDLInputConnection;->nativeCommitText(Ljava/lang/String;I)V

    .line 2253
    invoke-super {p0, p1, p2}, Landroid/view/inputmethod/BaseInputConnection;->commitText(Ljava/lang/CharSequence;I)Z

    move-result v0

    return v0
.end method

.method public deleteSurroundingText(II)Z
    .locals 5
    .param p1, "beforeLength"    # I
    .param p2, "afterLength"    # I

    .line 2274
    if-lez p1, :cond_3

    if-nez p2, :cond_3

    .line 2275
    const/4 v0, 0x1

    .line 2277
    .local v0, "ret":Z
    :goto_0
    add-int/lit8 v1, p1, -0x1

    .end local p1    # "beforeLength":I
    .local v1, "beforeLength":I
    if-lez p1, :cond_2

    .line 2278
    new-instance p1, Landroid/view/KeyEvent;

    const/4 v2, 0x0

    const/16 v3, 0x43

    invoke-direct {p1, v2, v3}, Landroid/view/KeyEvent;-><init>(II)V

    invoke-virtual {p0, p1}, Lorg/libsdl/app/SDLInputConnection;->sendKeyEvent(Landroid/view/KeyEvent;)Z

    move-result p1

    const/4 v4, 0x1

    if-eqz p1, :cond_0

    new-instance p1, Landroid/view/KeyEvent;

    invoke-direct {p1, v4, v3}, Landroid/view/KeyEvent;-><init>(II)V

    .line 2279
    invoke-virtual {p0, p1}, Lorg/libsdl/app/SDLInputConnection;->sendKeyEvent(Landroid/view/KeyEvent;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    goto :goto_1

    :cond_0
    const/4 p1, 0x0

    .line 2280
    .local p1, "ret_key":Z
    :goto_1
    if-eqz v0, :cond_1

    if-eqz p1, :cond_1

    const/4 v2, 0x1

    :cond_1
    move v0, v2

    .line 2281
    .end local p1    # "ret_key":Z
    move p1, v1

    goto :goto_0

    .line 2282
    :cond_2
    return v0

    .line 2285
    .end local v0    # "ret":Z
    .end local v1    # "beforeLength":I
    .local p1, "beforeLength":I
    :cond_3
    invoke-super {p0, p1, p2}, Landroid/view/inputmethod/BaseInputConnection;->deleteSurroundingText(II)Z

    move-result v0

    return v0
.end method

.method public native nativeGenerateScancodeForUnichar(C)V
.end method

.method public native nativeSetComposingText(Ljava/lang/String;I)V
.end method

.method public sendKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 2
    .param p1, "event"    # Landroid/view/KeyEvent;

    .line 2228
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v1, 0x42

    if-ne v0, v1, :cond_0

    .line 2229
    invoke-static {}, Lorg/libsdl/app/SDLActivity;->onNativeSoftReturnKey()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2230
    const/4 v0, 0x1

    return v0

    .line 2235
    :cond_0
    invoke-super {p0, p1}, Landroid/view/inputmethod/BaseInputConnection;->sendKeyEvent(Landroid/view/KeyEvent;)Z

    move-result v0

    return v0
.end method

.method public setComposingText(Ljava/lang/CharSequence;I)Z
    .locals 1
    .param p1, "text"    # Ljava/lang/CharSequence;
    .param p2, "newCursorPosition"    # I

    .line 2259
    invoke-interface {p1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0, p2}, Lorg/libsdl/app/SDLInputConnection;->nativeSetComposingText(Ljava/lang/String;I)V

    .line 2261
    invoke-super {p0, p1, p2}, Landroid/view/inputmethod/BaseInputConnection;->setComposingText(Ljava/lang/CharSequence;I)Z

    move-result v0

    return v0
.end method
