#pragma once
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_android.h>
#include <android/native_window.h>
#include <vector>
#include <string>
#include <cstdint>

#define PSYVK_TAG             "PsyVK"
#define PSYVK_HUD_LINES       3
#define PSYVK_HUD_SLOT_BASE   48
#define PSYVK_TEXT_SLOT_BASE  52
#define PSYVK_OFFSCREEN       20000.0f
#define PSYVK_MAX_SLOTS       96
#define PSYVK_MAX_QUADS       4096
#define PSYVK_TEX_REQ_SLOT_MIN 11
#define PSYVK_TEX_REQ_SLOT_MAX 47
#define PSYVK_TEX_REQ_PER_TICK 24
#define PSYVK_TEXT_CACHE_LINES 10
#define PSYVK_PROJ_WIDTH       1280.0f
#define PSYVK_PROJ_HEIGHT      720.0f

struct PsyVkVertex
{
    float x, y, u, v;
    float r, g, b, a;
    float slot;
};

struct PsyVkSlot
{
    VkImage          image       = VK_NULL_HANDLE;
    VkDeviceMemory   memory      = VK_NULL_HANDLE;
    VkImageView      view        = VK_NULL_HANDLE;
    VkDescriptorSet  descriptor  = VK_NULL_HANDLE;
    uint32_t         width       = 0;
    uint32_t         height      = 0;
};

struct PsyVkState
{
    ANativeWindow*  window          = nullptr;
    VkInstance      instance        = VK_NULL_HANDLE;
    VkPhysicalDevice physical      = VK_NULL_HANDLE;
    VkPhysicalDeviceProperties props {};
    VkDevice        device          = VK_NULL_HANDLE;
    VkQueue         queue           = VK_NULL_HANDLE;
    uint32_t        queueFamily     = 0;
    VkSurfaceKHR    surface         = VK_NULL_HANDLE;
    VkSwapchainKHR  swapchain       = VK_NULL_HANDLE;
    VkFormat        swapFormat      = VK_FORMAT_B8G8R8A8_UNORM;
    VkExtent2D      extent          { 0, 0 };
    std::vector<VkImage>        swapImages;
    std::vector<VkImageView>    swapViews;
    std::vector<VkFramebuffer>  framebuffers;
    VkRenderPass       renderPass   = VK_NULL_HANDLE;
    VkPipelineLayout   pipelineLayout = VK_NULL_HANDLE;
    VkPipeline         pipeline     = VK_NULL_HANDLE;
    VkDescriptorSetLayout setLayout = VK_NULL_HANDLE;
    VkDescriptorPool   descPool     = VK_NULL_HANDLE;
    VkCommandPool      commandPool  = VK_NULL_HANDLE;
    VkBuffer           vertexBuffer = VK_NULL_HANDLE;
    VkDeviceMemory     vertexMemory = VK_NULL_HANDLE;
    void*              vertexMapped = nullptr;
    VkSampler          sampler      = VK_NULL_HANDLE;
    VkSemaphore        imageReady   = VK_NULL_HANDLE;
    VkSemaphore        renderDone   = VK_NULL_HANDLE;
    VkCommandBuffer    commandBuffer = VK_NULL_HANDLE;
    PsyVkSlot          slots[PSYVK_MAX_SLOTS];
    std::vector<PsyVkVertex> vertices;
    std::vector<float>       pendingQuads;
    std::vector<float>       hudValues;
    std::string        hudLines[PSYVK_HUD_LINES];
    std::string        lastError;
    std::string        diag;
    uint32_t           width  = 0;
    uint32_t           height = 0;
    uint32_t           frames = 0;
    uint32_t           quads  = 0;
    bool               created = false;
    bool               overlayVisible = true;
};

extern PsyVkState g_psyvk;

// lifecycle (PsyVkRenderer.cpp)
std::string psyvk_create(ANativeWindow* window, int width, int height);
void        psyvk_destroy();
std::string psyvk_info();
std::string psyvk_diag();
std::string psyvk_hud_line(int id);

// resources
std::string psyvk_set_texture(int slot, const int* pixels, int width, int height);
std::string psyvk_add_texture(int slot, const int* pixels, int width, int height);
void        psyvk_set_atlas(const int* pixels, int width, int height,
                            const int* rects, int count);
void        psyvk_set_text(int id, const int* pixels, int width, int height);
void        psyvk_clear_text();
void        psyvk_set_hud_values(const float* values, int count);
void        psyvk_submit_quads(const float* quads, int count);
void        psyvk_pump_quads();
void        psyvk_push_text_quad(float x, float y, float w, float h, int slot);
bool        psyvk_draw_frame();
