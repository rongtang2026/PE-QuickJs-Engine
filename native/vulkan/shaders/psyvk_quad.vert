#version 450
layout(location = 0) in vec2 inPos;
layout(location = 1) in vec2 inUV;
layout(location = 2) in vec4 inColor;
layout(location = 3) in float inSlot;
layout(location = 0) out vec2 outUV;
layout(location = 1) out vec4 outColor;
layout(location = 2) out flat int outSlot;
void main() {
    vec2 ndc = vec2(inPos.x * 2.0 - 1.0, inPos.y * 2.0 - 1.0);
    gl_Position = vec4(ndc, 0.0, 1.0);
    outUV = inUV; outColor = inColor; outSlot = int(inSlot);
}
